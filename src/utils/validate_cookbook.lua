-- utils/validate_cookbook.lua
-- Automation script to run and validate cookbook examples

local function list_dirs(dir)
    local cmd = "dir /ad /b " .. dir
    if package.config:sub(1,1) == "/" then cmd = "ls -d " .. dir .. "/*/" end
    local f = io.popen(cmd)
    local dirs = {}
    if f then
        for line in f:lines() do
            -- Strip trailing slash for unix
            line = line:gsub("/$", "")
            table.insert(dirs, line)
        end
        f:close()
    end
    return dirs
end

local function run_cookbook(name)
    local path = "cookbook/" .. name .. "/main.lua"
    print("\n----------------------------------------")
    print("VALIDATING COOKBOOK: " .. name)
    
    -- Check if main.lua exists
    local f = io.open(path, "r")
    if not f then
        print("SKIPPED: main.lua not found in " .. name)
        return true
    end
    f:close()
    
    -- Run the example
    local cmd = "lua " .. path
    local ok, status, code = os.execute(cmd)
    
    if ok then
        print("PASSED: " .. name)
        return true
    else
        print("FAILED: " .. name .. " (Exit Code: " .. tostring(code) .. ")")
        return false
    end
end

local function main()
    local cookbook_dir = "cookbook"
    local dirs = list_dirs(cookbook_dir)
    
    local passed = 0
    local total = #dirs
    local skipped = 0
    
    print("Orbit Cookbook Validator")
    print("Found " .. total .. " examples in " .. cookbook_dir)
    
    for _, dir in ipairs(dirs) do
        local result = run_cookbook(dir)
        if result then
            passed = passed + 1
        else
            -- Check if it actually exists or was skipped
            local path = "cookbook/" .. dir .. "/main.lua"
            local f = io.open(path, "r")
            if not f then skipped = skipped + 1 end
        end
    end
    
    print("\n========================================")
    print(string.format("Cookbook Summary: %d/%d passed (%d skipped)", passed - skipped, total - skipped, skipped))
    print("========================================\n")
    
    if (passed - skipped) < (total - skipped) then
        os.exit(1)
    end
end

main()
