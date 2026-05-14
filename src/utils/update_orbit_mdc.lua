#!/usr/bin/env lua

-- Script to generate MDC files from the Orbit docs folder, creating one MDC file per MD file.
-- Ported from Python to Lua.

local function read_file(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local content = f:read("*all")
    f:close()
    return content
end

local function write_file(path, content)
    local f = io.open(path, "w")
    if not f then return false end
    f:write(content)
    f:close()
    return true
end

local function mkdir_p(path)
    local is_windows = package.config:sub(1,1) == "\\"
    if is_windows then
        path = path:gsub("/", "\\")
        os.execute('powershell -NoProfile -Command "if (!(Test-Path \'' .. path .. '\')) { New-Item -ItemType Directory -Force -Path \'' .. path .. '\' | Out-Null }"')
    else
        os.execute('mkdir -p "' .. path .. '" 2>/dev/null')
    end
end

local function strip_html_tags(html_content)
    if not html_content then return "" end
    -- Simple HTML tag removal
    local s = html_content:gsub("<[^>]*>", "")
    return s
end

local function trim(s)
    if not s then return "" end
    return s:gsub("^%s*(.-)%s*$", "%1")
end

local function extract_frontmatter(file_path)
    local content = read_file(file_path)
    if not content then return {} end
    
    local frontmatter = {}
    local fm_text = content:match("^%-%-%-%s*(.-)%s*%-%-%-")
    if fm_text then
        for line in fm_text:gmatch("[^\r\n]+") do
            local k, v = line:match("^([^:]+):%s*(.*)$")
            if k and v then
                k = trim(k)
                v = trim(v)
                v = v:gsub('^"(.-)"$', "%1") -- remove quotes
                if k == "nav_order" then
                    frontmatter[k] = tonumber(v)
                else
                    frontmatter[k] = v
                end
            end
        end
    end
    return frontmatter
end

local function extract_first_heading(file_path)
    local content = read_file(file_path)
    if not content then return "" end
    
    -- Remove frontmatter
    content = content:gsub("^%-%-%-.-%-%-%-%s*", "")
    
    for line in content:gmatch("[^\r\n]+") do
        local heading = line:match("^#%s+(.+)$")
        if heading then
            return trim(heading)
        end
    end
    
    -- Fallback to filename
    local filename = file_path:match("([^/\\]+)$") or file_path
    local stem = filename:match("(.+)%.") or filename
    stem = stem:gsub("_", " ")
    -- Simple Title Case
    return (stem:gsub("(%a)([%w]*)", function(a, b) return a:upper() .. b:lower() end))
end

local function get_mdc_description(md_file, frontmatter, heading)
    local section = ""
    local subsection = ""
    
    local norm_path = md_file:gsub("\\", "/"):lower()
    if norm_path:find("core_abstraction") then
        section = "Core Abstraction"
    elseif norm_path:find("design_pattern") then
        section = "Design Pattern"
    elseif norm_path:find("utility_function") then
        section = "Utility Function"
    end
    
    subsection = frontmatter.title or heading
    
    local filename = md_file:match("([^/\\]+)$")
    if filename == "guide.md" then
        return "Guidelines for using Orbit, Agentic Coding"
    end
    
    if filename == "index.md" and section == "" then
        return "Guidelines for using Orbit, a minimalist LLM framework"
    end
    
    if section ~= "" then
        return string.format("Guidelines for using Orbit, %s, %s", section, subsection)
    else
        return string.format("Guidelines for using Orbit, %s", subsection)
    end
end

local function process_markdown_content(content, remove_local_refs)
    if not content then return "" end
    
    -- Remove frontmatter
    content = content:gsub("^%-%-%-.-%-%-%-%s*", "")
    
    -- Replace HTML div tags and their content
    content = content:gsub("<div.->.-</div>", "")
    
    if remove_local_refs then
        -- Replace [text](./path) with [text]
        content = content:gsub("%[([^%]]+)%]%(%.%/[^%)]+%)", "[%1]")
    else
        -- Adjust relative links: ](./path) -> ](mdc:./path)
        content = content:gsub("%]%((%.%/[^%)]+)%)", "](mdc:%1)")
        
        -- Ensure links to md/html files work correctly (change .html to .md)
        content = content:gsub("%]%(mdc:(%.%/.+?)%.html%)", "](mdc:%1.md)")
    end
    
    -- Strip remaining HTML tags
    content = strip_html_tags(content)
    
    return content
