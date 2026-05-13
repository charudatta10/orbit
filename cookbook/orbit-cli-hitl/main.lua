local orbit = require("orbit")

local GetTopicNode = orbit.Node:extend()
function GetTopicNode:exec(shared)
    io.write("Enter a joke topic: ")
    shared.topic = io.read()
    return "generate"
end

local GenerateJokeNode = orbit.Node:extend()
function GenerateJokeNode:exec(shared)
    print("Generating joke about " .. shared.topic .. "...")
    shared.joke = "Why did the " .. shared.topic .. " cross the road?"
    return "feedback"
end

local GetFeedbackNode = orbit.Node:extend()
function GetFeedbackNode:exec(shared)
    print("Joke: " .. shared.joke)
    io.write("Like it? (yes/no): ")
    local feedback = io.read()
    return feedback == "no" and "Disapprove" or "Approve"
end

local flow = orbit.Flow()
local tNode = GetTopicNode()
local gNode = GenerateJokeNode()
local fNode = GetFeedbackNode()

flow:connect(tNode, "generate", gNode)
flow:connect(gNode, "feedback", fNode)
flow:connect(fNode, "Disapprove", gNode)

flow:run({})
