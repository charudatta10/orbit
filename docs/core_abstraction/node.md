---
layout: default
title: "Node"
parent: "Core Abstraction"
nav_order: 1
---

# Node

A **Node** is the smallest building block in Orbit. In the Lua version, a node is created by passing a function to `pf.node()`.

```lua
local pf = require("orbit")

local my_node = pf.node(function(shared, item, params)
    -- node logic here
    return "default"
end)
```

The function receives three arguments:
1. `shared`: The shared store (a table) accessible by all nodes in the flow.
2. `item`: Used in [Batch](./batch.md) mode (nil for regular nodes).
3. `params`: Ephemeral parameters passed from the flow runner.

### Node Logic

Typically, you use a node to:
- **Read data** from the `shared` table.
- **Execute compute logic** (e.g., calling an LLM).
- **Write results** back to the `shared` table.
- **Return an action** string to decide the next node in the flow.

### Fault Tolerance & Retries

You can configure **retries** when creating a node:

- `retries` (number): Max times to run the node function. Default is `1`.
- `wait` (number): Time to wait (in seconds) between retries. Default is `0`.

```lua 
local summarize_node = pf.node(function(shared)
    -- LLM call that might fail
    shared.summary = call_llm(shared.data)
end, { retries = 3, wait = 10 })
```

If the node function throws an error (e.g., via `error()`), the runner will automatically retry it up to the specified number of times.

### Example: Summarize file

```lua 
local summarize_node = pf.node(function(shared)
    local data = shared.data
    if not data or data == "" then
        shared.summary = "Empty file content"
        return
    end

    -- Logic that might fail
    local ok, summary = pcall(function() 
        return call_llm("Summarize this: " .. data)
    end)

    if ok then
        shared.summary = summary
    else
        -- You can handle fallbacks manually or just error() to trigger retries
        error("LLM call failed: " .. tostring(summary))
    end
end, { retries = 3 })

-- Running a single node (mostly for testing)
local shared = { data = "Some long text..." }
summarize_node:run(shared)

print("Summary stored:", shared.summary)
```
