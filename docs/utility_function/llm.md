---
layout: default
title: "LLM Wrapper"
parent: "Utility Function"
nav_order: 1
---

# LLM Wrappers

Here are some minimal example Lua implementations for calling LLM APIs.

### 1. OpenAI
```lua
local function call_llm(prompt)
    local http = require("http_client")
    local json = require("json")
    
    local r = http.post("https://api.openai.com/v1/chat/completions", {
        headers = {
            ["Authorization"] = "Bearer " .. os.getenv("OPENAI_API_KEY"),
            ["Content-Type"] = "application/json"
        },
        body = json.encode({
            model = "gpt-4o",
            messages = {{role = "user", content = prompt}}
        })
    })
    
    local resp = json.decode(r.body)
    return resp.choices[1].message.content
end
```

### 2. Google (Gemini)
```lua
local function call_gemini(prompt)
    local http = require("http_client")
    local json = require("json")
    
    local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" .. os.getenv("GEMINI_API_KEY")
    
    local r = http.post(url, {
        headers = { ["Content-Type"] = "application/json" },
        body = json.encode({
            contents = {{ parts = {{ text = prompt }} }}
        })
    })
    
    local resp = json.decode(r.body)
    return resp.candidates[1].content.parts[1].text
end
```

### Improvements: In-Memory Caching

```lua
local cache = {}

local function cached_call_llm(prompt, use_cache)
    if use_cache and cache[prompt] then
        return cache[prompt]
    end
    
    local result = call_llm(prompt)
    cache[prompt] = result
    return result
end
```
