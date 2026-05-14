project = "Orbit"

description = "A lightweight coroutine-native flow runtime for Lua"

full_description = [[
Orbit is a lightweight, single-file Lua library for building and running stateful workflows (flows) using a node-based approach.

It supports conditional transitions, retries, batch processing, and is native to Lua coroutines for asynchronous execution.
]]

file = {
    "src/init.lua",
    "src/utils/file_ops.lua",
    "src/utils/skill_manager.lua",
    "src/utils/message_gateway.lua",
    "src/utils/task_orchestrator.lua",
    "src/utils/call_llm.lua",
    "src/utils/code_executor.lua",
    "src/nodes/skill_nodes.lua"
}

dir = "docs/api"

format = "discount"

readme = "README.md"

kind_names = {
    module = "Libraries",
    topic = "Manual"
}

examples = {
    "cookbook"
}

title = "Orbit Documentation"

sort = true

merge = true