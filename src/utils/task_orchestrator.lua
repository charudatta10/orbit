--- Task orchestrator for managing complex task flows.
-- @module task_orchestrator
local M = {}

function M.init_tasks(shared, tasks)
    shared.tasks = {}
    for _, t in ipairs(tasks or {}) do
        table.insert(shared.tasks, {
            description = t,
            status = "pending"
        })
    end
end

function M.get_next_task(shared)
    for i, t in ipairs(shared.tasks or {}) do
        if t.status == "pending" then
            t.status = "in_progress"
            return t, i
        end
    end
    return nil
end

function M.complete_task(shared, index, result)
    if shared.tasks and shared.tasks[index] then
        shared.tasks[index].status = "completed"
        shared.tasks[index].result = result
    end
end

function M.fail_task(shared, index, err)
    if shared.tasks and shared.tasks[index] then
        shared.tasks[index].status = "failed"
        shared.tasks[index].error = err
    end
end

return M
