--- Specialized nodes for skill execution.
-- @module skill_nodes
local pf = require("orbit")
local skill_manager = require("orbit.utils.skill_manager")

local M = {}

-- Helper to find call_llm (standardizing on utils/call_llm.lua)
local function get_call_llm()
    local ok, call_llm_mod = pcall(require, "orbit.utils.call_llm")
    if ok then return call_llm_mod.call_llm end
    
    -- Fallback/Mock for testing if not found
    return function(prompt)
        return "MOCK_LLM_RESPONSE for: " .. prompt:sub(1, 20) .. "..."
    end
end

function M.create_skill_node(skill_name, output_key)
    output_key = output_key or skill_name .. "_result"
    
    return pf.node(function(shared)
        local skill, err = skill_manager.load_skill(skill_name)
        if not skill then error(err) end

        -- Prepare data from shared based on skill inputs
        local data = {}
        if skill.metadata.inputs then
            for _, input_key in ipairs(skill.metadata.inputs) do
                data[input_key] = shared[input_key]
            end
        end

        local prompt = skill_manager.render_prompt(skill.template, data)
        local call_llm = get_call_llm()
        
        shared[output_key] = call_llm(prompt)
        return "default"
    end)
end

return M
