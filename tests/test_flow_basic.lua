local pf = require("orbit")

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("Expected %s, but got %s. %s", tostring(expected), tostring(actual), message or ""), 2)
    end
end

-- --- Node Definitions ---

local function NumberNode(number)
    return pf.node(function(shared)
        shared.current = number
    end)
end

local function AddNode(number)
    return pf.node(function(shared)
        shared.current = (shared.current or 0) + number
    end)
end

local function MultiplyNode(number)
    return pf.node(function(shared)
        shared.current = (shared.current or 0) * number
    end)
end

local function CheckPositiveNode()
    return pf.node(function(shared)
        if shared.current >= 0 then
            return "positive"
        else
            return "negative"
        end
    end)
end

local function NoOpNode()
    return pf.node(function(shared) end)
end

local function EndSignalNode(signal)
    signal = signal or "finished"
    return pf.node(function(shared)
        return signal
    end)
end

-- --- Test Cases ---

local function test_linear_sequence()
    print("Running test_linear_sequence...")
    local shared = {}
    local n1 = NumberNode(5)
    local n2 = AddNode(3)
    local n3 = MultiplyNode(2)

    n1:to("default", n2)
    n2:to("default", n3)

    local last_action = pf.run(n1, shared)
    assert_equal(shared.current, 16, "Current should be 16")
    assert_equal(last_action, nil, "Last action should be nil")
end

local function test_pipeline_sugar()
    print("Running test_pipeline_sugar...")
    local shared = {}
    local n1 = NumberNode(5)
    local n2 = AddNode(3)
    local n3 = MultiplyNode(2)

    -- Test __shr (>>)
    n1:to("default", n2)
    n2:to("default", n3)

    local last_action = pf.run(n1, shared)
    assert_equal(shared.current, 16, "Current should be 16")
    assert_equal(last_action, nil, "Last action should be nil")
end

local function test_branching_positive()
    print("Running test_branching_positive...")
    local shared = {}
    local start_node = NumberNode(5)
    local check_node = CheckPositiveNode()
    local add_if_positive = AddNode(10)
    local add_if_negative = AddNode(-20)

    start_node:to("default", check_node)
    check_node:to("positive", add_if_positive)
    check_node:to("negative", add_if_negative)

    local last_action = pf.run(start_node, shared)
    assert_equal(shared.current, 15, "5 + 10 should be 15")
    assert_equal(last_action, nil)
end

local function test_branching_negative()
    print("Running test_branching_negative...")
    local shared = {}
    local start_node = NumberNode(-5)
    local check_node = CheckPositiveNode()
    local add_if_positive = AddNode(10)
    local add_if_negative = AddNode(-20)

    start_node:to("default", check_node)
    check_node:to("positive", add_if_positive)
    check_node:to("negative", add_if_negative)

    local last_action = pf.run(start_node, shared)
    assert_equal(shared.current, -25, "-5 + -20 should be -25")
    assert_equal(last_action, nil)
end

local function test_cycle()
    print("Running test_cycle...")
    local shared = {}
    local n1 = NumberNode(10)
    local check = CheckPositiveNode()
    local subtract3 = AddNode(-3)
    local end_node = EndSignalNode("cycle_done")

    n1:to("default", check)
    check:to("positive", subtract3)
    check:to("negative", end_node)
    subtract3:to("default", check)

    local last_action = pf.run(n1, shared)
    assert_equal(shared.current, -2, "10 -> 7 -> 4 -> 1 -> -2")
    assert_equal(last_action, "cycle_done")
end

-- --- Run Tests ---

local function run_all()
    local ok, err = pcall(test_linear_sequence)
    if not ok then print("FAILED: test_linear_sequence: " .. err) else print("PASSED: test_linear_sequence") end

    ok, err = pcall(test_pipeline_sugar)
    if not ok then print("FAILED: test_pipeline_sugar: " .. err) else print("PASSED: test_pipeline_sugar") end

    ok, err = pcall(test_branching_positive)
    if not ok then print("FAILED: test_branching_positive: " .. err) else print("PASSED: test_branching_positive") end

    ok, err = pcall(test_branching_negative)
    if not ok then print("FAILED: test_branching_negative: " .. err) else print("PASSED: test_branching_negative") end

    ok, err = pcall(test_cycle)
    if not ok then print("FAILED: test_cycle: " .. err) else print("PASSED: test_cycle") end
end

run_all()
