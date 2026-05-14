--- File operations utility.
-- @module file_ops
local M = {}

function M.read_file(path)
    local f = io.open(path, "r")
    if not f then return nil, "Could not open file: " .. path end
    local content = f:read("*all")
    f:close()
    return content
end

function M.write_file(path, content)
    local f = io.open(path, "w")
    if not f then return nil, "Could not open file for writing: " .. path end
    f:write(content)
    f:close()
    return true
end

function M.list_dir(dir)
    local cmd = "dir /b " .. dir -- Windows default
    if package.config:sub(1,1) == "/" then cmd = "ls " .. dir end -- Unix
    
    local f = io.popen(cmd)
    if not f then return nil, "Failed to list directory" end
    local output = f:read("*all")
    f:close()
    
    local files = {}
    for line in output:gmatch("[^\r\n]+") do
        table.insert(files, line)
    end
    return files
end

function M.delete_file(path)
    local cmd = "del /f /q " .. path
    if package.config:sub(1,1) == "/" then cmd = "rm -f " .. path end
    return os.execute(cmd)
end

return M
