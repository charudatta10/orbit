---
layout: default
title: "RAG (Retrieval Augmented Generation)"
parent: "Design Pattern"
nav_order: 3
---

# RAG (Retrieval Augmented Generation)

For certain LLM tasks like answering questions, providing relevant context is essential. One common architecture is a **two-stage** RAG pipeline:

<div align="center">
  <img src="https://github.com/the-pocket/.github/raw/main/assets/rag.png?raw=true" width="400"/>
</div>

1. **Offline stage**: Preprocess and index documents ("building the index").
2. **Online stage**: Given a question, generate answers by retrieving the most relevant context.

---
## Stage 1: Offline Indexing

We create three Nodes:
1. `chunk_docs` – chunks raw text.
2. `embed_docs` – embeds each chunk.
3. `store_index` – stores embeddings into a vector database.

```lua
local pf = require("orbit")

local chunk_docs = pf.batch(function(shared, filepath)
    if not filepath then
        -- Preparation: list of file paths
        return shared.files
    else
        -- Execution: read and chunk one file
        local f = io.open(filepath, "r")
        local text = f:read("*all")
        f:close()
        
        local chunks = {}
        local size = 100
        for i = 1, #text, size do
            table.insert(chunks, text:sub(i, i + size - 1))
        end
        
        shared.all_chunks = shared.all_chunks or {}
        for _, chunk in ipairs(chunks) do
            table.insert(shared.all_chunks, chunk)
        end
    end
end)

local embed_docs = pf.batch(function(shared, chunk)
    if not chunk then
        return shared.all_chunks
    else
        local embedding = get_embedding(chunk)
        shared.all_embeds = shared.all_embeds or {}
        table.insert(shared.all_embeds, embedding)
    end
end)

local store_index = pf.node(function(shared)
    shared.index = create_index(shared.all_embeds)
end)

-- Wire them in sequence
chunk_docs >> embed_docs >> store_index

local shared = { files = { "doc1.txt", "doc2.txt" } }
pf.run(chunk_docs, shared)
```

---
## Stage 2: Online Query & Answer

We have 3 nodes:
1. `embed_query` – embeds the user’s question.
2. `retrieve_docs` – retrieves top chunk from the index.
3. `generate_answer` – calls the LLM with the question + chunk to produce the final answer.

```lua
local embed_query = pf.node(function(shared)
    shared.q_emb = get_embedding(shared.question)
end)

local retrieve_docs = pf.node(function(shared)
    local best_id = search_index(shared.index, shared.q_emb, 1)
    shared.retrieved_chunk = shared.all_chunks[best_id]
end)

local generate_answer = pf.node(function(shared)
    local prompt = string.format("Question: %s\nContext: %s\nAnswer:", 
        shared.question, shared.retrieved_chunk)
    shared.answer = call_llm(prompt)
end)

embed_query >> retrieve_docs >> generate_answer

local shared_online = {
    question = "Why do people like cats?",
    index = shared.index,
    all_chunks = shared.all_chunks
}

pf.run(embed_query, shared_online)
print("Answer:", shared_online.answer)
```
