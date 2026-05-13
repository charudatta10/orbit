<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/title.png" alt="Pocket Flow – 100行のミニマリストLLMフレームワーク" width="600"/>
</div>

<!-- [English](https://github.com/The-Pocket/orbit/blob/main/README.md) -->

English | [中文](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_CHINESE.md) | [Español](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_SPANISH.md) | [日本語](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_JAPANESE.md) | [Deutsch](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_GERMAN.md) | [Русский](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_RUSSIAN.md) | [Português](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_PORTUGUESE.md) | [Français](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_FRENCH.md) | [한국어](https://github.com/The-Pocket/orbit/blob/main/cookbook/orbit-batch/translations/README_KOREAN.md)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
[![Docs](https://img.shields.io/badge/docs-latest-blue)](https://the-pocket.github.io/orbit/)
 <a href="https://discord.gg/hUHHE9Sa6T">
    <img src="https://img.shields.io/discord/1346833819172601907?logo=discord&style=flat">
</a>

Pocket Flowは[たった100行](https://github.com/The-Pocket/orbit/blob/main/orbit/__init__.py)のミニマリストLLMフレームワークです

- **軽量**: わずか100行。余分なものなし、依存関係なし、ベンダーロックインなし。
  
- **表現力豊か**: あなたが愛するすべてのもの—([マルチ](https://the-pocket.github.io/orbit/design_pattern/multi_agent.html))[エージェント](https://the-pocket.github.io/orbit/design_pattern/agent.html)、[ワークフロー](https://the-pocket.github.io/orbit/design_pattern/workflow.html)、[RAG](https://the-pocket.github.io/orbit/design_pattern/rag.html)など。

- **[エージェンティックコーディング](https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to)**: AIエージェント（例：Cursor AI）にエージェントを構築させる—生産性が10倍向上！

Pocket Flowを始めるには：
- インストールするには、```pip install orbit```または[ソースコード](https://github.com/The-Pocket/orbit/blob/main/orbit/__init__.py)（わずか100行）をコピーするだけです。
- 詳細については、[ドキュメント](https://the-pocket.github.io/orbit/)をご覧ください。開発の動機については、[ストーリー](https://zacharyhuang.substack.com/p/i-built-an-llm-framework-in-just)をお読みください。
- 質問がありますか？この[AIアシスタント](https://chatgpt.com/g/g-677464af36588191b9eba4901946557b-pocket-flow-assistant)をチェックするか、[問題を作成してください！](https://github.com/The-Pocket/orbit/issues/new)
- 🎉 [Discord](https://discord.gg/hUHHE9Sa6T)に参加して、Pocket Flowで開発している他の開発者とつながりましょう！
- 🎉 Pocket Flowは最初はPythonですが、現在は[Typescript](https://github.com/The-Pocket/orbit-Typescript)、[Java](https://github.com/The-Pocket/orbit-Java)、[C++](https://github.com/The-Pocket/orbit-CPP)、[Go](https://github.com/The-Pocket/orbit-Go)バージョンもあります！

## なぜPocket Flow？

現在のLLMフレームワークは膨大すぎます... LLMフレームワークには100行だけで十分です！

<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/meme.jpg" width="400"/>


  |                | **抽象化**          | **アプリ固有のラッパー**                                      | **ベンダー固有のラッパー**                                    | **行数**       | **サイズ**    |
|----------------|:-----------------------------: |:-----------------------------------------------------------:|:------------------------------------------------------------:|:---------------:|:----------------------------:|
| LangChain  | エージェント、チェーン               | 多数 <br><sup><sub>(例：QA、要約)</sub></sup>              | 多数 <br><sup><sub>(例：OpenAI、Pineconeなど)</sub></sup>                   | 405K          | +166MB                     |
| CrewAI     | エージェント、チェーン            | 多数 <br><sup><sub>(例：FileReadTool、SerperDevTool)</sub></sup>         | 多数 <br><sup><sub>(例：OpenAI、Anthropic、Pineconeなど)</sub></sup>        | 18K           | +173MB                     |
| SmolAgent   | エージェント                      | 一部 <br><sup><sub>(例：CodeAgent、VisitWebTool)</sub></sup>         | 一部 <br><sup><sub>(例：DuckDuckGo、Hugging Faceなど)</sub></sup>           | 8K            | +198MB                     |
| LangGraph   | エージェント、グラフ           | 一部 <br><sup><sub>(例：セマンティック検索)</sub></sup>                     | 一部 <br><sup><sub>(例：PostgresStore、SqliteSaverなど) </sub></sup>        | 37K           | +51MB                      |
| AutoGen    | エージェント                | 一部 <br><sup><sub>(例：ツールエージェント、チャットエージェント)</sub></sup>              | 多数 <sup><sub>[オプション]<br> (例：OpenAI、Pineconeなど)</sub></sup>        | 7K <br><sup><sub>(コアのみ)</sub></sup>    | +26MB <br><sup><sub>(コアのみ)</sub></sup>          |
| **orbit** | **グラフ**                    | **なし**                                                 | **なし**                                                  | **100**       | **+56KB**                  |

</div>

## Pocket Flowはどのように機能するのか？

[100行](https://github.com/The-Pocket/orbit/blob/main/orbit/__init__.py)がLLMフレームワークの中核的抽象化を捉えています：グラフ！
<br>
<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/abstraction.png" width="900"/>
</div>
<br>

そこから、([マルチ](https://the-pocket.github.io/orbit/design_pattern/multi_agent.html))[エージェント](https://the-pocket.github.io/orbit/design_pattern/agent.html)、[ワークフロー](https://the-pocket.github.io/orbit/design_pattern/workflow.html)、[RAG](https://the-pocket.github.io/orbit/design_pattern/rag.html)などの人気のあるデザインパターンを簡単に実装できます。
<br>
<div align="center">
  <img src="https://github.com/The-Pocket/.github/raw/main/assets/design.png" width="900"/>
</div>
<br>
✨ 以下は基本的なチュートリアルです：

<div align="center">
  
|  名前  | 難易度    |  説明  |  
| :-------------:  | :-------------: | :--------------------- |  
| [チャット](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-chat) | ☆☆☆ <br> *超簡単*   | 会話履歴を持つ基本的なチャットボット |
| [構造化出力](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-structured-output) | ☆☆☆ <br> *超簡単* | プロンプトを使って履歴書から構造化データを抽出する |
| [ワークフロー](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-workflow) | ☆☆☆ <br> *超簡単*   | アウトライン作成、コンテンツ作成、スタイル適用を行うライティングワークフロー |
| [エージェント](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-agent) | ☆☆☆ <br> *超簡単*   | ウェブを検索して質問に答えることができる調査エージェント |
| [RAG](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-rag) | ☆☆☆ <br> *超簡単*   | シンプルな検索拡張生成プロセス |
| [バッチ処理](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-batch) | ☆☆☆ <br> *超簡単* | マークダウンコンテンツを複数の言語に翻訳するバッチプロセッサ |
| [ストリーミング](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-llm-streaming) | ☆☆☆ <br> *超簡単*   | ユーザー割り込み機能を備えたリアルタイムLLMストリーミングデモ |
| [チャットガードレール](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-chat-guardrail) | ☆☆☆ <br> *超簡単*  | 旅行関連のクエリのみを処理する旅行アドバイザーチャットボット |
| [マップリデュース](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-map-reduce) | ★☆☆ <br> *初級* | マップリデュースパターンを使用したバッチ評価の履歴書資格処理プログラム |
| [マルチエージェント](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-multi-agent) | ★☆☆ <br> *初級* | 2つのエージェント間の非同期通信のためのタブーワードゲーム |
| [スーパーバイザー](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-supervisor) | ★☆☆ <br> *初級* | 調査エージェントが信頼性を失っています... 監視プロセスを構築しましょう |
| [並列処理](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-parallel-batch) | ★☆☆ <br> *初級*   | 3倍の高速化を示す並列実行デモ |
| [並列フロー](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-parallel-batch-flow) | ★☆☆ <br> *初級*   | 複数のフィルターによる8倍の高速化を示す並列画像処理デモ |
| [多数決](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-majority-vote) | ★☆☆ <br> *初級* | 複数の解決策を集約して推論の精度を向上させる |
| [思考](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-thinking) | ★☆☆ <br> *初級*   | 思考の連鎖を通じて複雑な推論問題を解決する |
| [メモリ](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-chat-memory) | ★☆☆ <br> *初級* | 短期記憶と長期記憶を持つチャットボット |
| [Text2SQL](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-text2sql) | ★☆☆ <br> *初級* | 自動デバッグループを備えた自然言語からSQLクエリへの変換 |
| [MCP](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-mcp) | ★☆☆ <br> *初級* | 数値演算のためのモデルコンテキストプロトコルを使用するエージェント |
| [A2A](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-a2a) | ★☆☆ <br> *初級* | エージェント間通信のためのエージェント間プロトコルでラップされたエージェント |
| [Web HITL](https://github.com/The-Pocket/orbit/tree/main/cookbook/orbit-web-hitl) | ★☆☆ <br> *初級* | SSE更新を備えた人間レビューループのためのミニマルなウェブサービス |

</div>

👀 他の超初心者向けチュートリアルを見たいですか？[問題を作成してください！](https://github.com/The-Pocket/orbit/issues/new)

## Pocket Flowの使い方

🚀 **エージェンティックコーディング**を通じて—*人間が設計し*、*エージェントがコーディングする*最速のLLMアプリ開発パラダイム！

<br>
<div align="center">
  <a href="https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to" target="_blank">
    <img src="https://substackcdn.com/image/fetch/f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F423a39af-49e8-483b-bc5a-88cc764350c6_1050x588.png" width="700" alt="イメージ代替テキスト" style="cursor: pointer;">
  </a>
</div>
<br>

✨ 以下はより複雑なLLMアプリの例です：

<div align="center">
  
|  アプリ名     |  難易度    | トピック  | 人間の設計 | エージェントのコード |
| :-------------:  | :-------------: | :---------------------: |  :---: |  :---: |
| [CursorでCursorを構築する](https://github.com/The-Pocket/Tutorial-Cursor) <br> <sup><sub>もうすぐシンギュラリティに達します...</sup></sub> | ★★★ <br> *上級*   | [エージェント](https://the-pocket.github.io/orbit/design_pattern/agent.html) | [設計ドキュメント](https://github.com/The-Pocket/Tutorial-Cursor/blob/main/docs/design.md) | [フローコード](https://github.com/The-Pocket/Tutorial-Cursor/blob/main/flow.py)
| [コードベース知識ビルダー](https://github.com/The-Pocket/Tutorial-Codebase-Knowledge) <br> <sup><sub>他人のコードを混乱して見つめるほど人生は短くない</sup></sub> |  ★★☆ <br> *中級* | [ワークフロー](https://the-pocket.github.io/orbit/design_pattern/workflow.html) | [設計ドキュメント](https://github.com/The-Pocket/Tutorial-Codebase-Knowledge/blob/main/docs/design.md) | [フローコード](https://github.com/The-Pocket/Tutorial-Codebase-Knowledge/blob/main/flow.py)
| [AI Paul Grahamに質問する](https://github.com/The-Pocket/Tutorial-YC-Partner) <br> <sup><sub>採用されない場合に備えて、AI Paul Grahamに質問しましょう</sup></sub> | ★★☆ <br> *中級*  | [RAG](https://the-pocket.github.io/orbit/design_pattern/rag.html) <br> [マップリデュース](https://the-pocket.github.io/orbit/design_pattern/mapreduce.html) <br> [TTS](https://the-pocket.github.io/orbit/utility_function/text_to_speech.html) | [設計ドキュメント](https://github.com/The-Pocket/Tutorial-AI-Paul-Graham/blob/main/docs/design.md) | [フローコード](https://github.com/The-Pocket/Tutorial-AI-Paul-Graham/blob/main/flow.py)
| [Youtubeサマライザー](https://github.com/The-Pocket/Tutorial-Youtube-Made-Simple)  <br> <sup><sub> 5歳児にもわかるようにYouTube動画を説明 </sup></sub> | ★☆☆ <br> *初級*   | [マップリデュース](https://the-pocket.github.io/orbit/design_pattern/mapreduce.html) |  [設計ドキュメント](https://github.com/The-Pocket/Tutorial-Youtube-Made-Simple/blob/main/docs/design.md) | [フローコード](https://github.com/The-Pocket/Tutorial-Youtube-Made-Simple/blob/main/flow.py)
| [コールドオープナージェネレーター](https://github.com/The-Pocket/Tutorial-Cold-Email-Personalization)  <br> <sup><sub> 冷たいリードを熱くする即席アイスブレイカー </sup></sub> | ★☆☆ <br> *初級*   | [マップリデュース](https://the-pocket.github.io/orbit/design_pattern/mapreduce.html) <br> [ウェブ検索](https://the-pocket.github.io/orbit/utility_function/websearch.html) |  [設計ドキュメント](https://github.com/The-Pocket/Tutorial-Cold-Email-Personalization/blob/master/docs/design.md) | [フローコード](https://github.com/The-Pocket/Tutorial-Cold-Email-Personalization/blob/master/flow.py)

</div>

- **エージェンティックコーディング**を学びたいですか？

  - 上記のアプリの作り方に関するビデオチュートリアルについては、[私のYouTube](https://www.youtube.com/@ZacharyLLM?sub_confirmation=1)をチェックしてください！

  - 自分のLLMアプリを構築したいですか？この[投稿](https://zacharyhuang.substack.com/p/agentic-coding-the-most-fun-way-to)を読んでください！[このテンプレート](https://github.com/The-Pocket/orbit-Template-Python)から始めましょう！
