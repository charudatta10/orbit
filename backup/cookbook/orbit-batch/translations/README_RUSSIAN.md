<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/title.png" alt="Pocket Flow – 100-line minimalist LLM framework" width="600"/>
</div>

<!-- [English](https://github.com/The-Pocket/orbit/blob/main/README.md) -->

[English](https://github.com/The-Pocket/orbit/blob/main/README.md) | [中文](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_CHINESE.md) | [Español](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_SPANISH.md) | [日本語](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_JAPANESE.md) | [Deutsch](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_GERMAN.md) | Русский| [Português](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_PORTUGUESE.md) | [Français](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_FRENCH.md) | [한국어](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_KOREAN.md)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
[![Docs](https://img.shields.io/badge/docs-latest-blue)](https://the-pocket.github.io/orbit/)
 <a href="https://discord.gg/hUHHE9Sa6T">
    <img src="https://img.shields.io/discord/1346833819172601907?logo=discord&style=flat">
</a>

Pocket Flow — это минималистичный фреймворк для LLM всего в [100 строк](https://github.com/The-Pocket/orbit/blob/main/orbit/__init__.py)

- **Легкий**: Всего 100 строк. Никакого лишнего веса, никаких зависимостей, никакой привязки к вендорам.
  
- **Выразительный**: Всё, что вы любите — ([Мульти-](https://the-pocket.github.io/orbit/design_pattern/multi_agent.html))[Агенты](https://the-pocket.github.io/orbit/design_pattern/agent.html), [Рабочие процессы](https://the-pocket.github.io/orbit/design_pattern/workflow.html), [RAG](https://the-pocket.github.io/orbit/design_pattern/rag.html) и многое другое.

- **[Агентское кодирование](https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to)**: Позвольте ИИ-агентам (например, Cursor AI) создавать других агентов — повысьте продуктивность в 10 раз!

Начало работы с Pocket Flow:
- Для установки, ```pip install orbit``` или просто скопируйте [исходный код](https://github.com/The-Pocket/orbit/blob/main/orbit/__init__.py) (всего 100 строк).
- Чтобы узнать больше, ознакомьтесь с [документацией](https://the-pocket.github.io/orbit/). Чтобы понять мотивацию, прочитайте [историю](https://zacharyhuang.substack.com/p/i-built-an-llm-framework-in-just).
- Есть вопросы? Спросите этого [ИИ-ассистента](https://chatgpt.com/g/g-677464af36588191b9eba4901946557b-pocket-flow-assistant) или [создайте issue!](https://github.com/The-Pocket/orbit/issues/new)
- 🎉 Присоединяйтесь к нашему [Discord](https://discord.gg/hUHHE9Sa6T), чтобы общаться с другими разработчиками, использующими Pocket Flow!
- 🎉 Pocket Flow изначально написан на Python, но теперь у нас есть версии на [Typescript](https://github.com/The-Pocket/orbit-Typescript), [Java](https://github.com/The-Pocket/orbit-Java), [C++](https://github.com/The-Pocket/orbit-CPP) и [Go](https://github.com/The-Pocket/orbit-Go)!

## Почему Pocket Flow?

Современные фреймворки для LLM слишком громоздкие... Для фреймворка LLM достаточно всего 100 строк!

<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/meme.jpg" width="400"/>


  |                | **Абстракция**          | **Обертки для конкретных приложений**                                      | **Обертки для конкретных вендоров**                                    | **Строк**       | **Размер**    |
|----------------|:-----------------------------: |:-----------------------------------------------------------:|:------------------------------------------------------------:|:---------------:|:----------------------------:|
| LangChain  | Agent, Chain               | Много <br><sup><sub>(напр., QA, Суммаризация)</sub></sup>              | Много <br><sup><sub>(напр., OpenAI, Pinecone и т.д.)</sub></sup>                   | 405K          | +166MB                     |
| CrewAI     | Agent, Chain            | Много <br><sup><sub>(напр., FileReadTool, SerperDevTool)</sub></sup>         | Много <br><sup><sub>(напр., OpenAI, Anthropic, Pinecone и т.д.)</sub></sup>        | 18K           | +173MB                     |
| SmolAgent   | Agent                      | Несколько <br><sup><sub>(напр., CodeAgent, VisitWebTool)</sub></sup>         | Несколько <br><sup><sub>(напр., DuckDuckGo, Hugging Face и т.д.)</sub></sup>           | 8K            | +198MB                     |
| LangGraph   | Agent, Graph           | Несколько <br><sup><sub>(напр., Semantic Search)</sub></sup>                     | Несколько <br><sup><sub>(напр., PostgresStore, SqliteSaver и т.д.) </sub></sup>        | 37K           | +51MB                      |
| AutoGen    | Agent                | Несколько <br><sup><sub>(напр., Tool Agent, Chat Agent)</sub></sup>              | Много <sup><sub>[Опционально]<br> (напр., OpenAI, Pinecone и т.д.)</sub></sup>        | 7K <br><sup><sub>(только ядро)</sub></sup>    | +26MB <br><sup><sub>(только ядро)</sub></sup>          |
| **orbit** | **Graph**                    | **Нет**                                                 | **Нет**                                                  | **100**       | **+56KB**                  |

</div>

## Как работает Pocket Flow?

[100 строк](https://github.com/The-Pocket/orbit/blob/main/orbit/__init__.py) охватывают ключевую абстракцию фреймворков LLM: Граф!
<br>
<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/abstraction.png" width="900"/>
</div>
<br>

Отсюда легко реализовать популярные шаблоны проектирования, такие как ([Мульти-](https://the-pocket.github.io/orbit/design_pattern/multi_agent.html))[Агенты](https://the-pocket.github.io/orbit/design_pattern/agent.html), [Рабочие процессы](https://the-pocket.github.io/orbit/design_pattern/workflow.html), [RAG](https://the-pocket.github.io/orbit/design_pattern/rag.html) и другие.
<br>
<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/design.png" width="900"/>
</div>
<br>
✨ Ниже приведены базовые руководства:

<div align="center">
  
|  Название  | Сложность    |  Описание  |  
| :-------------:  | :-------------: | :--------------------- |  
| [Чат](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-chat) | ☆☆☆ <br> *Простейший*   | Базовый чат-бот с историей разговора |
| [Структурированный вывод](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-structured-output) | ☆☆☆ <br> *Простейший* | Извлечение структурированных данных из резюме с помощью промптов |
| [Рабочий процесс](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-workflow) | ☆☆☆ <br> *Простейший*   | Процесс написания, который создает план, пишет контент и применяет стили |
| [Агент](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-agent) | ☆☆☆ <br> *Простейший*   | Исследовательский агент, который может искать в интернете и отвечать на вопросы |
| [RAG](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-rag) | ☆☆☆ <br> *Простейший*   | Простой процесс генерации с извлечением информации |
| [Пакетная обработка](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-batch) | ☆☆☆ <br> *Простейший* | Пакетный процессор, который переводит markdown-контент на несколько языков |
| [Потоковая передача](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-llm-streaming) | ☆☆☆ <br> *Простейший*   | Демонстрация потоковой передачи LLM в реальном времени с возможностью прерывания пользователем |
| [Ограничение чата](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-chat-guardrail) | ☆☆☆ <br> *Простейший*  | Чат-бот туристического консультанта, обрабатывающий только запросы, связанные с путешествиями |
| [Map-Reduce](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-map-reduce) | ★☆☆ <br> *Начальный* | Процессор квалификации резюме, использующий паттерн map-reduce для пакетной оценки |
| [Мульти-агент](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-multi-agent) | ★☆☆ <br> *Начальный* | Игра Табу для асинхронного общения между двумя агентами |
| [Супервизор](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-supervisor) | ★☆☆ <br> *Начальный* | Исследовательский агент становится ненадежным... Давайте создадим процесс надзора|
| [Параллельное выполнение](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-parallel-batch) | ★☆☆ <br> *Начальный*   | Демонстрация параллельного выполнения, показывающая 3-кратное ускорение |
| [Параллельный поток](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-parallel-batch-flow) | ★☆☆ <br> *Начальный*   | Демонстрация параллельной обработки изображений, показывающая 8-кратное ускорение с несколькими фильтрами |
| [Голосование большинством](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-majority-vote) | ★☆☆ <br> *Начальный* | Повышение точности рассуждений путем агрегации нескольких попыток решения |
| [Мышление](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-thinking) | ★☆☆ <br> *Начальный*   | Решение сложных задач рассуждения с помощью цепочки размышлений |
| [Память](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-chat-memory) | ★☆☆ <br> *Начальный* | Чат-бот с кратковременной и долговременной памятью |
| [Text2SQL](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-text2sql) | ★☆☆ <br> *Начальный* | Преобразование естественного языка в SQL-запросы с автоматическим циклом отладки |
| [MCP](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-mcp) | ★☆☆ <br> *Начальный* | Агент, использующий протокол контекста модели для числовых операций |
| [A2A](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-a2a) | ★☆☆ <br> *Начальный* | Агент, обернутый протоколом агент-к-агенту для межагентного взаимодействия |
| [Web HITL](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-web-hitl) | ★☆☆ <br> *Начальный* | Минимальный веб-сервис для цикла проверки человеком с обновлениями SSE |

</div>

👀 Хотите увидеть другие руководства для начинающих? [Создайте issue!](https://github.com/The-Pocket/orbit/issues/new)

## Как использовать Pocket Flow?

🚀 Через **Агентское кодирование** — самую быструю парадигму разработки LLM-приложений, где *люди проектируют*, а *агенты кодируют*!

<br>
<div align="center">
  <a href="https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to" target="_blank">
    <img src="https://substackcdn.com/image/fetch/f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F423a39af-49e8-483b-bc5a-88cc764350c6_1050x588.png" width="700" alt="IMAGE ALT TEXT" style="cursor: pointer;">
  </a>
</div>
<br>

✨ Ниже приведены примеры более сложных LLM-приложений:

<div align="center">
  
|  Название приложения     |  Сложность    | Темы  | Дизайн от человека | Код от агента |
| :-------------:  | :-------------: | :---------------------: |  :---: |  :---: |
| [Создание Cursor с помощью Cursor](https://github.com/The-Pocket/Tutorial-Cursor) <br> <sup><sub>Скоро достигнем сингулярности ...</sup></sub> | ★★★ <br> *Продвинутый*   | [Агент](https://the-pocket.github.io/orbit/design_pattern/agent.html) | [Документация по дизайну](https://github.com/The-Pocket/Tutorial-Cursor/blob/main/docs/design.md) | [Код потока](https://github.com/The-Pocket/Tutorial-Cursor/blob/main/flow.py)
| [Конструктор знаний о кодовой базе](https://github.com/The-Pocket/Tutorial-Codebase-Knowledge) <br> <sup><sub>Жизнь слишком коротка, чтобы в растерянности смотреть на чужой код</sup></sub> |  ★★☆ <br> *Средний* | [Рабочий процесс](https://the-pocket.github.io/orbit/design_pattern/workflow.html) | [Документация по дизайну](https://github.com/The-Pocket/Tutorial-Codebase-Knowledge/blob/main/docs/design.md) | [Код потока](https://github.com/The-Pocket/Tutorial-Codebase-Knowledge/blob/main/flow.py)
| [Спроси ИИ Пола Грэма](https://github.com/The-Pocket/Tutorial-YC-Partner) <br> <sup><sub>Спроси ИИ Пола Грэма, если тебя не приняли</sup></sub> | ★★☆ <br> *Средний*  | [RAG](https://the-pocket.github.io/orbit/design_pattern/rag.html) <br> [Map Reduce](https://the-pocket.github.io/orbit/design_pattern/mapreduce.html) <br> [TTS](https://the-pocket.github.io/orbit/utility_function/text_to_speech.html) | [Документация по дизайну](https://github.com/The-Pocket/Tutorial-AI-Paul-Graham/blob/main/docs/design.md) | [Код потока](https://github.com/The-Pocket/Tutorial-AI-Paul-Graham/blob/main/flow.py)
| [Суммаризатор YouTube](https://github.com/The-Pocket/Tutorial-Youtube-Made-Simple)  <br> <sup><sub> Объясняет YouTube-видео как для 5-летнего </sup></sub> | ★☆☆ <br> *Начальный*   | [Map Reduce](https://the-pocket.github.io/orbit/design_pattern/mapreduce.html) |  [Документация по дизайну](https://github.com/The-Pocket/Tutorial-Youtube-Made-Simple/blob/main/docs/design.md) | [Код потока](https://github.com/The-Pocket/Tutorial-Youtube-Made-Simple/blob/main/flow.py)
| [Генератор холодных открытий](https://github.com/The-Pocket/Tutorial-Cold-Email-Personalization)  <br> <sup><sub> Мгновенные ледоколы, превращающие холодных лидов в горячих </sup></sub> | ★☆☆ <br> *Начальный*   | [Map Reduce](https://the-pocket.github.io/orbit/design_pattern/mapreduce.html) <br> [Веб-поиск](https://the-pocket.github.io/orbit/utility_function/websearch.html) |  [Документация по дизайну](https://github.com/The-Pocket/Tutorial-Cold-Email-Personalization/blob/master/docs/design.md) | [Код потока](https://github.com/The-Pocket/Tutorial-Cold-Email-Personalization/blob/master/flow.py)

</div>

- Хотите изучить **Агентское кодирование**?

  - Посмотрите [мой YouTube](https://www.youtube.com/@ZacharyLLM?sub_confirmation=1) для видеоуроков о том, как создаются некоторые из вышеперечисленных приложений!

  - Хотите создать свое собственное LLM-приложение? Прочитайте эту [статью](https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to)! Начните с [этого шаблона](https://github.com/The-Pocket/orbit-Template-Python)!
