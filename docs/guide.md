---
layout: default
title: "Agentic Coding"
---

# Agentic Coding: Humans Design, Agents code!

> If you are an AI agent involved in building LLM Systems, read this guide **VERY, VERY** carefully! This is the most important chapter in the entire document. Throughout development, you should always (1) start with a small and simple solution, (2) design at a high level (`docs/design.md`) before implementation, and (3) frequently ask humans for feedback and clarification.
{: .warning }

## Agentic Coding Steps

Agentic Coding should be a collaboration between Human System Design and Agent Implementation:

| Steps                  | Human      | AI        | Comment                                                                 |
|:-----------------------|:----------:|:---------:|:------------------------------------------------------------------------|
| 1. Requirements | ★★★ High  | ★☆☆ Low   | Humans understand the requirements and context.                    |
| 2. Flow          | ★★☆ Medium | ★★☆ Medium |  Humans specify the high-level design, and the AI fills in the details. |
| 3. Utilities   | ★★☆ Medium | ★★☆ Medium | Humans provide available external APIs and integrations, and the AI helps with implementation. |
| 4. Data          | ★☆☆ Low    | ★★★ High   | AI designs the data schema, and humans verify.                            |
| 5. Node          | ★☆☆ Low   | ★★★ High  | The AI helps design the node based on the flow.          |
| 6. Implementation      | ★☆☆ Low   | ★★★ High  |  The AI implements the flow based on the design. |
| 7. Optimization        | ★★☆ Medium | ★★☆ Medium | Humans evaluate the results, and the AI helps optimize. |
| 8. Reliability         | ★☆☆ Low   | ★★★ High  |  The AI writes test cases and addresses corner cases.     |

1. **Requirements**: Clarify the requirements for your project, and evaluate whether an AI system is a good fit. 
    - Understand AI systems' strengths and limitations:
      - **Good for**: Routine tasks requiring common sense (filling forms, replying to emails)
      - **Good for**: Creative tasks with well-defined inputs (building slides, writing SQL)
      - **Not good for**: Ambiguous problems requiring complex decision-making (business strategy, startup planning)
    - **Keep It User-Centric:** Explain the "problem" from the user's perspective rather than just listing features.
    - **Balance complexity vs. impact**: Aim to deliver the highest value features with minimal complexity early.

2. **Flow Design**: Outline at a high level, describe how your AI system orchestrates nodes.
    - Identify applicable design patterns (e.g., [Map Reduce](./design_pattern/mapreduce.md), [Agent](./design_pattern/agent.md), [RAG](./design_pattern/rag.md)).
      - For each node in the flow, start with a high-level one-line description of what it does.
      - If using **Map Reduce**, specify how to map (what to split) and how to reduce (how to combine).
      - If using **Agent**, specify what are the inputs (context) and what are the possible actions.
      - If using **RAG**, specify what to embed, noting that there's usually both offline (indexing) and online (retrieval) workflows.
    - Outline the flow and draw it in a mermaid diagram. For example:
      ```mermaid
      flowchart LR
          start[Start] --> batch[Batch]
          batch --> check[Check]
          check -->|OK| process
          check -->|Error| fix[Fix]
          fix --> check
          
          subgraph process[Process]
            step1[Step 1] --> step2[Step 2]
          end
          
          process --> endNode[End]
      ```
    - > **If Humans can't specify the flow, AI Agents can't automate it!** Before building an LLM system, thoroughly understand the problem and potential solution by manually solving example inputs to develop intuition.  
      {: .best-practice }

