---
layout: default
title: "Embedding"
parent: "Utility Function"
nav_order: 5
---

# Embedding

Below are example Lua code snippets for various text embedding APIs using a hypothetical `http` module.

## Example Lua Code

### 1. OpenAI
```lua
local http = require("http_client")
local json = require("json")

local function get_openai_embedding(text)
    local response = http.post("https://api.openai.com/v1/embeddings", {
        headers = {
            ["Authorization"] = "Bearer " .. os.getenv("OPENAI_API_KEY"),
            ["Content-Type"] = "application/json"
        },
        body = json.encode({
            model = "text-embedding-3-small",
            input = text
        })
    })
    
    local data = json.decode(response.body)
    return data.data[1].embedding
end
```

### 2. Google Vertex AI (Gemini)
```lua
local function get_google_embedding(text)
    local url = "https://generativelanguage.googleapis.com/v1beta/models/text-embedding-004:embedContent?key=" .. os.getenv("GEMINI_API_KEY")
    local response = http.post(url, {
        headers = { ["Content-Type"] = "application/json" },
        body = json.encode({
            content = { parts = { { text = text } } }
        })
    })
    
    local data = json.decode(response.body)
    return data.embedding.values
end
```
