-- Set package path to include the root and the current directory
package.path = package.path .. ";../../?.lua;./?.lua"

local pf = require("orbit")

-- Mock LLM and search functions
local function call_llm(prompt)
    if prompt:find("Decide the next action") then
        return "```yaml\nthinking: |\n    Need to check Nobel Prize winners.\naction: search\nreason: |\n    Need to find information.\nsearch_query: Nobel Prize Physics 2024 winners\n```"
    elseif prompt:find("Based on the following information") then
        return "The 2024 Nobel Prize in Physics was awarded to John J. Hopfield and Geoffrey E. Hinton."
    end
    return "Mock response"
end

local function search_web(query)
    return "John J. Hopfield and Geoffrey E. Hinton were awarded the 2024 Nobel Prize in Physics for their work on neural networks."
end

local nodes = {}

-- DecideAction
nodes.DecideAction = pf.node(function(shared)
    return "decide"
end, function(shared, item)
    -- exec
    print("🤔 Agent deciding what to do next...")
    local action = "search"
    local search_query = "Nobel Prize Physics 2024 winners"
    return {action = action, search_query = search_query}
end, function(shared, prep_res, exec_res)
    -- post
    if exec_res.action == "search" then
        shared.search_query = exec_res.search_query
        print("🔍 Agent decided to search for: " .. exec_res.search_query)
    else
        shared.context = exec_res.answer
        print("💡 Agent decided to answer the question")
    end
    return exec_res.action
end)

-- SearchWeb
nodes.SearchWeb = pf.node(function(shared)
    return shared.search_query
end, function(shared, search_query)
    -- exec
    print("🌐 Searching the web for: " .. search_query)
    return search_web(search_query)
end, function(shared, prep_res, exec_res)
    -- post
    shared.context = (shared.context or "") .. "\n\nSEARCH: " .. shared.search_query .. "\nRESULTS: " .. exec_res
    print("📚 Found information, analyzing results...")
    return "decide"
end)

-- AnswerQuestion
nodes.AnswerQuestion = pf.node(function(shared)
    return {shared.question, shared.context or ""}
end, function(shared, inputs)
    -- exec
    print("✍️ Crafting final answer...")
    return call_llm("Based on the following information... " .. inputs[2])
end, function(shared, prep_res, exec_res)
    -- post
    shared.answer = exec_res
    print("✅ Answer generated successfully")
    return "done"
end)

return nodes
