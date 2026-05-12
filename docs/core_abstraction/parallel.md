---
layout: default
title: "(Advanced) Parallel"
parent: "Core Abstraction"
nav_order: 6
---

# (Advanced) Parallel

While `orbit.lua` is a minimalist 100-line core, you can achieve **parallelism** (overlapping I/O-bound tasks) by leveraging multiple coroutines.

### Parallel Execution with Coroutines

Since `pf.async` returns a coroutine, you can start multiple flows and resume them as they become ready.

```lua
local shared1 = { task = "A" }
local shared2 = { task = "B" }

local co1 = pf.async(start_node, shared1)
local co2 = pf.async(start_node, shared2)

-- In a real scenario, you would use an event loop to resume 
-- these as I/O completes.
pf.await(co1)
pf.await(co2)
```

### Throttling and Rate Limits

When running many tasks in parallel (e.g., many LLM calls), be careful not to hit rate limits. You can implement a simple semaphore or worker pool pattern:

1. Create a queue of tasks in your `shared` store.
2. Start a fixed number of "worker" coroutines.
3. Each worker pulls a task, processes it, and repeats until the queue is empty.

### Note on CPU-bound Tasks

Lua's standard coroutines are collaborative and run on a single thread. For true CPU parallelism (using multiple cores), you would need to use a library like `lua-llthreads` or run multiple OS processes. However, for most LLM applications, the bottleneck is I/O (waiting for API responses), where coroutines are highly efficient.
