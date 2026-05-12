---
layout: default
title: "Text Chunking"
parent: "Utility Function"
nav_order: 4
---

# Text Chunking

We recommend some implementations of commonly used text chunking approaches in Lua.

## Example Lua Code Samples

### 1. Naive (Fixed-Size) Chunking

```lua
local function fixed_size_chunk(text, chunk_size)
    chunk_size = chunk_size or 100
    local chunks = {}
    for i = 1, #text, chunk_size do
        table.insert(chunks, text:sub(i, i + chunk_size - 1))
    end
    return chunks
end
```

### 2. Sentence-Based Chunking

(Requires a sentence tokenizer or simple pattern matching)

```lua
local function sentence_based_chunk(text, max_sentences)
    max_sentences = max_sentences or 2
    local sentences = {}
    -- Simple sentence splitter based on punctuation
    for s in text:gmatch(".-[.?!]") do
        table.insert(sentences, s:gsub("^%s*", ""))
    end
    
    local chunks = {}
    for i = 1, #sentences, max_sentences do
        local chunk_parts = {}
        for j = i, math.min(i + max_sentences - 1, #sentences) do
            table.insert(chunk_parts, sentences[j])
        end
        table.insert(chunks, table.concat(chunk_parts, " "))
    end
    return chunks
end
```
