<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/title.png" alt="Orbit – Minimalist LLM framework for Lua" width="600"/>
</div>

<!-- For translation, replace English with [English](https://github.com/The-Pocket/Orbit/blob/main/README.md), and remove the link for the target language. -->

English | [中文](https://github.com/The-Pocket/Orbit/blob/main/cookbook/orbit-batch/translations/README_CHINESE.md) | [Español](https://github.com/The-Pocket/Orbit/blob/main/cookbook/orbit-batch/translations/README_SPANISH.md) | [日本語](https://github.com/The-Pocket/Orbit/blob/main/cookbook/orbit-batch/translations/README_JAPANESE.md) | [Deutsch](https://github.com/The-Pocket/Orbit/blob/main/cookbook/orbit-batch/translations/README_GERMAN.md) | [Русский](https://github.com/The-Pocket/Orbit/blob/main/cookbook/orbit-batch/translations/README_RUSSIAN.md) | [Português](https://github.com/The-Pocket/Orbit/blob/main/cookbook/orbit-batch/translations/README_PORTUGUESE.md) | [Français](https://github.com/The-Pocket/Orbit/blob/main/cookbook/orbit-batch/translations/README_FRENCH.md) | [한국어](https://github.com/The-Pocket/Orbit/blob/main/cookbook/orbit-batch/translations/README_KOREAN.md)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
[![Docs](https://img.shields.io/badge/docs-latest-blue)](docs/index.md)
 <a href="https://discord.gg/hUHHE9Sa6T">
    <img src="https://img.shields.io/discord/1346833819172601907?logo=discord&style=flat">
</a>

**Orbit** is a [~160-line](orbit.lua) minimalist LLM framework for Lua.

- **Lightweight**: Just ~160 lines. Zero bloat, zero dependencies, zero vendor lock-in.
  
- **Expressive**: Everything you love—([Multi-](docs/design_pattern/multi_agent.md))[Agents](docs/design_pattern/agent.md), [Workflow](docs/design_pattern/workflow.md), [RAG](docs/design_pattern/rag.md), and more.

- **[Agentic Coding](https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to)**: Let AI Agents (e.g., Cursor AI) build Agents—10x productivity boost!

Get started with Orbit:
- To install, just copy [orbit.lua](orbit.lua) or [main.lua](main.lua) into your project.
- To learn more, check out the [documentation](docs/index.md) and [cookbook](cookbook/)
- 🎉 Join our [Discord](https://discord.gg/hUHHE9Sa6T) to connect with other developers building with Orbit!

---

**Note**: This is the Lua port of the original [Orbit](https://github.com/The-Pocket/Orbit). The core logic is contained in a single file `orbit.lua` (also available as `main.lua`).

## Quick Start

```lua
local pf = require("orbit")

local fetch = pf.node(function(shared)
    shared.value = 42
    return "ok"
end)

local process = pf.node(function(shared)
    if shared.value > 40 then return "large" end
    return "small"
end)

fetch >> process
pf.run(fetch, {})
```

## Why Orbit?

Current LLM frameworks are bloated... You only need 160 lines for LLM Framework!

<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/meme.jpg" width="400"/>


  |                | **Abstraction**          | **App-Specific Wrappers**                                      | **Vendor-Specific Wrappers**                                    | **Lines**       | **Size**    |
|----------------|:-----------------------------: |:-----------------------------------------------------------:|:------------------------------------------------------------:|:---------------:|:----------------------------:|
| LangChain  | Agent, Chain               | Many <br><sup><sub>(e.g., QA, Summarization)</sub></sup>              | Many <br><sup><sub>(e.g., OpenAI, Pinecone, etc.)</sub></sup>                   | 405K          | +166MB                     |
| CrewAI     | Agent, Chain            | Many <br><sup><sub>(e.g., FileReadTool, SerperDevTool)</sub></sup>         | Many <br><sup><sub>(e.g., OpenAI, Anthropic, Pinecone, etc.)</sub></sup>        | 18K           | +173MB                     |
| SmolAgent   | Agent                      | Some <br><sup><sub>(e.g., CodeAgent, VisitWebTool)</sub></sup>         | Some <br><sup><sub>(e.g., DuckDuckGo, Hugging Face, etc.)</sub></sup>           | 8K            | +198MB                     |
| LangGraph   | Agent, Graph           | Some <br><sup><sub>(e.g., Semantic Search)</sub></sup>                     | Some <br><sup><sub>(e.g., PostgresStore, SqliteSaver, etc.) </sub></sup>        | 37K           | +51MB                      |
| AutoGen    | Agent                | Some <br><sup><sub>(e.g., Tool Agent, Chat Agent)</sub></sup>              | Many <sup><sub>[Optional]<br> (e.g., OpenAI, Pinecone, etc.)</sub></sup>        | 7K <br><sup><sub>(core-only)</sub></sup>    | +26MB <br><sup><sub>(core-only)</sub></sup>          |
| **Orbit** | **Graph**                    | **None**                                                 | **None**                                                  | **~160**       | **+10KB**                  |

</div>

## How does Orbit work?

The [~160 lines](orbit.lua) capture the core abstraction of LLM frameworks: Graph!
<br>
<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/abstraction.png" width="900"/>
</div>
<br>

From there, it's easy to implement popular design patterns like ([Multi-](docs/design_pattern/multi_agent.md))[Agents](docs/design_pattern/agent.md), [Workflow](docs/design_pattern/workflow.md), [RAG](docs/design_pattern/rag.md), etc.
<br>
<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/design.png" width="900"/>
</div>
<br>
✨ Below are basic tutorials (more coming soon!):

<div align="center">
  
|  Name  | Difficulty    |  Description  |  
| :-------------:  | :-------------: | :--------------------- |  
| [Hello World](cookbook/orbit-hello-world) | ☆☆☆ <sup>*Dummy*</sup> | A simple hello world flow |
| [Chat](cookbook/orbit-chat) | ☆☆☆ <sup>*Dummy*</sup>  | A basic chat bot with conversation history |
| [Batch](cookbook/orbit-batch) | ☆☆☆ <sup>*Dummy*</sup> | A batch processor that translates markdown into multiple languages |

</div>

👀 Want to see other tutorials ported to Lua? [Create an issue!](https://github.com/The-Pocket/Orbit/issues/new)

## How to Use Orbit?

🚀 Through **Agentic Coding**—the fastest LLM App development paradigm-where *humans design* and *agents code*!

<br>
<div align="center">
  <a href="https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to" target="_blank">
    <img src="https://substackcdn.com/image/fetch/f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F423a39af-49e8-483b-bc5a-88cc764350c6_1050x588.png" width="700" alt="IMAGE ALT TEXT" style="cursor: pointer;">
  </a>
</div>
<br>

✨ Check out the [documentation](docs/index.md) for more advanced patterns:

<div align="center">
  
|  Topic     |  Description  |
| :-------------:  | :-------------: |
| [Agent](docs/design_pattern/agent.md) | Autonomous agents that use tools |
| [Workflow](docs/design_pattern/workflow.md) | Structured multi-step processes |
| [RAG](docs/design_pattern/rag.md) | Retrieval-augmented generation |
| [Map-Reduce](docs/design_pattern/mapreduce.md) | Parallel processing of large datasets |
| [Multi-Agent](docs/design_pattern/multi_agent.md) | Collaborative agent systems |

</div>

- Want to learn **Agentic Coding**?

  - Check out [my YouTube](https://www.youtube.com/@ZacharyLLM?sub_confirmation=1) for video tutorial on how some apps above are made!

  - Want to build your own LLM App? Read this [post](https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to)! Start with [this template](https://github.com/The-Pocket/Orbit-Template-Python)!
