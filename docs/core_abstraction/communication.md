---
layout: default
title: "Communication"
parent: "Core Abstraction"
nav_order: 3
---

# Communication

Nodes in Orbit **communicate** in 2 ways:

1. **Shared Store (Primary)** 
   - A global table that all nodes can read and write.
   - Ideal for task results, large content, or state that persists across the flow.
   - Recommended practice: Design your data structure in the shared table ahead of time.

2. **Params (Ephemeral)**
   - A local, ephemeral table passed to the node function.
   - Used for identifiers or task-specific configuration (especially in [Batch](./batch.md) mode).
   - Parameter values should be treated as immutable.

---

## 1. Shared Store

### Overview

A shared store is typically a Lua table:
```lua
local shared = { data = {}, summary = {}, config = {} }
```

### Example

```lua
local load_data = pf.node(function(shared)
    shared.data = "Some text content"
end)

local summarize = pf.node(function(shared)
    local data = shared.data
    -- summarize logic...
    shared.summary = "Summary of: " .. data
    return "default"
end)

load_data >> summarize

local shared = {}
pf.run(load_data, shared)

print(shared.summary)
```

---

## 2. Params

**Params** allow you to pass configuration or identifiers into a flow execution.

```lua
local summarize_file = pf.node(function(shared, item, params)
    local filename = params.filename
    local content = shared.files[filename]
    -- ...
end)

local shared = { files = { ["doc1.txt"] = "..." } }
pf.run(summarize_file, shared, { filename = "doc1.txt" })
```

In `pf.run(start_node, shared, params)`, the `params` are passed to every node executed in the flow.