end

local function get_documentation_first_policy()
    return [[# DOCUMENTATION FIRST POLICY

**CRITICAL INSTRUCTION**: When implementing a Orbit app:

1. **ALWAYS REQUEST MDC FILES FIRST** - Before writing any code, request and review all relevant MDC documentation files. This doc provides an explaination of the documents.
2. **UNDERSTAND THE FRAMEWORK** - Gain comprehensive understanding of the Orbit framework from documentation
3. **AVOID ASSUMPTION-DRIVEN DEVELOPMENT** - Do not base your implementation on assumptions or guesswork. Even if the human didn't explicitly mention Orbit in their request, if the code you are editing is using Orbit, you should request relevant docs to help you understand best practice as well before editing.

**VERIFICATION**: Begin each implementation with a brief summary of the documentation you've reviewed to inform your approach.

]]
end

local function generate_mdc_header(md_file, description, always_apply)
    local globs = always_apply and "**/*.py" or ""
    local always_apply_str = always_apply and "true" or "false"
    
    return string.format([[---
description: %s
globs: %s
alwaysApply: %s
---
]], description, globs, always_apply_str)
end

local function has_substantive_content(content)
    if not content then return false end
    -- Remove frontmatter (though usually already removed)
    local content_without_fm = content:gsub("^%-%-%-.-%-%-%-%s*", "")
    
    -- Remove whitespace and common HTML/markdown formatting
    local cleaned = content_without_fm:gsub("%s+", ""):gsub("{:.-}", "")
    
    return #cleaned > 20
end

local function create_combined_guide(docs_dir, rules_dir)
    local guide_file = docs_dir .. "/guide.md"
    local index_file = docs_dir .. "/index.md"
    
    local guide_content = read_file(guide_file)
    local index_content = read_file(index_file)
    
    if not guide_content or not index_content then
        print("Warning: guide.md or index.md not found, skipping combined guide creation")
        return false
    end
    
    local processed_guide = process_markdown_content(guide_content, true)
    local processed_index = process_markdown_content(index_content, true)
    
    local doc_first_policy = get_documentation_first_policy()
    local combined_content = doc_first_policy .. processed_guide .. "\n\n" .. processed_index
    
    local description = "Guidelines for using Orbit, Agentic Coding"
    local mdc_header = generate_mdc_header(guide_file, description, true)
    
    local mdc_content = mdc_header .. combined_content
    local output_path = rules_dir .. "/guide_for_orbit.mdc"
    
    mkdir_p(rules_dir)
    write_file(output_path, mdc_content)
    
    print("Created combined guide MDC file: " .. output_path)
    return true
end

local function list_files(dir)
    local files = {}
    local p
    local is_windows = package.config:sub(1,1) == "\\"
    if is_windows then
        -- Normalize path for Windows dir command
        local win_dir = dir:gsub("/", "\\")
        p = io.popen('dir /b /s "' .. win_dir .. '\\*.md"')
    else
        p = io.popen('find "' .. dir .. '" -name "*.md"')
    end
    
    if p then
        for file in p:lines() do
            table.insert(files, file)
        end
        p:close()
    end
    return files
end

