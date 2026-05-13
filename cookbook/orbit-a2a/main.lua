package.path = package.path .. ";../../?.lua;./?.lua"

local orbit = require("orbit")
local pf = orbit.pf
local llm = require("utils.llm")
local web = require("utils.websearch")
local yaml = require("utils.yaml")

local DecideAction = pf.node:extend()
function DecideAction:prep(shared)
    local context = shared.context or "No previous search"
    local question = shared.question
    return {question, context}
end

function DecideAction:exec(inputs)
    local question, context = inputs[1], inputs[2]
    print("🤔 Agent deciding what to do next...")
    local prompt = string.format([[
### CONTEXT
You are a research assistant that can search the web.
Question: %s
Previous Research: %s

### ACTION SPACE
[1] search
  Description: Look up more information on the web
  Parameters:
    - query (str): What to search for

[2] answer
  Description: Answer the question with current knowledge
  Parameters:
    - answer (str): Final answer to the question

## NEXT ACTION
Decide the next action based on the context and available actions.
Return your response in this format:

```yaml
thinking: |
    <your step-by-step reasoning process>
action: search OR answer
reason: <why you chose this action>
answer: <if action is answer>
search_query: <specific search query if action is search>
```
IMPORTANT: Make sure to:
1. Use proper indentation (4 spaces) for all multi-line fields
2. Use the | character for multi-line text fields
3. Keep single-line fields without the | character
]], question, context)
    
    local response = llm.call(prompt)
    local yaml_str = response:match("```yaml(.-)```"):gsub("^%s+", ""):gsub("%s+$", "")
    return yaml.load(yaml_str)
end

function DecideAction:post(shared, prep_res, exec_res)
    if exec_res.action == "search" then
        shared.search_query = exec_res.search_query
        print("🔍 Agent decided to search for: " .. exec_res.search_query)
    else
        shared.context = exec_res.answer
        print("💡 Agent decided to answer the question")
    end
    return exec_res.action
end

local SearchWeb = pf.node:extend()
function SearchWeb:prep(shared)
    return shared.search_query
end

function SearchWeb:exec(search_query)
    print("🌐 Searching the web for: " .. search_query)
    return web.search(search_query)
end

function SearchWeb:post(shared, prep_res, exec_res)
    local previous = shared.context or ""
    shared.context = previous .. "\n\nSEARCH: " .. shared.search_query .. "\nRESULTS: " .. exec_res
    print("📚 Found information, analyzing results...")
    return "decide"
end

local AnswerQuestion = pf.node:extend()
function AnswerQuestion:prep(shared)
    return {shared.question, shared.context or ""}
end

function AnswerQuestion:exec(inputs)
    local question, context = inputs[1], inputs[2]
    print("✍️ Crafting final answer...")
    local prompt = string.format([[
### CONTEXT
Based on the following information, answer the question.
Question: %s
Research: %s

## YOUR ANSWER:
Provide a comprehensive answer using the research results.
]], question, context)
    return llm.call(prompt)
end

function AnswerQuestion:post(shared, prep_res, exec_res)
    shared.answer = exec_res
    print("✅ Answer generated successfully")
    return "done"
end

local decide = DecideAction:new()
local search = SearchWeb:new()
local answer = AnswerQuestion:new()

decide:add_transition("search", search)
decide:add_transition("answer", answer)
search:add_transition("decide", decide)

local agent_flow = pf.flow:new(decide)

local question = "Who won the Nobel Prize in Physics 2024?"
-- (Simple arg handling if needed)
local shared = {question = question}
print("🤔 Processing question: " .. question)
agent_flow:run(shared)
print("\n🎯 Final Answer:")
print(shared.answer or "No answer found")