3. **Utilities**: Based on the Flow Design, identify and implement necessary utility functions.
    - Think of your AI system as the brain. It needs a body—these *external utility functions*—to interact with the real world:
        <div align="center"><img src="https://github.com/the-pocket/.github/raw/main/assets/utility.png?raw=true" width="400"/></div>

        - Reading inputs (e.g., retrieving Slack messages, reading emails)
        - Writing outputs (e.g., generating reports, sending emails)
        - Using external tools (e.g., calling LLMs, searching the web)
        - **NOTE**: *LLM-based tasks* (e.g., summarizing text, analyzing sentiment) are **NOT** utility functions; rather, they are *core functions* internal in the AI system.
    - For each utility function, implement it and write a simple test.
    - Document their input/output, as well as why they are necessary. For example:
      - `name`: `get_embedding` (`utils/get_embedding.lua`)
      - `input`: `string`
      - `output`: a vector of 3072 floats
      - `necessity`: Used by the second node to embed text
    - Example utility implementation:
      ```lua
      -- utils/call_llm.lua
      local function call_llm(prompt)    
          -- implementation depends on your chosen LLM client/library
          local llm = require("llm_client") 
          local r = llm.chat({
              model = "gpt-4o",
              messages = {{role = "user", content = prompt}}
          })
          return r.content
      end
          
      if ... == nil then
          local prompt = "What is the meaning of life?"
          print(call_llm(prompt))
      end
      ```
    - > **Sometimes, design Utilities before Flow:**  For example, for an LLM project to automate a legacy system, the bottleneck will likely be the available interface to that system. Start by designing the hardest utilities for interfacing, and then build the flow around them.
      {: .best-practice }
    - > **Avoid Exception Handling in Utilities**: If a utility function is called from a Node's execution, avoid using `pcall` or error catching blocks within the utility if you want the Node's built-in retry mechanism to handle failures.
      {: .warning }

4. **Data Design**: Design the shared store that nodes will use to communicate.
   - One core design principle for Orbit is to use a well-designed [shared store](./core_abstraction/communication.md)—a data contract that all nodes agree upon to retrieve and store data.
      - For simple systems, use an in-memory table.
      - For more complex systems or when persistence is required, use a database.
      - **Don't Repeat Yourself**: Use table references or foreign keys.
      - Example shared store design:
        ```lua
        local shared = {
            user = {
                id = "user123",
                context = {                -- Another nested table
                    weather = {temp = 72, condition = "sunny"},
                    location = "San Francisco"
                }
            },
            results = {}                   -- Empty table to store outputs
        }
        ```

5. **Node Design**: Plan how each node will read and write data, and use utility functions.
   - For each [Node](./core_abstraction/node.md), describe its type, how it reads and writes data, and which utility function it uses. Keep it specific but high-level without code. For example:
     - `type`: Regular (or Batch, or Async)
     - `logic`: Read "text" from the shared store, call the embedding utility function, and write "embedding" to the shared store. **Avoid error handling here**; let the Node's retry mechanism manage failures.

6. **Implementation**: Implement the initial nodes and flows based on the design.
   - 🎉 If you've reached this step, humans have finished the design. Now *Agentic Coding* begins!
   - **"Keep it simple, stupid!"** Avoid complex features and full-scale type checking.
   - **FAIL FAST**! Leverage the built-in [Node](./core_abstraction/node.md) retry mechanisms to handle failures gracefully. This helps you quickly identify weak points in the system.
   - Add logging throughout the code to facilitate debugging.

7. **Optimization**:
   - **Use Intuition**: For a quick initial evaluation, human intuition is often a good start.
   - **Redesign Flow (Back to Step 3)**: Consider breaking down tasks further, introducing agentic decisions, or better managing input contexts.
   - If your flow design is already solid, move on to micro-optimizations:
     - **Prompt Engineering**: Use clear, specific instructions with examples to reduce ambiguity.
     - **In-Context Learning**: Provide robust examples for tasks that are difficult to specify with instructions alone.

   - > **You'll likely iterate a lot!** Expect to repeat Steps 3–6 hundreds of times.
     >
     > <div align="center"><img src="https://github.com/the-pocket/.github/raw/main/assets/success.png?raw=true" width="400"/></div>
     {: .best-practice }

8. **Reliability**  
   - **Node Retries**: Add checks in the node function to ensure outputs meet requirements, and consider increasing `retries` and `wait` times when creating the node.
   - **Logging and Visualization**: Maintain logs of all attempts and visualize node results for easier debugging.
   - **Self-Evaluation**: Add a separate node (powered by an LLM) to review outputs when results are uncertain.

## Example LLM Project File Structure

```
my_project/
├── main.lua
├── nodes.lua
├── flow.lua
├── orbit.lua
├── utils/
│   ├── call_llm.lua
│   └── search_web.lua
└── docs/
    └── design.md
```

- **`orbit.lua`**: The core framework file.

