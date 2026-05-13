package.path = package.path .. ";../../?.lua;./?.lua"

local orbit = require("orbit")
local pf = orbit.pf
local llm = require("utils.llm")
local yaml = require("utils.yaml")
local utils = require("utils")

local DecideAction = pf.node:extend()
function DecideAction:prep(shared)
    return {shared.question, shared.context or "", utils.get_doc_names()}
end

function DecideAction:exec(inputs)
    local question, context, available = inputs[1], inputs[2], inputs[3]
    local prompt = string.format([[You are an agentic RAG assistant. You have access to a set of documents about orbit.
Your job is to decide whether you have enough context to answer the question, or if you need to read another document.

Question: %s
Available documents: %s
Context already gathered: %s

If you have enough information to answer the question, set action to 'answer'.
Otherwise, pick one document to read next. Output ONLY valid yaml:

```yaml
action: read
doc: document_name
```

OR

```yaml
action: answer
```]], question, table.concat(available, ", "), context == "" and "nothing yet" or context)
    
    local resp = llm.call(prompt)
    local yaml_str = resp:match("```yaml(.-)```"):gsub("^%s+", ""):gsub("%s+$", "")
    return yaml.load(yaml_str)
end

function DecideAction:post(shared, prep_res, exec_res)
    if exec_res.action == "read" then
        shared.doc_to_read = exec_res.doc
        print("  🔍 Agent decides to read '" .. shared.doc_to_read .. "'")
    else
        print("  💡 Agent decides it has enough context to answer")
    end
    return exec_res.action
end

local ReadDoc = pf.node:extend()
function ReadDoc:prep(shared)
    return shared.doc_to_read
end

function ReadDoc:exec(doc_name)
    print("  📄 Reading document: " .. doc_name)
    return utils.get_doc_content(doc_name)
end

function ReadDoc:post(shared, prep_res, exec_res)
    shared.context = (shared.context or "") .. "\n[" .. prep_res .. "]: " .. exec_res
    print("  ✅ Added '" .. prep_res .. "' to context")
    return "decide"
end

local Answer = pf.node:extend()
function Answer:prep(shared)
    return {shared.question, shared.context or ""}
end

function Answer:exec(inputs)
    local question, context = inputs[1], inputs[2]
    print("  ✍️ Generating answer...")
    return llm.call(string.format("Based on this context:\n%s\n\nAnswer the following question concisely and accurately: %s", context, question))
end

function Answer:post(shared, prep_res, exec_res)
    shared.answer = exec_res
end

local decide = DecideAction:new()
local read = ReadDoc:new()
local answer = Answer:new()

decide:add_transition("read", read)
decide:add_transition("answer", answer)
read:add_transition("decide", decide)

local agentic_rag_flow = pf.flow:new(decide)

local question = "How do nodes work in orbit?"
local shared = {question = question}
print("🤔 Question: " .. question .. "\n")
agentic_rag_flow:run(shared)

print("\n🎯 Final Answer:")
print(shared.answer or "No answer generated.")
