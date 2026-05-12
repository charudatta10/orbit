---
layout: default
title: "(Advanced) Multi-Agents"
parent: "Design Pattern"
nav_order: 6
---

# (Advanced) Multi-Agents

Multiple [Agents](./flow.md) can work together by handling subtasks and communicating the progress. 
Communication between agents is typically implemented using shared message queues or state in the shared storage.

> Most of time, you don't need Multi-Agents. Start with a simple solution first.
{: .best-practice }

### Example Agent Communication: Shared Queue

In the coroutine-native Lua version, you can implement communication by yielding and resuming coroutines, or simply by checking a shared table.

```lua
local pf = require("orbit")

local agent_node = pf.node(function(shared, item, params)
    local message_queue = shared.messages
    if #message_queue > 0 then
        local message = table.remove(message_queue, 1)
        print("Agent received: " .. message)
    else
        coroutine.yield("waiting_for_messages")
    end
    return "loop"
end)

agent_node:to("loop", agent_node)

local shared = { messages = {} }
local co = pf.async(agent_node, shared)

-- Simulate external system adding messages
table.insert(shared.messages, "System status: OK")
coroutine.resume(co)

table.insert(shared.messages, "Memory usage: Normal")
coroutine.resume(co)
```

### Interactive Multi-Agent Example: Taboo Game

Here's an example where two agents play the word-guessing game Taboo using coroutines to coordinate.

```lua
local hinter = pf.node(function(shared)
    if shared.guess == "GAME_OVER" then return "end" end
    
    local prompt = "Generate hint for '" .. shared.target_word .. "'\nForbidden: " .. table.concat(shared.forbidden_words, ", ")
    local hint = call_llm(prompt)
    
    print("\nHinter: Here's your hint - " .. hint)
    shared.hint = hint
    coroutine.yield("wait_for_guesser")
    return "continue"
end)

local guesser = pf.node(function(shared)
    local prompt = "Given hint: " .. shared.hint .. ", make a new guess (single word):"
    local guess = call_llm(prompt)
    
    print("Guesser: I guess it's - " .. guess)
    
    if guess:lower() == shared.target_word:lower() then
        print("Game Over - Correct guess!")
        shared.guess = "GAME_OVER"
        return "end"
    end
    
    shared.guess = guess
    coroutine.yield("wait_for_hinter")
    return "continue"
end)

hinter:to("continue", hinter)
guesser:to("continue", guesser)

local shared = {
    target_word = "nostalgia",
    forbidden_words = {"memory", "past", "remember"},
    guess = ""
}

local co_hinter = pf.async(hinter, shared)
local co_guesser = pf.async(guesser, shared)

while shared.guess ~= "GAME_OVER" do
    coroutine.resume(co_hinter)
    coroutine.resume(co_guesser)
end
```
