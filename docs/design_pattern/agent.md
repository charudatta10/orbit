---
layout: default
title: "Agent"
parent: "Design Pattern"
nav_order: 1
---

# Agent

Agent is a powerful design pattern in which nodes can take dynamic actions based on the context.

<div align="center">
  <img src="https://github.com/the-pocket/.github/raw/main/assets/agent.png?raw=true" width="350"/>
</div>

## Implement Agent with Graph

1. **Context and Action:** Implement nodes that supply context and perform actions.  
2. **Branching:** Use branching to connect each action node to an agent node. Use action to allow the agent to direct the [flow](../core_abstraction/flow.md) between nodes—and potentially loop back for multi-step.
3. **Agent Node:** Provide a prompt to decide action—for example:

```lua
local prompt = [[
### CONTEXT
Task: ]] .. task_description .. [[
Previous Actions: ]] .. previous_actions .. [[
Current State: ]] .. current_state .. [[

### ACTION SPACE
[1] search
  Description: Use web search to get results
  Parameters:
    - query (str): What to search for

[2] answer
  Description: Conclude based on the results
  Parameters:
    - result (str): Final answer to provide

### NEXT ACTION
Decide the next action based on the current context and available action space.
Return your response in the following format:

```yaml
thinking: |
    <your step-by-step reasoning process>
action: <action_name>
parameters:
    <parameter_name>: <parameter_value>
```]]
```

The core of building **high-performance** and **reliable** agents boils down to:

1. **Context Management:** Provide *relevant, minimal context.* For example, rather than including an entire chat history, retrieve the most relevant via [RAG](./rag.md). Even with larger context windows, LLMs still fall victim to ["lost in the middle"](https://arxiv.org/abs/2307.03172), overlooking mid-prompt content.

2. **Action Space:** Provide *a well-structured and unambiguous* set of actions—avoiding overlap like separate `read_databases` or  `read_csvs`. Instead, import CSVs into the database.

## Example Good Action Design

- **Incremental:** Feed content in manageable chunks (500 lines or 1 page) instead of all at once.

- **Overview-zoom-in:** First provide high-level structure (table of contents, summary), then allow drilling into details (raw texts).

- **Parameterized/Programmable:** Instead of fixed actions, enable parameterized (columns to select) or programmable (SQL queries) actions, for example, to read CSV files.

- **Backtracking:** Let the agent undo the last step instead of restarting entirely, preserving progress when encountering errors or dead ends.

## Example: Search Agent

This agent:
1. Decides whether to search or answer
2. If searches, loops back to decide if more search needed
3. Answers when enough context gathered

```lua
local pf = require("orbit")

local decide = pf.node(function(shared)
    local context = shared.context or "No previous search"
    local query = shared.query
    
    local prompt = string.format([[
Given input: %s
Previous search results: %s
Should I: 1) Search web for more info 2) Answer with current knowledge
Output in yaml:
```yaml
action: search/answer
reason: why this action
search_term: search phrase if action is search
```]], query, context)

    local resp = call_llm(prompt)
    -- Minimal YAML parsing (for example purposes)
    local action = resp:match("action:%s*(%a+)")
    local search_term = resp:match("search_term:%s*([^\n]+)")
    
    if action == "search" then
        shared.search_term = search_term
    end
    
    return action -- "search" or "answer"
end)

local search = pf.node(function(shared)
    local result = search_web(shared.search_term)
    
    shared.context = shared.context or {}
    table.insert(shared.context, { term = shared.search_term, result = result })
    
    return "decide"
end)

local answer = pf.node(function(shared)
    local context = table.concat(shared.context or {}, "\n")
    local result = call_llm("Context: " .. context .. "\nAnswer: " .. shared.query)
    
    print("Answer: " .. result)
    shared.answer = result
end)

-- Connect nodes
decide:to("search", search)
decide:to("answer", answer)
search:to("decide", decide) -- Loop back

pf.run(decide, { query = "Who won the Nobel Prize in Physics 2024?" })
```