- **`docs/design.md`**: Contains project documentation for each step above. This should be *high-level* and *no-code*.
  ~~~
  # Design Doc: Your Project Name

  > Please DON'T remove notes for AI

  ## Requirements

  > Notes for AI: Keep it simple and clear.
  > If the requirements are abstract, write concrete user stories


  ## Flow Design

  > Notes for AI:
  > 1. Consider the design patterns of agent, map-reduce, rag, and workflow. Apply them if they fit.
  > 2. Present a concise, high-level description of the workflow.

  ### Applicable Design Pattern:

  1. Map the file summary into chunks, then reduce these chunks into a final summary.
  2. Agentic file finder
    - *Context*: The entire summary of the file
    - *Action*: Find the file

  ### Flow high-level Design:

  1. **First Node**: This node is for ...
  2. **Second Node**: This node is for ...
  3. **Third Node**: This node is for ...

  ```mermaid
  flowchart TD
      firstNode[First Node] --> secondNode[Second Node]
      secondNode --> thirdNode[Third Node]
  ```
  ## Utility Functions

  > Notes for AI:
  > 1. Understand the utility function definition thoroughly by reviewing the doc.
  > 2. Include only the necessary utility functions, based on nodes in the flow.

  1. **Call LLM** (`utils/call_llm.lua`)
    - *Input*: prompt (string)
    - *Output*: response (string)
    - Generally used by most nodes for LLM tasks

  2. **Embedding** (`utils/get_embedding.lua`)
    - *Input*: string
    - *Output*: a vector of 3072 floats
    - Used by the second node to embed text

  ## Node Design

  ### Shared Store

  > Notes for AI: Try to minimize data redundancy

  The shared store structure is organized as follows:

  ```lua
  local shared = {
      key = "value"
  }
  ```

  ### Node Steps

  > Notes for AI: Carefully decide whether to use Batch/Async Node.

  1. First Node
    - *Purpose*: Provide a short explanation of the node’s function
    - *Type*: Decide between Regular, Batch, or Async
    - *Steps*: Read "key" from the shared store, call the utility function, and write "key" to the shared store.

  2. Second Node
    ...
  ~~~


- **`utils/`**: Contains all utility functions.
  - It's recommended to dedicate one Lua file to each API call, for example `call_llm.lua` or `search_web.lua`.
  ```lua
  -- utils/call_llm.lua
  local function call_llm(prompt)
      -- Using a hypothetical provider library
      local provider = require("provider")
      local response = provider.generate({
          model = "gemini-1.5-flash",
          prompt = prompt
      })
      return response.text
  end

  if ... == nil then
      local test_prompt = "Hello, how are you?"
      print("Making call...")
      local response = call_llm(test_prompt)
      print("Response: " .. response)
  end

  return { call_llm = call_llm }
  ```

- **`nodes.lua`**: Contains all the node definitions.
  ```lua
  -- nodes.lua
  local pf = require("orbit")
  local call_llm = require("utils.call_llm").call_llm

  local M = {}

  M.get_question_node = pf.node(function(shared)
      -- Get question directly from user input
      io.write("Enter your question: ")
      local user_question = io.read()
      shared.question = user_question
      return "default" -- Go to the next node
  end)

  M.answer_node = pf.node(function(shared)
      -- Read question from shared
      local question = shared.question
      -- Call LLM to get the answer
      local answer = call_llm(question)
      -- Store the answer in shared
      shared.answer = answer
  end)

  return M
  ```
- **`flow.lua`**: Implements functions that create flows by importing node definitions and connecting them.
  ```lua
  -- flow.lua
  local nodes = require("nodes")

  local function create_qa_flow()
      -- Connect nodes in sequence
      nodes.get_question_node >> nodes.answer_node
      
      return nodes.get_question_node
  end

  return { create_qa_flow = create_qa_flow }
  ```
- **`main.lua`**: Serves as the project's entry point.
  ```lua
  -- main.lua
  local pf = require("orbit")
  local flow = require("flow")

  local function main()
      local shared = {
          question = nil,  -- Will be populated by get_question_node
          answer = nil     -- Will be populated by answer_node
      }

      -- Create the flow and run it
      local qa_flow = flow.create_qa_flow()
      pf.run(qa_flow, shared)
      
      print("Question: " .. tostring(shared.question))
      print("Answer: " .. tostring(shared.answer))
  end

  main()
  ```
