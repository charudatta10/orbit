---
layout: default
title: "Batch"
parent: "Core Abstraction"
nav_order: 4
---

# Batch

**Batch** nodes make it easier to handle large inputs or repeat logic multiple times.

In Orbit Lua, a batch node is created with `pf.batch(fn)`. The function `fn` is called in two phases:
1. **Preparation**: Called with `item = nil`. It should return a list (table) of items to process.
2. **Execution**: Called once for each item in the list.

## 1. pf.batch

```lua
local my_batch = pf.batch(function(shared, item)
    if not item then
        -- Phase 1: Preparation
        return { "chunk1", "chunk2", "chunk3" }
    else
        -- Phase 2: Execution for each item
        print("Processing " .. item)
        shared.results = shared.results or {}
        table.insert(shared.results, item .. "_processed")
    end
end)

pf.run(my_batch, {})
```

### Example: Summarize a Large File

```lua
local map_summaries = pf.batch(function(shared, item)
    if not item then
        -- Chunk the content
        local content = shared.data
        local chunks = {}
        -- (logic to split content into chunks)
        return chunks
    else
        -- Process one chunk
        local summary = call_llm("Summarize: " .. item)
        shared.summaries = shared.summaries or {}
        table.insert(shared.summaries, summary)
    end
end)

local post_process = pf.node(function(shared)
    shared.final_summary = table.concat(shared.summaries, "\n")
end)

map_summaries >> post_process

pf.run(map_summaries, { data = "..." })
```

---

## 2. Batch Flow

To run a whole **Flow** for each item in a batch, you can use a batch node that calls `pf.run()` inside its execution phase.

### Example: Summarize Many Files

```lua
local sub_flow_start = -- ... setup your subflow nodes ...

local batch_flow = pf.batch(function(shared, item)
    if not item then
        -- Return list of filenames to process
        return { "file1.txt", "file2.txt", "file3.txt" }
    else
        -- Run the sub-flow for this specific file
        -- We pass the filename via params
        return pf.run(sub_flow_start, shared, { filename = item })
    end
end)

pf.run(batch_flow, shared)
```

---

## 3. Nested Batches

You can nest batches by having a batch node's execution phase call another batch node or a flow containing batches.

```lua
local directory_batch = pf.batch(function(shared, item)
    if not item then
        return { "dirA", "dirB" }
    else
        -- Run another batch for files in this directory
        return pf.run(file_batch, shared, { directory = item })
    end
end)
```
