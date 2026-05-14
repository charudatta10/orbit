-- tests/run_all.lua
-- Unified test runner for Orbit
local M = {}

local function list_files(dir)
    local cmd = "dir /b " .. dir
    if package.config:sub(1,1) == "/" then cmd = "ls " .. dir end
    local f = io.popen(cmd)
    local files = {}
    if f then
        for line in f:lines() do
            if line:match("^test_.*%.lua$") then
                table.insert(files, line)
            end
        end
        f:close()
    end
    return files
end

local function run_test(path)
    print("\n----------------------------------------")
    print("RUNNING: " .. path)
    local ok, res = pcall(function()
        local f = loadfile(path)
        if not f then error("Could not load file") end
        f()
    end)
    if ok then
        print("PASSED: " .. path)
        return true
    else
        print("FAILED: " .. path .. "\nError: " .. tostring(res))
        return false
    end
end

function M.main()
    local test_dir = "tests"
    local files = list_files(test_dir)
    
    local passed = 0
    local total = #files
    
    print("Orbit Unified Test Runner")
    print("Found " .. total .. " tests in " .. test_dir)
    
    for _, file in ipairs(files) do
        if run_test(test_dir .. "/" .. file) then
            passed = passed + 1
        end
    end
    
    print("\n========================================")
    print(string.format("Test Summary: %d/%d passed", passed, total))
    print("========================================\n")
    
    if passed < total then
        os.exit(1)
    end
end

if ... == nil then
    M.main()
end

return M
