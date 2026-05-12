-- Set package path to include the root and the current directory
package.path = package.path .. ";../../?.lua;./?.lua"

local pf = require("orbit")

-- Mock LLM call
local function call_llm(messages)
    return "This is a mock response from the assistant."
end

local chat_node = pf.node(function(shared)
    -- Initialize messages if this is the first run
    if not shared.messages then
        shared.messages = {}
        print("Welcome to the chat! Type 'exit' to end the conversation.")
    end
    
    -- Get user input
    io.write("\nYou: ")
    local user_input = io.read()
    
    if not user_input or user_input:lower() == "exit" then
        print("\nGoodbye!")
        return nil -- End the conversation
    end
    
    -- Add user message to history
    table.insert(shared.messages, {role = "user", content = user_input})
    
    -- Call LLM
    local response = call_llm(shared.messages)
    
    -- Print assistant response
    print("\nAssistant: " .. response)
    
    -- Add assistant message to history
    table.insert(shared.messages, {role = "assistant", content = response})
    
    return "continue"
end)

-- Create the flow with self-loop
chat_node:to("continue", chat_node)

local function main()
    local shared = {}
    pf.run(chat_node, shared)
end

if ... == nil then
    main()
end
