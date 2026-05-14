local pf = require("orbit")

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("Expected %s, but got %s. %s", tostring(expected), tostring(actual), message or ""), 2)
    end
end

local function assert_error(fn, message)
    local ok, err = pcall(fn)
    if ok then
        error("Expected error but got success. " .. (message or ""), 2)
    end
end

-- --- Test Cases ---

local function test_copy_non_empty()
    print("Running test_copy_non_empty...")
    -- This triggers the loop in copy()
    local n = pf.node(function() end)
    pf.run(n, {}, {foo = "bar"})
end

local function test_node_retries()
    print("Running test_node_retries...")
    local count = 0
    local n = pf.node(function()
        count = count + 1
        if count < 3 then
            error("fail")
        end
        return "ok"
    end, { retries = 3, wait = 0.01 })

    local res = pf.run(n, {})
    assert_equal(res, "ok")
    assert_equal(count, 3)
end

local function test_node_failure_after_retries()
    print("Running test_node_failure_after_retries...")
    local count = 0
    local n = pf.node(function()
        count = count + 1
        error("permanent fail")
    end, { retries = 2 })

    assert_error(function()
        pf.run(n, {})
    end)
    assert_equal(count, 2)
end

local function test_await_error()
    print("Running test_await_error...")
    local n = pf.node(function()
        error("async fail")
    end)
    local co = pf.async(n, {})
    
    assert_error(function()
        pf.await(co)
    end)
end

local function test_sleep_mock()
    print("Running test_sleep_mock...")
    -- Mock socket.sleep to test the sleep function path
    package.loaded["socket"] = {
        sleep = function(sec)
            print("Mock sleep for " .. sec)
        end
    }
    
    local n = pf.node(function()
        error("fail once")
    end, { retries = 2, wait = 0.1 })
    
    pcall(pf.run, n, {})
    
    package.loaded["socket"] = nil
end

local function test_orbit_example_block()
    print("Running test_orbit_example_block...")
    -- We can't easily run the 'if ... == nil' block directly without re-loading or similar
    -- But we can copy the logic here to ensure it works
    local shared = {}

    local fetch = pf.node(function(shared)
        shared.value = 42
        return "ok"
    end)

    local process = pf.node(function(shared)
        if shared.value > 40 then
            return "large"
        end
        return "small"
    end)

    local large = pf.node(function(shared)
        shared.result = "got large"
    end)

    fetch:to("ok", process)
    process:to("large", large)

    pf.run(fetch, shared)
    assert_equal(shared.result, "got large")
end

local function test_skill_manager_gaps()
    print("Running test_skill_manager_gaps...")
    local skill_manager = require("utils.skill_manager")
    
    -- Test list_skills
    local skills = skill_manager.list_skills()
    assert_equal(skills[1], "summarize")
    
    -- Test invalid skill format
    local file_ops = require("utils.file_ops")
    file_ops.write_file("skills/invalid.md", "no frontmatter here")
    local skill, err = skill_manager.load_skill("invalid")
    assert_equal(skill, nil)
    assert_equal(err, "Invalid skill format: missing frontmatter")
    file_ops.delete_file("skills/invalid.md")
end

-- --- Run Tests ---

local function run_all()
    test_copy_non_empty()
    test_node_retries()
    test_node_failure_after_retries()
    test_await_error()
    test_sleep_mock()
    test_orbit_example_block()
    test_skill_manager_gaps()
end

run_all()
