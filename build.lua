-- build.lua
-- This script runs in the LDE build environment.
-- LDE_OUTPUT_DIR is the target directory where the project is cloned.

local outDir = os.getenv("LDE_OUTPUT_DIR")
if not outDir then
    print("Warning: LDE_OUTPUT_DIR not set. Skipping build operations.")
    return
end

print("Building Orbit documentation and running tests in: " .. outDir)

-- 1. Build Documentation using ldoc
print("Generating documentation...")

local ok, ldoc = pcall(require, "ldoc")
if ok and ldoc and ldoc.main then
    -- Run ldoc via Lua API
    local status, err = pcall(function()
        ldoc.main({"config.ld"})
    end)
    if not status then
        print("Error: ldoc failed - " .. tostring(err))
    else
        print("Documentation generated successfully (via require).")
    end
else
    -- Fallback to CLI
    local ldoc_cmd = "ldoc -c config.ld ."
    local status = os.execute(ldoc_cmd)
    if status ~= 0 then
        print("Error: ldoc CLI failed.")
    else
        print("Documentation generated successfully (via CLI).")
    end
end

-- 2. Run Tests
print("Running tests...")
local test_cmd = "lua tests/run_all.lua"
local test_status = os.execute(test_cmd)
if test_status ~= 0 then
    print("Error: Tests failed.")
    os.exit(1)
else
    print("Tests passed.")
end
