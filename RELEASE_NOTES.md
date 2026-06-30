# Farm Release Notes (リリースノート)

本ドキュメントは、Farmフレームワークのアップデートおよび機能追加の歴史を記録するリリースノートです。

---

## [2026-06-30] OKF (Open Knowledge Format) & LLM Wiki パターンの統合

### 追加・変更内容
AI時代のナレッジ管理（Markdown＋メタデータ）の統一規格である **OKF** と、知識の累積・自律保守を促す **LLM Wiki** のコンセプトをFarmフレームワークの仕様として統合しました。

#### 1. 新設ファイル
- **[RELEASE_NOTES.md](./RELEASE_NOTES.md) (本ファイル)**: 今後のアップデート履歴を追跡するためのリリースノート。
- **[okf_soil_template.md](./40_trellis/templates/okf_soil_template.md)**: `00_soil/`（正規情報）に追加されるファイルをOKF仕様（YAMLフロントマター＋関連コンセプトリンク）化するための標準テンプレート。
- **[soil_index.md](./00_soil/soil_index.md)**: `00_soil/` 配下の全情報を俯瞰し、AIがセマンティック検索の起点とするメタデータ・カタログ（Git管理対象外）。

#### 2. プロトコル・ルールの更新
- **[layer_protocol_rules.md](./40_trellis/rules/layer_protocol_rules.md)**: 
  - **OKF仕様**: `00_soil/` 配下の正規情報に対するOKF適用を義務化。
  - **検索最適化（芋づる式検索）**: OKFメタデータを用いたフィルタリングと、マークダウンリンクを追跡する（Traversal Search）グラフ状のコンテキスト収集プロトコル。
  - **Lint（定期検診）プロトコル**: 関連ドキュメント間の矛盾検知、リンク切れ・孤立ページの確認、情報の鮮度（SLA期限）チェックをAIが実行するためのルール。
  - **Queryの永続化**: チャットで生まれた有益な知見（要約・比較分析など）を `20_seedbank/conversations/` 等にアセット保存する仕組み。
- **[agent_orchestration_rules.md](./40_trellis/rules/agent_orchestration_rules.md)** & **[operating_model.md](./00_soil/farm/operating_model.md)**:
  - `Soil Keeper` にインデックスの維持管理、`Weather Observer` にチャット知見の永続化、`Orchestrator` にメタデータ検索とLintの実施を追加。
- **[agent.md](./agent.md)**:
  - 起動時のプロトコル確認事項にOKFを追記。
  - `[Lint]` イベント、および `クエリ永続化` の動作指示を基本動作ルールに追加。
