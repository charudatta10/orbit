-- Set package path to include the root and the current directory
package.path = package.path .. ";../../?.lua;./?.lua"

local pf = require("orbit")
local qa_flow = require("flow")

local function main()
    local shared = {
        question = "In one sentence, what's the end of universe?",
        answer = nil
    }

    pf.run(qa_flow, shared)
    print("Question: " .. shared.question)
    print("Answer: " .. shared.answer)
end

main()
