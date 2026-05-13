local orbit = require("orbit")

local GenerateNode = orbit.Node:extend()
function GenerateNode:exec(shared)
    print("Generating code for: " .. shared.problem)
    shared.code = "function twoSum(nums, target) ... end"
    shared.iteration = (shared.iteration or 0) + 1
    return "test"
end

local TestNode = orbit.Node:extend()
function TestNode:exec(shared)
    print("Testing code iteration " .. shared.iteration)
    if shared.iteration < 2 then return "fix" end
    return "done"
end

local FixNode = orbit.Node:extend()
function FixNode:exec(shared)
    print("Fixing code...")
    return "generate"
end

local flow = orbit.Flow()
local gen = GenerateNode()
local test = TestNode()
local fix = FixNode()

flow:connect(gen, "test", test)
flow:connect(test, "fix", fix)
flow:connect(fix, "generate", gen)

flow:run({problem = "Two Sum"})
