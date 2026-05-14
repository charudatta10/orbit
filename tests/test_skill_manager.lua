local skill_manager = require("orbit.utils.skill_manager")

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("Expected %s, but got %s. %s", tostring(expected), tostring(actual), message or ""), 2)
    end
end

local function test_load_skill()
    print("Testing load_skill...")
    local skill, err = skill_manager.load_skill("summarize")
    if not skill then error(err) end
    
    assert_equal(skill.metadata.name, "Summarize")
    assert_equal(skill.metadata.inputs[1], "text")
    print("load_skill passed.")
end

local function test_render_prompt()
    print("Testing render_prompt...")
    local template = "Hello {{name}}!"
    local data = { name = "Orbit" }
    local result = skill_manager.render_prompt(template, data)
    assert_equal(result, "Hello Orbit!")
    print("render_prompt passed.")
end

local function run_tests()
    local ok, err = pcall(test_load_skill)
    if not ok then print("FAILED: test_load_skill: " .. err) end
    
    ok, err = pcall(test_render_prompt)
    if not ok then print("FAILED: test_render_prompt: " .. err) end
end

run_tests()
