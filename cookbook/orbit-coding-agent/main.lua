local orbit = require("orbit")

local PlanNode = orbit.Node:extend()
function PlanNode:exec(shared)
    print("Planning task: " .. shared.task)
    return "execute"
end

local ExecuteNode = orbit.Node:extend()
function ExecuteNode:exec(shared)
    print("Executing implementation...")
    return "test"
end

local TestNode = orbit.Node:extend()
function TestNode:exec(shared)
    print("Testing implementation...")
    if math.random() > 0.5 then return "done" end
    return "plan"
end

local flow = orbit.Flow()
local plan = PlanNode()
local exec = ExecuteNode()
local test = TestNode()

flow:connect(plan, "execute", exec)
flow:connect(exec, "test", test)
flow:connect(test, "plan", plan)

flow:run({task = "Implement feature X"})
