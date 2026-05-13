-- Set package path to include the root and the current directory
package.path = package.path .. ";../../?.lua;./?.lua"

local pf = require("orbit")
local nodes = require("cookbook.orbit-agent.nodes")

local function main()
    -- Get question from args if provided
    local question = "Who won the Nobel Prize in Physics 2024?"
    if #arg > 0 then
        question = arg[1]
    end
    
    -- Create nodes
    local decide = nodes.DecideAction()
    local search = nodes.SearchWeb()
    local answer = nodes.AnswerQuestion()
    
    -- Connect nodes
    decide:on("search", search)
    decide:on("answer", answer)
    search:on("decide", decide)
    
    -- Create flow
    local agent_flow = pf.flow(decide)
    
    -- Process the question
    local shared = {question = question}
    print("🤔 Processing question: " .. shared.question)
    pf.run(agent_flow, shared)
    print("\n🎯 Final Answer:")
    print(shared.answer or "No answer found")
end

main()
