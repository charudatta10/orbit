---
layout: default
title: "Vector Databases"
parent: "Utility Function"
nav_order: 6
---

# Vector Databases

Example Lua implementation for querying a vector database like Pinecone via HTTP.

```lua
local http = require("http_client")
local json = require("json")

local function search_pinecone(vector, top_k)
    local url = "https://your-index.pinecone.io/query"
    local r = http.post(url, {
        headers = {
            ["Api-Key"] = os.getenv("PINECONE_API_KEY"),
            ["Content-Type"] = "application/json"
        },
        body = json.encode({
            vector = vector,
            topK = top_k,
            includeMetadata = true
        })
    })
    
    return json.decode(r.body)
end
```
