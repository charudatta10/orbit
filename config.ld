project = "Orbit"

description = "A lightweight coroutine-native flow runtime for Lua"

full_description = [[
Orbit is a lightweight, single-file Lua library for building and running stateful workflows (flows) using a node-based approach.

It supports conditional transitions, retries, batch processing, and is native to Lua coroutines for asynchronous execution.
]]

file = {
    "orbit.lua",
    "utils/file_ops.lua",
    "utils/skill_manager.lua",
    "utils/message_gateway.lua",
    "utils/task_orchestrator.lua",
    "utils/call_llm.lua",
    "utils/code_executor.lua",
    "nodes/skill_nodes.lua"
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

-- Custom naming: use full relative path minus extension
example_name = function(filename)
    -- Normalize slashes
    filename = filename:gsub("\\", "/")
    -- Remove leading cookbook/ and .lua extension
    local name = filename:gsub("^cookbook/", ""):gsub("%.lua$", "")
    return name
end

title = "Orbit Documentation"

sort = true

merge = true