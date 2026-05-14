--- Code execution utility.
-- @module code_executor
local M = {}

function M.execute_shell(cmd)
    local f = io.popen(cmd .. " 2>&1")
    if not f then return nil, "Failed to run command" end
    local output = f:read("*all")
    local ok, status, code = f:close()
    return output, ok, code
end

function M.execute_lua(code)
    local fn, err = load(code)
    if not fn then return nil, "Syntax error: " .. err end
    
    local ok, res = pcall(fn)
    if not ok then return nil, "Runtime error: " .. res end
    
    return res
end

return M
