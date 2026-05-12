---
layout: default
title: "Text-to-Speech"
parent: "Utility Function"
nav_order: 7
---

# Text-to-Speech

Example Lua implementation for ElevenLabs TTS API.

```lua
local http = require("http_client")
local json = require("json")

local function text_to_speech(text, filename)
    local api_key = os.getenv("ELEVENLABS_KEY")
    local voice_id = "your_voice_id"
    local url = "https://api.elevenlabs.io/v1/text-to-speech/" .. voice_id
    
    local r = http.post(url, {
        headers = {
            ["xi-api-key"] = api_key,
            ["Content-Type"] = "application/json"
        },
        body = json.encode({
            text = text,
            voice_settings = { stability = 0.75, similarity_boost = 0.75 }
        })
    })
    
    local f = io.open(filename, "wb")
    f:write(r.body)
    f:close()
end
```
