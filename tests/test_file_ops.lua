local file_ops = require("orbit.utils.file_ops")

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error(string.format("Expected %s, but got %s. %s", tostring(expected), tostring(actual), message or ""), 2)
    end
end

local function test_file_lifecycle()
    print("Testing file operations lifecycle...")
    local path = "test_file.txt"
    local content = "Hello Orbit File Ops"
    
    -- Write
    local ok = file_ops.write_file(path, content)
    assert_equal(ok, true, "Should write file")
    
    -- Read
    local read_content = file_ops.read_file(path)
    assert_equal(read_content, content, "Content should match")
    
    -- List
    local files = file_ops.list_dir(".")
    local found = false
    for _, f in ipairs(files) do
        if f:find(path) then found = true break end
    end
    assert_equal(found, true, "File should be in directory listing")
    
    -- Delete
    file_ops.delete_file(path)
    print("file_lifecycle passed.")
end

local function run_tests()
    local ok, err = pcall(test_file_lifecycle)
    if not ok then print("FAILED: test_file_lifecycle: " .. err) end
end

run_tests()
