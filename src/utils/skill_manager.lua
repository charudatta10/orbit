--- Skill manager for loading and rendering prompts from markdown files.
-- @module skill_manager
local M = {}

-- Basic YAML-like parser for frontmatter
local function parse_frontmatter(content)
    local metadata = {}
    for line in content:gmatch("[^\r\n]+") do
        local key, val = line:match("^(%w+):%s*(.*)$")
        if key then
            -- Handle basic arrays like [a, b]
            if val:match("^%[.*%]$") then
                local list = {}
                for item in val:gmatch("[%w_]+") do
                    table.insert(list, item)
                end
                metadata[key] = list
            else
                metadata[key] = val
            end
        end
    end
    return metadata
end

function M.load_skill(name)
    local path = "skills/" .. name .. ".md"
    local f = io.open(path, "r")
    if not f then return nil, "Skill not found: " .. name end
    local content = f:read("*all")
    f:close()

    local frontmatter_str = content:match("^%-%-%-%s*\n(.-)\n%-%-%-%s*\n")
    local prompt_template = content:match("%-%-%-%s*\n.-\n%-%-%-%s*\n(.*)$") or ""

    if not frontmatter_str then
        return nil, "Invalid skill format: missing frontmatter"
    end

    local metadata = parse_frontmatter(frontmatter_str)
    return {
        metadata = metadata,
        template = prompt_template
    }
end

function M.render_prompt(template, data)
    return (template:gsub("{{([%w_]+)}}", function(key)
        return tostring(data[key] or "{{" .. key .. "}}")
    end))
end

function M.list_skills()
    local skills = {}
    -- Simplified list for now as os.execute/io.popen varies by OS
    -- In a real scenario, we'd use lfs or popen "ls skills/*.md"
    -- For this prototype, we'll assume the user knows the name or we provide a few defaults
    return {"summarize"}
end

return M
