-- build.lua

local tasks = {}

--------------------------------------------------
-- Utilities
--------------------------------------------------

local function run(cmd)
    print("> " .. cmd)

    local pipe = io.popen(cmd .. " 2>&1")

    if not pipe then
        error("failed to start command")
    end

    local output = pipe:read("*a")

    local ok = pipe:close()

    if output and output ~= "" then
        print(output)
    end

    if ok == false then
        error("command failed: " .. cmd)
    end
end

local function task(name, fn)
    tasks[name] = fn
end

--------------------------------------------------
-- Tasks
--------------------------------------------------

task("docs", function()
    run("ldoc -c config.ld .")
end)

task("test", function()
    run("lua tests/run_all.lua")
end)

task("all", function()
    tasks.docs()
    tasks.test()
end)

--------------------------------------------------
-- CLI
--------------------------------------------------

local selected = (_G.arg and _G.arg[1]) or "all"

if not tasks[selected] then
    io.stderr:write("Unknown task: " .. tostring(selected) .. "\n\n")
    io.stderr:write("Available tasks:\n")

    for name in pairs(tasks) do
        io.stderr:write("  - " .. name .. "\n")
    end

    os.exit(1)
end

tasks[selected]()

