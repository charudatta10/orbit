-- orbit.lua
-- single-file coroutine-native flow runtime
-- inspired by Orbit but rewritten idiomatically for Lua
--
-- features:
-- - nodes
-- - conditional transitions
-- - retries
-- - sync + coroutine unified
-- - batch execution
-- - tiny API
--
-- usage:
--
-- local pf = require("orbit")
--
-- local a = pf.node(function(shared)
--     print("A")
--     shared.count = (shared.count or 0) + 1
--     return "next"
-- end)
--
-- local b = pf.node(function(shared)
--     print("B", shared.count)
-- end)
--
-- a:to("next", b)
--
-- pf.run(a, {})

--- Orbit: A lightweight coroutine-native flow runtime for Lua.
-- @module orbit
local M = {}

----------------------------------------------------------------------
-- helpers
----------------------------------------------------------------------

--- Sleeps for a given number of seconds.
-- Requires 'socket' module to be available.
-- @local
-- @param sec number Seconds to sleep.
local function sleep(sec)
    if package.loaded["socket"] then
        require("socket").sleep(sec)
    end
end

--- Shallow copies a table.
-- @local
-- @param tbl table The table to copy.
-- @return table A shallow copy of the table.
local function copy(tbl)
    local t = {}
    for k, v in pairs(tbl or {}) do
        t[k] = v
    end
    return t
end

----------------------------------------------------------------------
-- node
----------------------------------------------------------------------

--- The Node class representing a single step in a flow.
-- @type Node
local Node = {}
Node.__index = Node

--- Creates a new Node.
-- @param fn function The function to execute. (shared, item, params)
-- @param opts table? Options for the node.
-- @param opts.retries number? Number of retries (default 1).
-- @param opts.wait number? Seconds to wait between retries (default 0).
-- @param opts.params table? Static parameters for the node.
-- @param opts.batch boolean? Whether this is a batch node.
-- @return Node
function Node:new(fn, opts)
    opts = opts or {}

    return setmetatable({
        fn = fn,
        next = {},
        retries = opts.retries or 1,
        wait = opts.wait or 0,
        params = opts.params or {},
        batch = opts.batch or false,
    }, self)
end

--- Sets the next node for a given action.
-- @param action string? The action name (default "default").
-- @param target Node The target node to transition to.
-- @return Node The target node (allows chaining).
function Node:to(action, target)
    self.next[action or "default"] = target
    return target
end

--- Runs the node function once.
-- @param shared table The shared state.
-- @param item any? The current item (for batch nodes).
-- @return any The result of the function call.
function Node:run_once(shared, item)
    return self.fn(shared, item, self.params)
end

--- Runs the node with retry logic.
-- @param shared table The shared state.
-- @param item any? The current item (for batch nodes).
-- @return any The result of the function call.
function Node:run(shared, item)
    local last_err

    for i = 1, self.retries do
        local ok, res = pcall(self.run_once, self, shared, item)

        if ok then
            return res
        end

        last_err = res

        if self.wait > 0 then
            sleep(self.wait)
        end
    end

    error(last_err)
end

----------------------------------------------------------------------
-- constructors
----------------------------------------------------------------------

--- Creates a standard flow node.
-- @param fn function The function to execute. (shared, item, params)
-- @param opts table? Options.
-- @return Node
function M.node(fn, opts)
    return Node:new(fn, opts)
end

--- Creates a batch node.
-- Batch nodes run twice:
-- 1. Without an item, to generate a list of items.
-- 2. Once for each item generated.
-- @param fn function The function to execute.
-- @param opts table? Options.
-- @return Node
function M.batch(fn, opts)
    opts = opts or {}
    opts.batch = true
    return Node:new(fn, opts)
end

----------------------------------------------------------------------
-- flow runner
----------------------------------------------------------------------

--- Runs a flow from a start node.
-- @param start Node The starting node.
-- @param shared table? Initial shared state.
-- @param params table? Static parameters for all nodes.
-- @return any The final action returned by the last node.
function M.run(start, shared, params)
    shared = shared or {}

    local current = start
    local action = nil

    while current do
        current.params = copy(params)

        if current.batch then
            local items = current:run(shared) or {}

            for _, item in ipairs(items) do
                action = current:run(shared, item)
            end
        else
            action = current:run(shared)
        end

        current = current.next[action or "default"]
    end

    return action
end

----------------------------------------------------------------------
-- coroutine runner
----------------------------------------------------------------------

--- Creates a coroutine for running a flow asynchronously.
-- @param start Node The starting node.
-- @param shared table? Initial shared state.
-- @param params table? Static parameters.
-- @return thread The coroutine.
function M.async(start, shared, params)
    return coroutine.create(function()
        return M.run(start, shared, params)
    end)
end

--- Resumes a flow coroutine.
-- @param co thread The coroutine to resume.
-- @return any The result of the yield or final return.
function M.await(co)
    local ok, res = coroutine.resume(co)

    if not ok then
        error(res)
    end

    return res
end

----------------------------------------------------------------------
-- pipeline syntax sugar
----------------------------------------------------------------------

--- Syntax sugar for defining linear flows using the >> operator.
-- @param other Node The target node.
-- @return Node The target node.
function Node:__shr(other)
    return self:to("default", other)
end

----------------------------------------------------------------------
-- example
----------------------------------------------------------------------

if ... == nil then

    local shared = {}

    local fetch = M.node(function(shared)
        print("fetch")
        shared.value = (shared.value or 42)
        return "ok"
    end)

    local process = M.node(function(shared)
        print("process", shared.value)
        if shared.value > 40 then
            return "large"
        end
        return "small"
    end)

    local large = M.node(function(shared)
        print("large value")
    end)

    local small = M.node(function(shared)
        print("small value")
    end)

    fetch:to("ok", process)
    process:to("large", large)
    process:to("small", small)

    -- Run large case
    M.run(fetch, shared)

    -- Run small case
    shared.value = 10
    M.run(fetch, shared)
end

return M