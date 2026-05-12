---
layout: default
title: "Viz and Debug"
parent: "Utility Function"
nav_order: 2
---

# Visualization and Debugging

In the Lua version, you can generate Mermaid diagrams by traversing the node connections.

## 1. Visualization with Mermaid

```lua
local function build_mermaid(start_node)
    local visited = {}
    local lines = { "graph LR" }
    
    local function get_name(node)
        -- In Lua, nodes don't have types like Python classes
        -- You might want to add a .name property to your nodes
        return node.name or tostring(node):match("table: (.*)")
    end
    
    local function walk(node)
        if visited[node] then return end
        visited[node] = true
        
        local name = get_name(node)
        for action, target in pairs(node.next) do
            table.insert(lines, string.format("    %s -- %s --> %s", 
                name, action, get_name(target)))
            walk(target)
        end
    end
    
    walk(start_node)
    return table.concat(lines, "\n")
end
```

## 2. Debugging with Coroutines

Since `orbit.lua` uses coroutines, you can inspect the state of the flow between nodes by yielding.

```lua
local debug_node = pf.node(function(shared)
    print("Executing node...")
    -- You can yield to the caller for inspection
    coroutine.yield("debug_pause")
end)
```
