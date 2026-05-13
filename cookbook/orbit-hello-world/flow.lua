local pf = require("orbit")
local call_llm = require("cookbook.orbit-hello-world.utils.call_llm")

local answer_node = pf.node(function(shared)
    local question = shared.question
    local answer = call_llm(question)
    shared.answer = answer
end)

return answer_node

