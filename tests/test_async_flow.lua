local pf = require("orbit")

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("Expected %s, but got %s. %s", tostring(expected), tostring(actual), message or ""), 2)
    end
end

-- --- Node Definitions ---

local function AsyncNumberNode(number)
    return pf.node(function(shared)
        shared.current = number
        coroutine.yield("sleeping") -- simulate async work
        return "number_set"
    end)
end

local function AsyncIncrementNode()
    return pf.node(function(shared)
        shared.current = (shared.current or 0) + 1
        coroutine.yield("sleeping")
        return "done"
    end)
end

-- --- Test Cases ---

local function test_simple_async_flow()
    print("Running test_simple_async_flow...")
    local start = AsyncNumberNode(5)
    local inc_node = AsyncIncrementNode()

    start:to("number_set", inc_node)

    local shared = {}
    local co = pf.async(start, shared)
    
    -- First resume: runs AsyncNumberNode until yield
    local ok, res = coroutine.resume(co)
    assert_equal(res, "sleeping")
    assert_equal(shared.current, 5)
    
    -- Second resume: finishes AsyncNumberNode, starts AsyncIncrementNode until yield
    ok, res = coroutine.resume(co)
    assert_equal(res, "sleeping")
    assert_equal(shared.current, 6)
    
    -- Third resume: finishes AsyncIncrementNode, flow ends
    ok, res = coroutine.resume(co)
    assert_equal(ok, true)
    assert_equal(res, "done") -- last action
end

local function test_await_helper()
    print("Running test_await_helper...")
    local start = AsyncNumberNode(10)
    local shared = {}
    local co = pf.async(start, shared)
    
    -- pf.await just does one resume
    local res = pf.await(co)
    assert_equal(res, "sleeping")
    assert_equal(shared.current, 10)
    
    local res2 = pf.await(co)
    assert_equal(res2, "number_set")
end

-- --- Run Tests ---

local function run_all()
    local ok, err = pcall(test_simple_async_flow)
    if not ok then print("FAILED: test_simple_async_flow: " .. err) else print("PASSED: test_simple_async_flow") end

    ok, err = pcall(test_await_helper)
    if not ok then print("FAILED: test_await_helper: " .. err) else print("PASSED: test_await_helper") end
end

run_all()