local function convert_md_to_mdc(md_file, output_dir, docs_dir, special_treatment)
    print("Processing: " .. md_file)
    
    local filename = md_file:match("([^/\\]+)$")
    if filename == "guide.md" or filename == "index.md" then
        -- Check if it's in the root docs_dir
        local norm_md_file = md_file:gsub("\\", "/")
        local norm_docs_dir = docs_dir:gsub("\\", "/"):gsub("/$", "")
        local parent_dir = norm_md_file:match("(.+)/[^/]+$")
        
        if parent_dir == norm_docs_dir then
            print("Skipping " .. filename .. " for individual processing - it will be included in the combined guide")
            return true
        end
    end
    
    local parent_dir_name = md_file:match("([^/\\]+)[/\\][^/\\]+$")
    
    -- Skip empty index.md in subfolders
    if filename == "index.md" and parent_dir_name ~= "docs" and 
       (parent_dir_name == "core_abstraction" or parent_dir_name == "design_pattern" or parent_dir_name == "utility_function") then
        local content = read_file(md_file)
        if content and not has_substantive_content(content) then
            print("Skipping empty subfolder index: " .. md_file)
            return true
        end
    end
    
    local frontmatter = extract_frontmatter(md_file)
    local heading = extract_first_heading(md_file)
    local description = get_mdc_description(md_file, frontmatter, heading)
    
    local content = read_file(md_file)
    if not content then return false end
    
    local processed_content = process_markdown_content(content, special_treatment)
    local mdc_header = generate_mdc_header(md_file, description, special_treatment)
    local mdc_content = mdc_header .. processed_content
    
    if not has_substantive_content(processed_content) then
        print("Skipping file with no substantive content after processing: " .. md_file)
        return true
    end
    
    -- Calculate relative path
    local norm_md_file = md_file:gsub("\\", "/")
    local norm_docs_dir = docs_dir:gsub("\\", "/"):gsub("/$", "")
    
    local rel_path
    if norm_md_file:sub(1, #norm_docs_dir) == norm_docs_dir then
        rel_path = norm_md_file:sub(#norm_docs_dir + 2)
    else
        -- Fallback if paths are weird
        rel_path = filename
    end
    
    -- Remove "docs/" prefix if present
    if rel_path:sub(1, 5) == "docs/" then
        rel_path = rel_path:sub(6)
    end
    
    local output_path = output_dir:gsub("\\", "/") .. "/" .. rel_path
    output_path = output_path:gsub("%.md$", ".mdc")
    
    local output_parent = output_path:match("(.+)/[^/]+$")
    if output_parent then
        mkdir_p(output_parent)
    end
    
    write_file(output_path, mdc_content)
    print("Created MDC file: " .. output_path)
    return true
end

local function main()
    local docs_dir = nil
    local rules_dir = nil
    
    for i = 1, #arg do
        if arg[i] == "--docs-dir" then
            docs_dir = arg[i+1]
        elseif arg[i] == "--rules-dir" then
            rules_dir = arg[i+1]
        end
    end
    
    -- Get script directory
    local script_path = arg[0] or ""
    local script_dir = script_path:match("(.+)[/\\]") or "."
    
    if not docs_dir then
        -- Default: project_root/docs
        docs_dir = script_dir .. "/../docs"
    end
    if not rules_dir then
        -- Default: project_root/.cursor/rules
        rules_dir = script_dir .. "/../.cursor/rules"
    end
    
    -- Normalize paths (remove trailing slashes)
    docs_dir = docs_dir:gsub("[/\\]$", "")
    rules_dir = rules_dir:gsub("[/\\]$", "")
    
    print("Generating MDC files from docs in: " .. docs_dir)
    print("Output will be written to: " .. rules_dir)
    
    mkdir_p(rules_dir)
    
    local combined_success = create_combined_guide(docs_dir, rules_dir)
    
    local md_files = list_files(docs_dir)
    local success_count = 0
    local failure_count = 0
    
    for _, md_file in ipairs(md_files) do
        local filename = md_file:match("([^/\\]+)$")
        -- Root index.md and guide.md are handled by create_combined_guide
        local is_root_file = false
        local norm_md_file = md_file:gsub("\\", "/")
        local norm_docs_dir = docs_dir:gsub("\\", "/"):gsub("/$", "")
        local parent_dir = norm_md_file:match("(.+)/[^/]+$")
        if parent_dir == norm_docs_dir and (filename == "index.md" or filename == "guide.md") then
            is_root_file = true
        end
        
        if not is_root_file then
            if convert_md_to_mdc(md_file, rules_dir, docs_dir, false) then
                success_count = success_count + 1
            else
                failure_count = failure_count + 1
            end
        end
    end
    
    print(string.format("\nProcessed %d markdown files:", #md_files + 1))
    print(string.format("  - Successfully converted: %d", success_count + (combined_success and 1 or 0)))
    print(string.format("  - Failed conversions: %d", failure_count))
    
    if failure_count > 0 then
        os.exit(1)
    else
        os.exit(0)
    end
end

main()
