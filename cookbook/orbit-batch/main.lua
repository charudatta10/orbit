-- Set package path to include the root and the current directory
package.path = package.path .. ";../../?.lua;./?.lua"

local pf = require("orbit")

-- Mock LLM call
local function call_llm(prompt)
    return "This is a mock translation of: " .. prompt:sub(1, 50) .. "..."
end

local translate_node = pf.batch(function(shared, item)
    if not item then
        -- prep: create batches
        local text = shared.text or "(No text provided)"
        local languages = shared.languages or {"Chinese", "Spanish"}
        local items = {}
        for _, lang in ipairs(languages) do
            table.insert(items, {text = text, language = lang})
        end
        shared.results = {}
        return items
    else
        -- exec: process item
        local text = item.text
        local language = item.language
        
        local prompt = string.format("Translate to %s:\n%s", language, text)
        local result = call_llm(prompt)
        print("Translated " .. language .. " text")
        
        -- post-like: collect result
        table.insert(shared.results, {language = language, translation = result})
    end
end)

local function main()
    -- Read text from README.md
    local f = io.open("../../README.md", "r")
    local text = ""
    if f then
        text = f:read("*all")
        f:close()
    end
    
    local shared = {
        text = text,
        languages = {"Chinese", "Spanish", "Japanese", "German"},
        output_dir = "translations"
    }

    print("Starting translation into " .. #shared.languages .. " languages...")
    local start_time = os.clock()

    pf.run(translate_node, shared)

    -- Save results
    os.execute("mkdir " .. shared.output_dir)
    for _, res in ipairs(shared.results) do
        local filename = shared.output_dir .. "/README_" .. res.language:upper() .. ".md"
        local wf = io.open(filename, "w")
        if wf then
            wf:write(res.translation)
            wf:close()
            print("Saved translation to " .. filename)
        end
    end

    local end_time = os.clock()
    print(string.format("\nTotal time: %.4f seconds", end_time - start_time))
end

if ... == nil then
    main()
end
