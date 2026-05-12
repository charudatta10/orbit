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

local M = {}

----------------------------------------------------------------------
-- helpers
----------------------------------------------------------------------

local function sleep(sec)
    if package.loaded["socket"] then
        require("socket").sleep(sec)
    end
end

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

local Node = {}
Node.__index = Node

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

function Node:to(action, target)
    self.next[action or "default"] = target
    return target
end

function Node:run_once(shared, item)
    return self.fn(shared, item, self.params)
end

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

function M.node(fn, opts)
    return Node:new(fn, opts)
end

function M.batch(fn, opts)
    opts = opts or {}
    opts.batch = true
    return Node:new(fn, opts)
end

----------------------------------------------------------------------
-- flow runner
----------------------------------------------------------------------

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

function M.async(start, shared, params)
    return coroutine.create(function()
        return M.run(start, shared, params)
    end)
end

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

        shared.value = 42

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

    M.run(fetch, shared)
end

return M