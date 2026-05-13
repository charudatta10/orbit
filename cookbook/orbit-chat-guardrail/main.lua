local orbit = require("orbit")
local pf = require("pf") -- Assuming pf patterns available

local UserInputNode = orbit.Node:extend()
function UserInputNode:exec(shared)
    print("\nWelcome to the Travel Advisor Chat! Type 'exit' to end.")
    io.write("\nYou: ")
    local user_input = io.read()
    if user_input:lower() == 'exit' then return nil, "exit" end
    shared.user_input = user_input
    return "validate"
end

local GuardrailNode = orbit.Node:extend()
function GuardrailNode:exec(shared)
    local user_input = shared.user_input
    if #user_input < 3 then
        print("\nTravel Advisor: Query too short.")
        return "retry"
    end
    -- Simplified guardrail logic for demonstration
    if user_input:lower():find("travel") or user_input:lower():find("fly") then
        return "process"
    else
        print("\nTravel Advisor: Please ask about travel.")
        return "retry"
    end
end

local LLMNode = orbit.Node:extend()
function LLMNode:exec(shared)
    -- Mock LLM call
    print("\nTravel Advisor: [Travel advice for " .. shared.user_input .. "]")
    return "continue"
end

local flow = orbit.Flow()
local user_input = UserInputNode()
local guardrail = GuardrailNode()
local llm = LLMNode()

flow:connect(user_input, "validate", guardrail)
flow:connect(guardrail, "retry", user_input)
flow:connect(guardrail, "process", llm)
flow:connect(llm, "continue", user_input)

flow:run({})
