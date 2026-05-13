-- Set package path to include the root and the current directory
package.path = package.path .. ";../../?.lua;./?.lua"

local pf = require("orbit")

-- Mock node SelectSkill
local select_skill = pf.node(function(shared)
    return {task = shared.task}
end, function(shared, prep_res)
    local task = string.lower(prep_res.task)
    if task:find("checklist") or task:find("steps") then
        return "checklist_writer", "Write a checklist."
    else
        return "executive_brief", "Write an executive brief."
    end
end, function(shared, prep_res, exec_res)
    local name, content = exec_res
    shared.selected_skill = name
    shared.selected_skill_content = content
end)

-- Mock node ApplySkill
local apply_skill = pf.node(function(shared)
    return {task = shared.task, skill_name = shared.selected_skill, skill_content = shared.selected_skill_content}
end, function(shared, prep_res)
    return "Applied " .. prep_res.skill_name .. " to: " .. prep_res.task
end, function(shared, prep_res, exec_res)
    shared.result = exec_res
end)

local function main()
    local task = "Summarize this launch plan for a VP audience"
    if #arg > 0 then task = arg[1] end

    local shared = {task = task}
    local flow = pf.flow(select_skill)
    select_skill:on("default", apply_skill)

    print("🧩 Task: " .. task)
    pf.run(flow, shared)

    print("\n=== Skill Used ===")
    print(shared.selected_skill or "(none)")

    print("\n=== Output ===")
    print(shared.result or "(no result)")
end

main()
