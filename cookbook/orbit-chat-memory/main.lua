local orbit = require("orbit")

local GetUserQuestionNode = orbit.Node:extend()
function GetUserQuestionNode:exec(shared)
    io.write("\nYou: ")
    local question = io.read()
    if question == "exit" then return nil, "exit" end
    shared.question = question
    return "retrieve"
end

local RetrieveNode = orbit.Node:extend()
function RetrieveNode:exec(shared)
    print("Retrieving past memories for: " .. shared.question)
    shared.memory = "Past info about " .. shared.question
    return "answer"
end

local AnswerNode = orbit.Node:extend()
function AnswerNode:exec(shared)
    print("Chatting with memory: " .. shared.memory)
    return "question"
end

local flow = orbit.Flow()
local qNode = GetUserQuestionNode()
local rNode = RetrieveNode()
local aNode = AnswerNode()

flow:connect(qNode, "retrieve", rNode)
flow:connect(rNode, "answer", aNode)
flow:connect(aNode, "question", qNode)

flow:run({})
