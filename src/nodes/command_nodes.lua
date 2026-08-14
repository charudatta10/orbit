--- Nodes for routing slash commands inside an Orbit flow.
--
-- Drops into any chat-style loop: the router node reads a line of user input
-- (or pulls one from `shared`), checks whether it starts with `/`, and either
-- dispatches it through a @{command_registry.Registry} or hands the line off
-- to the LLM node downstream.
--
-- Example:
--
--     local pf       = require("orbit")
--     local cmd_nodes = require("orbit.nodes.command_nodes")
--
--     local registry = cmd_nodes.default_registry()
--     local router   = cmd_nodes.make_command_router({ registry = registry })
--     local llm      = pf.node(function(shared)
--         -- ... call your LLM with shared.last_input ...
--         return "loop"
--     end)
--
--     router:to("passthrough", llm)
--     router:to("handled",     router)   -- echo + re-prompt
--     router:to("exit",        nil)      -- terminate the flow
--     llm:to("loop",           router)
--
--     pf.run(router, {})
--
-- @module command_nodes

local pf       = require("orbit")
local registry_mod = require("orbit.utils.command_registry")

local M = {}

----------------------------------------------------------------------
-- Default I/O (overridable for tests)
----------------------------------------------------------------------

local function default_read(prompt)
    if prompt then io.write(prompt) end
    return io.read()
end

local function default_write(text)
    if text and text ~= "" then
        print(text)
    end
end

----------------------------------------------------------------------
-- Router node
----------------------------------------------------------------------

--- Create a router node that handles slash commands.
--
-- Options:
--
--   * `registry` (Registry, required) — the command registry to dispatch through.
--   * `prompt`   (string)   — prompt shown before reading input. Default `"\nYou: "`.
--   * `read`     (function) — reads a line; signature `(prompt) -> string?`. Default `io.read`.
--   * `write`    (function) — writes a line; signature `(text)` -> nil. Default `print`.
--   * `input_key`(string)   — if set, reuses `shared[input_key]` instead of calling `read`. After dispatch the key is cleared so the next iteration reads fresh.
--   * `store_key`(string)   — where to stash non-command input for downstream nodes. Default `"last_input"`.
--
-- The returned node yields one of these actions:
--
--   * `"handled"`      — a command ran successfully.
--   * `"passthrough"`  — input wasn't a command; forward `shared[store_key]` to your LLM.
--   * `"exit"`         — command (or empty input) signaled termination; node returns `nil`.
--   * `"error"`        — unknown command / handler error; message is in `shared.last_command_error`.
--
-- @param opts table
-- @return Node
function M.make_command_router(opts)
    opts = opts or {}
    assert(opts.registry, "make_command_router: opts.registry is required")

    local registry  = opts.registry
    local prompt    = opts.prompt    or "\nYou: "
    local read      = opts.read      or default_read
    local write     = opts.write     or default_write
    local input_key = opts.input_key
    local store_key = opts.store_key or "last_input"

    return pf.node(function(shared)
        local line

        if input_key and shared[input_key] ~= nil then
            line = shared[input_key]
            shared[input_key] = nil
        else
            line = read(prompt)
        end

        -- nil/EOF means the input stream ended -> exit
        if line == nil then
            return "exit"
        end

        local result = registry:dispatch(line, shared)

        if result.handled then
            if result.ok then
                if result.result then write(result.result) end
                if result.action == "exit" then return "exit" end
                shared.last_command_error = nil
                return result.action
            else
                shared.last_command_error = result.error
                write("Error: " .. tostring(result.error))
                return "error"
            end
        end

        if not result.ok then
            -- unknown command
            shared.last_command_error = result.error
            write(result.error)
            return "error"
        end

        -- regular text -> store for downstream node
        shared[store_key] = line
        return "passthrough"
    end)
end

----------------------------------------------------------------------
-- Built-in commands
----------------------------------------------------------------------

local function builtin_help(registry)
    return {
        name        = "help",
        aliases     = { "h", "?" },
        description = "List available commands",
        usage       = "/help",
        handler     = function(args)
            if args and args[1] then
                local cmd = registry:get(args[1])
                if not cmd then
                    return "Unknown command: /" .. args[1]
                end
                local lines = { "/" .. cmd.name }
                if cmd.aliases and #cmd.aliases > 0 then
                    table.insert(lines, "  aliases: /" .. table.concat(cmd.aliases, ", /"))
                end
                if cmd.usage       then table.insert(lines, "  usage:   " .. cmd.usage) end
                if cmd.description then table.insert(lines, "  " .. cmd.description) end
                return table.concat(lines, "\n")
            end
            return registry_mod.format_help(registry)
        end,
    }
end

local function builtin_exit()
    return {
        name        = "exit",
        aliases     = { "quit", "q", "bye" },
        description = "End the conversation",
        handler     = function()
            return "Goodbye!", "exit"
        end,
    }
end

local function builtin_clear()
    return {
        name        = "clear",
        description = "Clear the message history",
        handler     = function(_, shared)
            if shared.messages then
                for k in pairs(shared.messages) do shared.messages[k] = nil end
            else
                shared.messages = {}
            end
            return "(history cleared)"
        end,
    }
end

local function builtin_reset()
    return {
        name        = "reset",
        description = "Reset all shared state (history, scratchpad, etc.)",
        handler     = function(_, shared)
            for k in pairs(shared) do shared[k] = nil end
            shared.messages = {}
            return "(session reset)"
        end,
    }
end

local function builtin_history()
    return {
        name        = "history",
        description = "Show the current message history",
        handler     = function(_, shared)
            local msgs = shared.messages
            if not msgs or #msgs == 0 then
                return "(no history yet)"
            end
            local lines = {}
            for i, m in ipairs(msgs) do
                table.insert(lines, string.format("%d. [%s] %s",
                    i, m.role or "?", tostring(m.content or "")))
            end
            return table.concat(lines, "\n")
        end,
    }
end

local function builtin_skill()
    return {
        name        = "skill",
        description = "Run a skill by name against the current shared state",
        usage       = "/skill <name>",
        handler     = function(args, shared)
            local name = args[1]
            if not name then
                return "usage: /skill <name>"
            end

            local ok_mgr, skill_manager = pcall(require, "orbit.utils.skill_manager")
            if not ok_mgr then
                return "skill_manager not available: " .. tostring(skill_manager)
            end

            local skill, err = skill_manager.load_skill(name)
            if not skill then return "Error: " .. tostring(err) end

            local data = {}
            if skill.metadata and skill.metadata.inputs then
                for _, key in ipairs(skill.metadata.inputs) do
                    data[key] = shared[key]
                end
            end

            local prompt = skill_manager.render_prompt(skill.template, data)
            shared.pending_skill        = name
            shared.pending_skill_prompt = prompt

            return "(prepared skill /" .. name .. " — next turn will use this prompt)"
        end,
    }
end

--- Register Orbit's default set of slash commands into `registry`.
-- Mutates and returns the same registry for chaining.
-- @param registry Registry
-- @return Registry
function M.register_defaults(registry)
    registry:register(builtin_help(registry))
    registry:register(builtin_exit())
    registry:register(builtin_clear())
    registry:register(builtin_reset())
    registry:register(builtin_history())
    registry:register(builtin_skill())
    return registry
end

--- Create a fresh registry pre-populated with the default commands.
-- @return Registry
function M.default_registry()
    return M.register_defaults(registry_mod.new())
end

return M
