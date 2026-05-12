---
layout: default
title: "Workflow"
parent: "Design Pattern"
nav_order: 2
---

# Workflow

Many real-world tasks are too complex for one LLM call. The solution is **Task Decomposition**: breaking them into a chain of multiple Nodes.

<div align="center">
  <img src="https://github.com/the-pocket/.github/raw/main/assets/workflow.png?raw=true" width="400"/>
</div>

### Example: Article Writing

```lua
local pf = require("orbit")

local generate_outline = pf.node(function(shared)
    shared.outline = call_llm("Create a detailed outline for an article about " .. shared.topic)
end)

local write_section = pf.node(function(shared)
    shared.draft = call_llm("Write content based on this outline: " .. shared.outline)
end)

local review_and_refine = pf.node(function(shared)
    shared.final_article = call_llm("Review and improve this draft: " .. shared.draft)
end)

-- Connect nodes
generate_outline >> write_section >> review_and_refine

-- Run flow
local shared = { topic = "AI Safety" }
pf.run(generate_outline, shared)

print("Final Article:\n" .. shared.final_article)
```

For dynamic cases where the path isn't fixed, consider using the [Agent](./agent.md) pattern.
