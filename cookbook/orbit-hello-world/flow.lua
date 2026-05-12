local pf = require("pocketflow")
local call_llm = require("utils.call_llm")

local answer_node = pf.node(function(shared)
    local question = shared.question
    local answer = call_llm(question)
    shared.answer = answer
end)

return answer_node
