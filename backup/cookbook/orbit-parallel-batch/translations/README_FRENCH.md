<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/title.png" alt="Pocket Flow – framework LLM minimaliste en 100 lignes" width="600"/>
</div>

<!-- [English](https://github.com/The-Pocket/orbit/blob/main/README.md) -->

[English](https://github.com/The-Pocket/orbit/blob/main/README.md) | [中文](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_CHINESE.md) | [Español](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_SPANISH.md) | [日本語](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_JAPANESE.md) | [Deutsch](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_GERMAN.md) | [Русский](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_RUSSIAN.md) | [Português](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_PORTUGUESE.md) | Français | [한국어](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_KOREAN.md)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
[![Docs](https://img.shields.io/badge/docs-latest-blue)](https://the-pocket.github.io/orbit/)
 <a href="https://discord.gg/hUHHE9Sa6T">
    <img src="https://img.shields.io/discord/1346833819172601907?logo=discord&style=flat">
</a>

Pocket Flow est un framework LLM minimaliste en [100 lignes](https://github.com/The-Pocket/orbit/blob/main/orbit/__init__.py)

- **Léger** : Seulement 100 lignes. Zéro superflu, zéro dépendance, zéro verrouillage fournisseur.
  
- **Expressif** : Tout ce que vous aimez — ([Multi-](https://the-pocket.github.io/orbit/design_pattern/multi_agent.html))[Agents](https://the-pocket.github.io/orbit/design_pattern/agent.html), [Workflow](https://the-pocket.github.io/orbit/design_pattern/workflow.html), [RAG](https://the-pocket.github.io/orbit/design_pattern/rag.html), et plus encore.

- **[Programmation Agentique](https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to)** : Laissez les Agents IA (par exemple, Cursor AI) créer des Agents — augmentez votre productivité par 10 !

Commencer avec Pocket Flow :
- Pour installer, ```pip install orbit``` ou copiez simplement le [code source](https://github.com/The-Pocket/orbit/blob/main/orbit/__init__.py) (seulement 100 lignes).
- Pour en savoir plus, consultez la [documentation](https://the-pocket.github.io/orbit/). Pour comprendre la motivation, lisez l'[histoire](https://zacharyhuang.substack.com/p/i-built-an-llm-framework-in-just).
- Des questions ? Consultez cet [Assistant IA](https://chatgpt.com/g/g-677464af36588191b9eba4901946557b-pocket-flow-assistant), ou [créez une issue !](https://github.com/The-Pocket/orbit/issues/new)
- 🎉 Rejoignez notre [Discord](https://discord.gg/hUHHE9Sa6T) pour vous connecter avec d'autres développeurs utilisant Pocket Flow !
- 🎉 Pocket Flow est initialement en Python, mais nous avons maintenant des versions en [Typescript](https://github.com/The-Pocket/orbit-Typescript), [Java](https://github.com/The-Pocket/orbit-Java), [C++](https://github.com/The-Pocket/orbit-CPP) et [Go](https://github.com/The-Pocket/orbit-Go) !

## Pourquoi Pocket Flow ?

Les frameworks LLM actuels sont surchargés... Vous n'avez besoin que de 100 lignes pour un framework LLM !

<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/meme.jpg" width="400"/>


  |                | **Abstraction**          | **Wrappers spécifiques aux applications**                                      | **Wrappers spécifiques aux fournisseurs**                                    | **Lignes**       | **Taille**    |
|----------------|:-----------------------------: |:-----------------------------------------------------------:|:------------------------------------------------------------:|:---------------:|:----------------------------:|
| LangChain  | Agent, Chain               | Nombreux <br><sup><sub>(ex., QA, Résumé)</sub></sup>              | Nombreux <br><sup><sub>(ex., OpenAI, Pinecone, etc.)</sub></sup>                   | 405K          | +166MB                     |
| CrewAI     | Agent, Chain            | Nombreux <br><sup><sub>(ex., FileReadTool, SerperDevTool)</sub></sup>         | Nombreux <br><sup><sub>(ex., OpenAI, Anthropic, Pinecone, etc.)</sub></sup>        | 18K           | +173MB                     |
| SmolAgent   | Agent                      | Quelques <br><sup><sub>(ex., CodeAgent, VisitWebTool)</sub></sup>         | Quelques <br><sup><sub>(ex., DuckDuckGo, Hugging Face, etc.)</sub></sup>           | 8K            | +198MB                     |
| LangGraph   | Agent, Graph           | Quelques <br><sup><sub>(ex., Recherche Sémantique)</sub></sup>                     | Quelques <br><sup><sub>(ex., PostgresStore, SqliteSaver, etc.) </sub></sup>        | 37K           | +51MB                      |
| AutoGen    | Agent                | Quelques <br><sup><sub>(ex., Tool Agent, Chat Agent)</sub></sup>              | Nombreux <sup><sub>[Optionnel]<br> (ex., OpenAI, Pinecone, etc.)</sub></sup>        | 7K <br><sup><sub>(core-only)</sub></sup>    | +26MB <br><sup><sub>(core-only)</sub></sup>          |
| **orbit** | **Graph**                    | **Aucun**                                                 | **Aucun**                                                  | **100**       | **+56KB**                  |

</div>

## Comment fonctionne Pocket Flow ?

Les [100 lignes](https://github.com/The-Pocket/orbit/blob/main/orbit/__init__.py) capturent l'abstraction fondamentale des frameworks LLM : le Graph !
<br>
<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/abstraction.png" width="900"/>
</div>
<br>

De là, il est facile d'implémenter des modèles de conception populaires comme ([Multi-](https://the-pocket.github.io/orbit/design_pattern/multi_agent.html))[Agents](https://the-pocket.github.io/orbit/design_pattern/agent.html), [Workflow](https://the-pocket.github.io/orbit/design_pattern/workflow.html), [RAG](https://the-pocket.github.io/orbit/design_pattern/rag.html), etc.
<br>
<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/design.png" width="900"/>
</div>
<br>
✨ Voici des tutoriels de base :

<div align="center">
  
|  Nom  | Difficulté    |  Description  |  
| :-------------:  | :-------------: | :--------------------- |  
| [Chat](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-chat) | ☆☆☆ <br> *Débutant*   | Un chatbot basique avec historique de conversation |
| [Sortie Structurée](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-structured-output) | ☆☆☆ <br> *Débutant* | Extraction de données structurées à partir de CV par prompt |
| [Workflow](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-workflow) | ☆☆☆ <br> *Débutant*   | Un workflow d'écriture qui planifie, rédige du contenu et applique un style |
| [Agent](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-agent) | ☆☆☆ <br> *Débutant*   | Un agent de recherche qui peut chercher sur le web et répondre aux questions |
| [RAG](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-rag) | ☆☆☆ <br> *Débutant*   | Un processus simple de génération augmentée par récupération |
| [Batch](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-batch) | ☆☆☆ <br> *Débutant* | Un processeur par lots qui traduit du contenu markdown en plusieurs langues |
| [Streaming](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-llm-streaming) | ☆☆☆ <br> *Débutant*   | Une démo de streaming LLM en temps réel avec capacité d'interruption utilisateur |
| [Garde-fou de Chat](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-chat-guardrail) | ☆☆☆ <br> *Débutant*  | Un chatbot conseiller de voyage qui ne traite que les requêtes liées au voyage |
| [Map-Reduce](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-map-reduce) | ★☆☆ <br> *Intermédiaire* | Un processeur de qualification de CV utilisant le modèle map-reduce pour l'évaluation par lots |
| [Multi-Agent](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-multi-agent) | ★☆☆ <br> *Intermédiaire* | Un jeu de Tabou pour la communication asynchrone entre deux agents |
| [Superviseur](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-supervisor) | ★☆☆ <br> *Intermédiaire* | L'agent de recherche devient peu fiable... Construisons un processus de supervision |
| [Parallèle](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-parallel-batch) | ★☆☆ <br> *Intermédiaire*   | Une démo d'exécution parallèle montrant une accélération de 3x |
| [Flux Parallèle](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-parallel-batch-flow) | ★☆☆ <br> *Intermédiaire*   | Une démo de traitement d'image parallèle montrant une accélération de 8x avec plusieurs filtres |
| [Vote Majoritaire](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-majority-vote) | ★☆☆ <br> *Intermédiaire* | Améliorer la précision du raisonnement en agrégeant plusieurs tentatives de solution |
| [Réflexion](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-thinking) | ★☆☆ <br> *Intermédiaire*   | Résoudre des problèmes de raisonnement complexes grâce à la Chaîne de Pensée |
| [Mémoire](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-chat-memory) | ★☆☆ <br> *Intermédiaire* | Un chatbot avec mémoire à court et long terme |
| [Text2SQL](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-text2sql) | ★☆☆ <br> *Intermédiaire* | Convertir le langage naturel en requêtes SQL avec une boucle d'auto-débogage |
| [MCP](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-mcp) | ★☆☆ <br> *Intermédiaire* |  Agent utilisant le Protocole de Contexte de Modèle pour les opérations numériques |
| [A2A](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-a2a) | ★☆☆ <br> *Intermédiaire* | Agent encapsulé avec le protocole Agent-to-Agent pour la communication inter-agent |
| [Web HITL](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-web-hitl) | ★☆☆ <br> *Intermédiaire* | Un service web minimal pour une boucle de révision humaine avec mises à jour SSE |

</div>

👀 Vous voulez voir d'autres tutoriels pour débutants ? [Créez une issue !](https://github.com/The-Pocket/orbit/issues/new)

## Comment utiliser Pocket Flow ?

🚀 Par la **Programmation Agentique** — le paradigme de développement d'applications LLM le plus rapide — où *les humains conçoivent* et *les agents programment* !

<br>
<div align="center">
  <a href="https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to" target="_blank">
    <img src="https://substackcdn.com/image/fetch/f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F423a39af-49e8-483b-bc5a-88cc764350c6_1050x588.png" width="700" alt="IMAGE ALT TEXT" style="cursor: pointer;">
  </a>
</div>
<br>

✨ Voici des exemples d'applications LLM plus complexes :

<div align="center">
  
|  Nom de l'application     |  Difficulté    | Sujets  | Conception Humaine | Code Agent |
| :-------------:  | :-------------: | :---------------------: |  :---: |  :---: |
| [Construire Cursor avec Cursor](https://github.com/The-Pocket/Tutorial-Cursor) <br> <sup><sub>Nous atteindrons bientôt la singularité ...</sup></sub> | ★★★ <br> *Avancé*   | [Agent](https://the-pocket.github.io/orbit/design_pattern/agent.html) | [Document de conception](https://github.com/The-Pocket/Tutorial-Cursor/blob/main/docs/design.md) | [Code Flow](https://github.com/The-Pocket/Tutorial-Cursor/blob/main/flow.py)
| [Constructeur de Connaissances de Base de Code](https://github.com/The-Pocket/Tutorial-Codebase-Knowledge) <br> <sup><sub>La vie est trop courte pour rester perplexe devant le code des autres</sup></sub> |  ★★☆ <br> *Moyen* | [Workflow](https://the-pocket.github.io/orbit/design_pattern/workflow.html) | [Document de conception](https://github.com/The-Pocket/Tutorial-Codebase-Knowledge/blob/main/docs/design.md) | [Code Flow](https://github.com/The-Pocket/Tutorial-Codebase-Knowledge/blob/main/flow.py)
| [Interroger l'IA Paul Graham](https://github.com/The-Pocket/Tutorial-YC-Partner) <br> <sup><sub>Interrogez l'IA Paul Graham, au cas où vous ne seriez pas accepté</sup></sub> | ★★☆ <br> *Moyen*  | [RAG](https://the-pocket.github.io/orbit/design_pattern/rag.html) <br> [Map Reduce](https://the-pocket.github.io/orbit/design_pattern/mapreduce.html) <br> [TTS](https://the-pocket.github.io/orbit/utility_function/text_to_speech.html) | [Document de conception](https://github.com/The-Pocket/Tutorial-AI-Paul-Graham/blob/main/docs/design.md) | [Code Flow](https://github.com/The-Pocket/Tutorial-AI-Paul-Graham/blob/main/flow.py)
| [Résumeur Youtube](https://github.com/The-Pocket/Tutorial-Youtube-Made-Simple)  <br> <sup><sub> Vous explique les vidéos YouTube comme si vous aviez 5 ans </sup></sub> | ★☆☆ <br> *Intermédiaire*   | [Map Reduce](https://the-pocket.github.io/orbit/design_pattern/mapreduce.html) |  [Document de conception](https://github.com/The-Pocket/Tutorial-Youtube-Made-Simple/blob/main/docs/design.md) | [Code Flow](https://github.com/The-Pocket/Tutorial-Youtube-Made-Simple/blob/main/flow.py)
| [Générateur d'Accroche pour Email](https://github.com/The-Pocket/Tutorial-Cold-Email-Personalization)  <br> <sup><sub> Des brise-glaces instantanés qui transforment les prospects froids en prospects chauds </sup></sub> | ★☆☆ <br> *Intermédiaire*   | [Map Reduce](https://the-pocket.github.io/orbit/design_pattern/mapreduce.html) <br> [Recherche Web](https://the-pocket.github.io/orbit/utility_function/websearch.html) |  [Document de conception](https://github.com/The-Pocket/Tutorial-Cold-Email-Personalization/blob/master/docs/design.md) | [Code Flow](https://github.com/The-Pocket/Tutorial-Cold-Email-Personalization/blob/master/flow.py)

</div>

- Vous voulez apprendre la **Programmation Agentique** ?

  - Consultez [ma chaîne YouTube](https://www.youtube.com/@ZacharyLLM?sub_confirmation=1) pour des tutoriels vidéo sur la façon dont certaines applications ci-dessus sont créées !

  - Vous voulez créer votre propre application LLM ? Lisez cet [article](https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to) ! Commencez avec [ce modèle](https://github.com/The-Pocket/orbit-Template-Python) !
