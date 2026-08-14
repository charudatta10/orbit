-- tests/test_command_registry.lua
-- Tests for orbit.utils.command_registry and orbit.nodes.command_nodes

local pf            = require("orbit")
local registry_mod  = require("orbit.utils.command_registry")
local command_nodes = require("orbit.nodes.command_nodes")

----------------------------------------------------------------------
-- helpers
----------------------------------------------------------------------

local failures = 0
local passes   = 0

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("Expected %s, got %s. %s",
            tostring(expected), tostring(actual), message or ""), 2)
    end
end

local function assert_true(cond, message)
    if not cond then
        error("Expected truthy value. " .. (message or ""), 2)
    end
end

local function run(name, fn)
    local ok, err = pcall(fn)
    if ok then
        passes = passes + 1
        print("  PASS  " .. name)
    else
        failures = failures + 1
        print("  FAIL  " .. name .. " :: " .. tostring(err))
    end
end

----------------------------------------------------------------------
-- parse
----------------------------------------------------------------------

run("parse: plain text is not a command", function()
    local p = registry_mod.parse("hello world")
    assert_equal(p.is_command, false)
    assert_equal(p.text, "hello world")
end)

run("parse: leading slash is detected", function()
    local p = registry_mod.parse("/help")
    assert_equal(p.is_command, true)
    assert_equal(p.name, "help")
    assert_equal(#p.args, 0)
end)

run("parse: tokens split on whitespace", function()
    local p = registry_mod.parse("/skill summarize topic")
    assert_equal(p.name, "skill")
    assert_equal(p.args[1], "summarize")
    assert_equal(p.args[2], "topic")
end)

run("parse: quoted strings collapse to one arg", function()
    local p = registry_mod.parse('/note  "the quick brown fox"  tag')
    assert_equal(p.name, "note")
    assert_equal(p.args[1], "the quick brown fox")
    assert_equal(p.args[2], "tag")
end)

run("parse: leading whitespace allowed", function()
    local p = registry_mod.parse("   /exit")
    assert_equal(p.is_command, true)
    assert_equal(p.name, "exit")
end)

run("parse: non-string input is safe", function()
    local p = registry_mod.parse(nil)
    assert_equal(p.is_command, false)
end)

----------------------------------------------------------------------
-- registry
----------------------------------------------------------------------

run("register + get by canonical name", function()
    local r = registry_mod.new()
    r:register({
        name = "ping",
        description = "pong",
        handler = function() return "pong" end,
    })
    local cmd, canon = r:get("ping")
    assert_true(cmd ~= nil)
    assert_equal(canon, "ping")
end)

run("register + get by alias", function()
    local r = registry_mod.new()
    r:register({
        name = "exit",
        aliases = { "q", "quit" },
        handler = function() return nil, "exit" end,
    })
    local _, canon = r:get("q")
    assert_equal(canon, "exit")
end)

run("get unknown command returns nil", function()
    local r = registry_mod.new()
    assert_equal(r:get("nope"), nil)
end)

run("list returns commands sorted by name", function()
    local r = registry_mod.new()
    r:register({ name = "beta",  handler = function() end })
    r:register({ name = "alpha", handler = function() end })
    local list = r:list()
    assert_equal(list[1].name, "alpha")
    assert_equal(list[2].name, "beta")
end)

run("unregister removes command and its aliases", function()
    local r = registry_mod.new()
    r:register({
        name = "exit", aliases = { "q" },
        handler = function() end,
    })
    assert_true(r:unregister("exit"))
    assert_equal(r:get("exit"), nil)
    assert_equal(r:get("q"), nil)
end)

run("register rejects malformed command", function()
    local r = registry_mod.new()
    local ok = pcall(function() r:register({}) end)
    assert_equal(ok, false)
end)

----------------------------------------------------------------------
-- dispatch
----------------------------------------------------------------------

run("dispatch: handler runs and returns result", function()
    local r = registry_mod.new()
    r:register({
        name = "echo",
        handler = function(args) return table.concat(args, " ") end,
    })
    local res = r:dispatch("/echo hi there", {})
    assert_equal(res.ok, true)
    assert_equal(res.handled, true)
    assert_equal(res.action, "handled")
    assert_equal(res.result, "hi there")
end)

run("dispatch: non-command -> passthrough", function()
    local r = registry_mod.new()
    local res = r:dispatch("plain text", {})
    assert_equal(res.handled, false)
    assert_equal(res.action, "passthrough")
end)

run("dispatch: unknown command -> error action", function()
    local r = registry_mod.new()
    local res = r:dispatch("/missing", {})
    assert_equal(res.ok, false)
    assert_equal(res.action, "error")
    assert_true(res.error:find("Unknown command") ~= nil)
end)

run("dispatch: handler error is caught", function()
    local r = registry_mod.new()
    r:register({
        name = "boom",
        handler = function() error("kaboom") end,
    })
    local res = r:dispatch("/boom", {})
    assert_equal(res.ok, false)
    assert_equal(res.handled, true)
    assert_true(res.error:find("kaboom") ~= nil)
end)

run("dispatch: handler can request exit action", function()
    local r = registry_mod.new()
    r:register({
        name = "bye",
        handler = function() return "see ya", "exit" end,
    })
    local res = r:dispatch("/bye", {})
    assert_equal(res.action, "exit")
    assert_equal(res.result, "see ya")
end)

run("dispatch: handler can mutate shared state", function()
    local r = registry_mod.new()
    r:register({
        name = "set",
        handler = function(args, shared) shared.x = args[1] end,
    })
    local shared = {}
    r:dispatch("/set 42", shared)
    assert_equal(shared.x, "42")
end)

----------------------------------------------------------------------
-- default registry & built-ins
----------------------------------------------------------------------

run("default registry registers built-ins", function()
    local r = command_nodes.default_registry()
    for _, name in ipairs({ "help", "exit", "clear", "reset", "history", "skill" }) do
        assert_true(r:get(name) ~= nil, "missing builtin /" .. name)
    end
end)

run("/help lists all commands", function()
    local r = command_nodes.default_registry()
    local res = r:dispatch("/help", {})
    assert_equal(res.ok, true)
    assert_true(res.result:find("/help") ~= nil)
    assert_true(res.result:find("/exit") ~= nil)
end)

run("/help <cmd> shows command detail", function()
    local r = command_nodes.default_registry()
    local res = r:dispatch("/help exit", {})
    assert_true(res.result:find("Goodbye") == nil)  -- shouldn't run /exit
    assert_true(res.result:find("aliases") ~= nil)
end)

run("/exit returns exit action", function()
    local r = command_nodes.default_registry()
    local res = r:dispatch("/exit", {})
    assert_equal(res.action, "exit")
end)

run("/exit via alias /q", function()
    local r = command_nodes.default_registry()
    local res = r:dispatch("/q", {})
    assert_equal(res.action, "exit")
end)

run("/clear empties messages", function()
    local r = command_nodes.default_registry()
    local shared = { messages = { { role = "user", content = "hi" } } }
    r:dispatch("/clear", shared)
    assert_equal(#shared.messages, 0)
end)

run("/history reports empty state cleanly", function()
    local r = command_nodes.default_registry()
    local res = r:dispatch("/history", {})
    assert_true(res.result:find("no history") ~= nil)
end)

run("/history lists messages", function()
    local r = command_nodes.default_registry()
    local shared = {
        messages = {
            { role = "user", content = "hello" },
            { role = "assistant", content = "hi" },
        },
    }
    local res = r:dispatch("/history", shared)
    assert_true(res.result:find("hello") ~= nil)
    assert_true(res.result:find("hi") ~= nil)
end)

run("/reset wipes shared state", function()
    local r = command_nodes.default_registry()
    local shared = { messages = { "x" }, foo = "bar" }
    r:dispatch("/reset", shared)
    assert_equal(shared.foo, nil)
    assert_equal(#shared.messages, 0)
end)

run("/skill without name returns usage", function()
    local r = command_nodes.default_registry()
    local res = r:dispatch("/skill", {})
    assert_true(res.result:find("usage") ~= nil)
end)

----------------------------------------------------------------------
-- command router node
----------------------------------------------------------------------

run("router: command input triggers handled action", function()
    local r = command_nodes.default_registry()
    local outputs = {}
    local inputs = { "/history" }
    local router = command_nodes.make_command_router({
        registry = r,
        read     = function() return table.remove(inputs, 1) end,
        write    = function(t) table.insert(outputs, t) end,
    })

    local action = router.fn({})
    assert_equal(action, "handled")
    assert_true(#outputs > 0)
end)

run("router: plain text passes through and stores last_input", function()
    local r = command_nodes.default_registry()
    local router = command_nodes.make_command_router({
        registry = r,
        read     = function() return "hello there" end,
        write    = function() end,
    })

    local shared = {}
    local action = router.fn(shared)
    assert_equal(action, "passthrough")
    assert_equal(shared.last_input, "hello there")
end)

run("router: nil input exits the flow", function()
    local r = command_nodes.default_registry()
    local router = command_nodes.make_command_router({
        registry = r,
        read     = function() return nil end,
        write    = function() end,
    })
    assert_equal(router.fn({}), "exit")
end)

run("router: /exit exits the flow", function()
    local r = command_nodes.default_registry()
    local router = command_nodes.make_command_router({
        registry = r,
        read     = function() return "/exit" end,
        write    = function() end,
    })
    assert_equal(router.fn({}), "exit")
end)

run("router: unknown command yields error action", function()
    local r = command_nodes.default_registry()
    local router = command_nodes.make_command_router({
        registry = r,
        read     = function() return "/nope" end,
        write    = function() end,
    })
    local shared = {}
    assert_equal(router.fn(shared), "error")
    assert_true(shared.last_command_error ~= nil)
end)

run("router: input_key consumes pre-staged input", function()
    local r = command_nodes.default_registry()
    local router = command_nodes.make_command_router({
        registry  = r,
        input_key = "stage",
        read      = function() error("should not read") end,
        write     = function() end,
    })
    local shared = { stage = "/history" }
    local action = router.fn(shared)
    assert_equal(action, "handled")
    assert_equal(shared.stage, nil)
end)

run("router: integrates with pf.run via shared.input_key", function()
    local r = command_nodes.default_registry()
    local router = command_nodes.make_command_router({
        registry  = r,
        input_key = "next_input",
        write     = function() end,
    })
    -- pf.run requires the node to short-circuit; "/exit" makes it return nil.
    local shared = { next_input = "/exit" }
    local ok = pcall(function() pf.run(router, shared) end)
    assert_true(ok)
end)

----------------------------------------------------------------------
-- summary
----------------------------------------------------------------------

print(string.format("\ncommand_registry: %d passed, %d failed", passes, failures))

if failures > 0 then
    error(string.format("%d command_registry test(s) failed", failures), 0)
end
