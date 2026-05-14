-- cookbook/orbit-advanced-features/main.lua
-- This example demonstrates the integration of the new features:
-- 1. Markdown Skills (Summarize)
-- 2. Coding Utilities (File Ops)
-- 3. Message Gateway (Console/Telegram)

local pf = require("orbit")
local skill_nodes = require("nodes.skill_nodes")
local file_ops = require("utils.file_ops")
local gateway = require("utils.message_gateway")
local task_orch = require("utils.task_orchestrator")

local function main()
    local shared = {
        text = "Orbit is a lightweight, coroutine-native flow runtime for building agentic systems. It supports nodes, branching, and retries. Recently, it was enhanced with a markdown-based skill system and coding utilities."
    }

    -- 1. Initialize tasks
    task_orch.init_tasks(shared, {
        "Summarize the project description",
        "Save the summary to a file",
        "Notify the user"
    })

    -- 2. Define Nodes
    
    -- Node to process tasks one by one
    local process_task = pf.node(function(shared)
        local task, index = task_orch.get_next_task(shared)
        if not task then return "done" end
        
        shared.current_task = task
        shared.current_task_index = index
        print("🚀 Working on: " .. task.description)
        
        if index == 1 then return "summarize"
        elseif index == 2 then return "save"
        elseif index == 3 then return "notify"
        end
    end)

    -- Skill Node (using the markdown skill)
    local summarize = skill_nodes.create_skill_node("summarize", "summary")

    -- File Op Node
    local save_file = pf.node(function(shared)
        local path = "project_summary.txt"
        file_ops.write_file(path, shared.summary)
        print("💾 Summary saved to " .. path)
        task_orch.complete_task(shared, shared.current_task_index, "Saved to " .. path)
        return "next"
    end)

    -- Gateway Node
    local notify = pf.node(function(shared)
        gateway.send_notification("console", { target = "User" }, "Process complete! Summary: " .. shared.summary)
        task_orch.complete_task(shared, shared.current_task_index, "Notified")
        return "next"
    end)

    -- Post-processing for summarize (to mark task as complete)
    local post_summarize = pf.node(function(shared)
        task_orch.complete_task(shared, shared.current_task_index, shared.summary)
        return "next"
    end)

    -- 3. Connect Flow
    process_task:to("summarize", summarize)
    summarize:to("default", post_summarize)
    post_summarize:to("default", process_task)

    process_task:to("save", save_file)
    save_file:to("default", process_task)

    process_task:to("notify", notify)
    notify:to("default", process_task)

    process_task:to("done", pf.node(function() print("✅ All tasks completed.") end))

    -- 4. Run Flow
    print("--- Starting Advanced Orbit Flow ---")
    pf.run(process_task, shared)
end

main()
