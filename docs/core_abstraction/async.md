---
layout: default
title: "(Advanced) Async"
parent: "Core Abstraction"
nav_order: 5
---

# (Advanced) Async

Orbit Lua is **coroutine-native**, meaning it uses Lua coroutines to handle asynchronous-like behavior without requiring a complex async/await keyword system.

## 1. pf.async and pf.await

- `pf.async(start_node, shared, params)`: Creates and returns a coroutine that will run the flow.
- `pf.await(co)`: Resumes the coroutine and returns the result (or errors if it fails).

```lua
local co = pf.async(start_node, shared)
-- do other things...
local result = pf.await(co)
```

## 2. Yielding in Nodes

If a node function needs to wait for an external event (like a long-running API call or user input) without blocking the entire program, it can use `coroutine.yield()`.

```lua
local async_node = pf.node(function(shared)
    print("Starting async task...")
    
    -- Yield execution back to the caller
    coroutine.yield("waiting_for_api")
    
    print("Resumed!")
end)

local co = pf.async(async_node, {})
local ok, status = coroutine.resume(co)
print("Flow paused with status:", status) -- "waiting_for_api"

-- Later...
coroutine.resume(co)
```

This is particularly useful when integrating with event loops or non-blocking I/O libraries.
