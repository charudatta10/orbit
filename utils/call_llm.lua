--- LLM integration utility.
-- @module call_llm
local M = {}

-- Standard LLM call utility for Orbit.
-- Supports locally hosted OpenAI-compatible LLM servers.
-- Default endpoint: http://127.0.0.1:1337/v1/chat/completions

local function escape_json(str)
    return str:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', '\\n'):gsub('\r', '\\r')
end

function M.call_llm(prompt, opts)
    opts = opts or {}
    local model = opts.model or "local-model"
    local endpoint = opts.endpoint or "http://127.0.0.1:1337/v1/chat/completions"
    local temperature = opts.temperature or 0.7
    
    -- Prepare JSON payload
    local payload = string.format([[
    {
        "model": "%s",
        "messages": [{"role": "user", "content": "%s"}],
        "temperature": %f
    }
    ]], model, escape_json(prompt), temperature)
    
    -- Execute curl command
    local cmd = string.format('curl -s -X POST "%s" -H "Content-Type: application/json" -d "%s"', endpoint, payload:gsub('\n', ''):gsub('  +', ''))
    
    local f = io.popen(cmd)
    if not f then return nil, "Failed to execute curl" end
    local response = f:read("*all")
    f.close()
    
    -- Basic extraction of content from OpenAI-style JSON response
    -- Note: This is a simple regex-based extractor to avoid heavy JSON dependencies in the core.
    local content = response:match('"content":%s*"(.-)"')
    if content then
        -- Unescape basic JSON characters
        content = content:gsub('\\n', '\n'):gsub('\\"', '"'):gsub('\\\\', '\\')
        return content
    end
    
    return nil, "Failed to parse LLM response: " .. (response or "empty")
end

return M
