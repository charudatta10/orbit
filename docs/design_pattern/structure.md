---
layout: default
title: "Structured Output"
parent: "Design Pattern"
nav_order: 5
---

# Structured Output

In many use cases, you may want the LLM to output a specific structure, such as a list or a table with predefined keys.

There are several approaches to achieve a structured output:
- **Prompting** the LLM to strictly return a defined structure.
- Using LLMs that natively support **schema enforcement**.
- **Post-processing** the LLM's response to extract structured content.

### Example Use Cases

- Extracting Key Information as YAML:
```yaml
product:
  name: Widget Pro
  price: 199.99
```

## Prompt Engineering

When prompting the LLM to produce **structured** output:
1. **Wrap** the structure in code fences (e.g., `yaml`).
2. **Validate** the results within the node.

### Example Text Summarization

```lua
local summarize_node = pf.node(function(shared)
    local prompt = [[
Please summarize the following text as YAML, with exactly 3 bullet points:
]] .. shared.data .. [[

Output format:
```yaml
summary:
  - bullet 1
  - bullet 2
  - bullet 3
```]]

    local response = call_llm(prompt)
    -- Extract YAML content between code fences
    local yaml_str = response:match("```yaml%s*(.-)%s*```")
    
    -- In a real app, use a YAML parser library
    local lyaml = require("lyaml")
    local structured_result = lyaml.load(yaml_str)

    assert(structured_result.summary, "Missing summary field")
    assert(#structured_result.summary == 3, "Should have exactly 3 bullets")

    shared.structured_summary = structured_result
end, { retries = 3 })
```

### Why YAML instead of JSON?

LLMs often find YAML easier to generate because it handles multiline strings and quotes more naturally than JSON, reducing escaping errors.
