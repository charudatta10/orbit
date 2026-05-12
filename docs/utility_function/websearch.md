---
layout: default
title: "Web Search"
parent: "Utility Function"
nav_order: 3
---

# Web Search

Example Lua implementation for Google Custom Search.

```lua
local http = require("http_client")
local json = require("json")

local function search_google(query)
    local api_key = os.getenv("GOOGLE_API_KEY")
    local cx = os.getenv("GOOGLE_CX")
    local url = "https://www.googleapis.com/customsearch/v1"
    
    local r = http.get(url .. "?key=" .. api_key .. "&cx=" .. cx .. "&q=" .. query)
    local data = json.decode(r.body)
    
    local results = {}
    for _, item in ipairs(data.items or {}) do
        table.insert(results, { title = item.title, link = item.link, snippet = item.snippet })
    end
    return results
end
```
