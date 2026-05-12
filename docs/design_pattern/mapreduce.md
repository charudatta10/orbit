---
layout: default
title: "Map Reduce"
parent: "Design Pattern"
nav_order: 4
---

# Map Reduce

MapReduce is a design pattern suitable when you have either:
- Large input data (e.g., multiple files to process), or
- Large output data (e.g., multiple forms to fill)

and there is a logical way to break the task into smaller, ideally independent parts. 

<div align="center">
  <img src="https://github.com/the-pocket/.github/raw/main/assets/mapreduce.png?raw=true" width="400"/>
</div>

You first break down the task using a [Batch Node](../core_abstraction/batch.md) in the map phase, followed by aggregation in the reduce phase.

### Example: Document Summarization

```lua
local pf = require("orbit")

local map_summaries = pf.batch(function(shared, item)
    if not item then
        -- Preparation phase: return list of files
        local items = {}
        for filename, content in pairs(shared.files) do
            table.insert(items, { name = filename, content = content })
        end
        return items
    else
        -- Execution phase: process one file
        local summary = call_llm("Summarize the following file:\n" .. item.content)
        shared.file_summaries = shared.file_summaries or {}
        shared.file_summaries[item.name] = summary
    end
end)

local combine_summaries = pf.node(function(shared)
    local text_list = {}
    for fname, summ in pairs(shared.file_summaries) do
        table.insert(text_list, fname .. " summary:\n" .. summ .. "\n")
    end
    local big_text = table.concat(text_list, "\n---\n")

    shared.all_files_summary = call_llm("Combine these file summaries into one final summary:\n" .. big_text)
end)

map_summaries >> combine_summaries

local shared = {
    files = {
        ["file1.txt"] = "Alice was beginning to get very tired of sitting by her sister...",
        ["file2.txt"] = "Some other interesting text ...",
    }
}

pf.run(map_summaries, shared)

print("Final Summary:\n", shared.all_files_summary)
```
