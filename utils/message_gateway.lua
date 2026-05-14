--- Message gateway for notifications and communication.
-- @module message_gateway
local M = {}

local function send_telegram(config, message)
    if not config.token or not config.chat_id then
        return nil, "Telegram config missing token or chat_id"
    end
    
    -- Using curl via shell for simplicity in this environment
    local url = string.format("https://api.telegram.org/bot%s/sendMessage", config.token)
    local payload = string.format('chat_id=%s&text=%s', config.chat_id, message)
    
    local cmd = string.format('curl -s -X POST "%s" -d "%s"', url, payload)
    local f = io.popen(cmd)
    if not f then return nil, "Failed to execute curl" end
    local response = f:read("*all")
    f:close()
    
    return response
end

local function send_console(config, message)
    print("\n--- NOTIFICATION ---")
    print("To: " .. (config.target or "Console"))
    print("Message: " .. message)
    print("---------------------\n")
    return true
end

function M.send_notification(provider, config, message)
    if provider == "telegram" then
        return send_telegram(config, message)
    elseif provider == "console" then
        return send_console(config, message)
    else
        return nil, "Unknown provider: " .. tostring(provider)
    end
end

return M
