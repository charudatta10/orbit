-- Mock LLM call
local function call_llm(prompt)
    return "This is a mock response to: " .. prompt
end

return call_llm
