--- Slash command registry for Orbit agents.
--
-- Lightweight system for registering user-typed `/commands` (e.g. `/help`,
-- `/reset`, `/skill summarize`) and dispatching them inside an agent loop.
--
-- A command is a plain table:
--
--     {
--         name = "help",                       -- canonical name (no leading slash)
--         description = "Show available commands",
--         aliases = { "h", "?" },              -- optional
--         usage = "/help [command]",           -- optional, shown by /help
--         handler = function(args, shared)
--             -- args:   array of string tokens after the command name
--             -- shared: the flow's shared state table
--             -- return: result, action
--             --   result -> string|nil  (a reply to show the user)
--             --   action -> string|nil  ("handled" | "passthrough" | "exit" | custom)
--             -- If action is nil it defaults to "handled".
--         end,
--     }
--
-- Typical use is via @{command_nodes.make_command_router}, but the
-- registry can also be driven directly from any node.
--
-- @module command_registry

local M = {}

----------------------------------------------------------------------
-- Internal helpers
----------------------------------------------------------------------

local function strip(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

----------------------------------------------------------------------
-- Registry
----------------------------------------------------------------------

local Registry = {}
Registry.__index = Registry

--- Create a fresh, empty registry.
-- @return Registry
function M.new()
    return setmetatable({
        _commands = {},   -- name -> command
        _aliases  = {},   -- alias -> canonical name
    }, Registry)
end

--- Register a command.
-- @param cmd table A command definition (see module docs).
-- @return Registry self (for chaining)
function Registry:register(cmd)
    assert(type(cmd) == "table", "command must be a table")
    assert(type(cmd.name) == "string" and cmd.name ~= "", "command.name required")
    assert(type(cmd.handler) == "function", "command.handler required")

    self._commands[cmd.name] = cmd

    if cmd.aliases then
        for _, alias in ipairs(cmd.aliases) do
            self._aliases[alias] = cmd.name
        end
    end

    return self
end

--- Remove a command (and any aliases pointing at it).
-- @param name string Canonical command name.
-- @return boolean true if a command was removed.
function Registry:unregister(name)
    if not self._commands[name] then return false end

    self._commands[name] = nil

    for alias, target in pairs(self._aliases) do
        if target == name then
            self._aliases[alias] = nil
        end
    end

    return true
end

--- Look up a command by name or alias.
-- @param name string
-- @return table? command, string? canonical name
function Registry:get(name)
    if not name then return nil end

    local canonical = self._aliases[name] or name
    local cmd = self._commands[canonical]

    if cmd then return cmd, canonical end
    return nil
end

--- List all registered commands, sorted by name.
-- @return table Array of command tables.
function Registry:list()
    local names = {}
    for name in pairs(self._commands) do
        table.insert(names, name)
    end
    table.sort(names)

    local out = {}
    for _, n in ipairs(names) do
        table.insert(out, self._commands[n])
    end
    return out
end

----------------------------------------------------------------------
-- Parsing
----------------------------------------------------------------------

--- Parse a raw line of user input.
--
-- A "command line" is any string whose first non-whitespace character is `/`.
-- Tokens are whitespace-separated. Double-quoted substrings are kept as a
-- single token (with the quotes stripped).
--
--     parse("/skill summarize \"my text here\"")
--     -- -> { is_command = true, name = "skill",
--     --      args = {"summarize", "my text here"}, raw = "..." }
--
-- For non-command input, `is_command` is false and `text` holds the original
-- string so the caller can forward it to the LLM.
--
-- @param line string
-- @return table parse result
function M.parse(line)
    if type(line) ~= "string" then
        return { is_command = false, text = "" }
    end

    local trimmed = strip(line)

    if trimmed:sub(1, 1) ~= "/" then
        return { is_command = false, text = line }
    end

    local body = trimmed:sub(2)
    local tokens = {}
    local i, n = 1, #body

    while i <= n do
        -- skip whitespace
        while i <= n and body:sub(i, i):match("%s") do
            i = i + 1
        end
        if i > n then break end

        local c = body:sub(i, i)

        if c == '"' then
            local j = body:find('"', i + 1, true)
            if j then
                table.insert(tokens, body:sub(i + 1, j - 1))
                i = j + 1
            else
                -- unmatched quote: take the rest of the line literally
                table.insert(tokens, body:sub(i + 1))
                break
            end
        else
            local j = i
            while j <= n and not body:sub(j, j):match("%s") do
                j = j + 1
            end
            table.insert(tokens, body:sub(i, j - 1))
            i = j
        end
    end

    local name = tokens[1]
    local args = {}
    for k = 2, #tokens do args[k - 1] = tokens[k] end

    return {
        is_command = true,
        name = name,
        args = args,
        raw = line,
    }
end

----------------------------------------------------------------------
-- Dispatch
----------------------------------------------------------------------

--- Execute a parsed (or raw) command against this registry.
--
-- Returns a result table with shape:
--
--     {
--         ok       = boolean,    -- true if a handler ran without error
--         handled  = boolean,    -- true if the input matched a command
--         action   = string,     -- "handled" | "passthrough" | "exit" | custom | "error"
--         result   = string?,    -- reply text from the handler (if any)
--         error    = string?,    -- error message if ok == false
--         name     = string?,    -- canonical name that matched
--     }
--
-- @param input string|table A raw line or a parsed result from @{parse}.
-- @param shared table The flow's shared state, passed through to the handler.
-- @return table dispatch result
function Registry:dispatch(input, shared)
    local parsed = type(input) == "table" and input or M.parse(input)

    if not parsed.is_command then
        return {
            ok      = true,
            handled = false,
            action  = "passthrough",
            result  = nil,
        }
    end

    local cmd, canonical = self:get(parsed.name)

    if not cmd then
        return {
            ok      = false,
            handled = false,
            action  = "error",
            error   = "Unknown command: /" .. tostring(parsed.name),
        }
    end

    local ok, result, action = pcall(cmd.handler, parsed.args or {}, shared or {})

    if not ok then
        return {
            ok      = false,
            handled = true,
            action  = "error",
            error   = tostring(result),
            name    = canonical,
        }
    end

    return {
        ok      = true,
        handled = true,
        action  = action or "handled",
        result  = result,
        name    = canonical,
    }
end

----------------------------------------------------------------------
-- Convenience
----------------------------------------------------------------------

--- Render a human-readable help table for a registry.
-- @param registry Registry
-- @return string
function M.format_help(registry)
    local lines = { "Available commands:" }

    for _, cmd in ipairs(registry:list()) do
        local left = "/" .. cmd.name
        if cmd.aliases and #cmd.aliases > 0 then
            left = left .. " (/" .. table.concat(cmd.aliases, ", /") .. ")"
        end
        local right = cmd.description or ""
        table.insert(lines, string.format("  %-22s %s", left, right))
    end

    return table.concat(lines, "\n")
end

M.Registry = Registry
return M
