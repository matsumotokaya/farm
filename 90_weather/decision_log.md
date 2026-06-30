# Decision Log（意思決定の記録）

> Farm の構造・運用ルール・情報分類の変更、および成果物の版昇格・表現統制実施などの「決定」を記録する場所。
> 詳細ルール：`40_trellis/rules/farm_evolution_rules.md` §7, §9（ログ記録先 早見表）

`90_weather/soil_changelog.md` との違い：
- `soil_changelog.md` は `00_soil/` の正規情報変更のみを記録する。
- 本ファイルは、それ以外の決定（版昇格、Farm 構造変更、運用ルール変更、表現統制実施 等）を記録する。

## エントリ書式

```
## YYYY-MM-DD / <decision_id>

- type: <version_promotion / farm_structure / rule_change / expression_governance / other>
- subject: <対象 artifact または対象領域>
- decision: <何を決めたか>
- reason: <なぜそう決めたか>
- affected_files: <影響を受けたファイル一覧>
- related_log_ids: <関連する soil_changelog の Log ID など>
```

ログを書くときは `40_trellis/rules/expression_governance_rules.md` §3 に従い、
統制対象となった具体表現を生のまま残さず抽象化すること。

---

## Log

## 2026-05-24 / DEC-2026-05-24-01

- type: farm_structure / rule_change
- subject: Farm Core ルール群の整合性整理（fb-011）
- decision: 議論の余地のない不整合 5 件を一括で解消する。
  1. `propagation_rules.md` 削除（layer_protocol_rules.md と完全重複・孤児化）
  2. `artifact_rules.md` §2 のセクション名を `expression_governance_rules.md` と区別できる表現に改名
  3. `40_trellis/rules/README.md`（ルール索引）新設、`agent.md` から参照
  4. `farm_evolution_rules.md` §9「ログ記録先 早見表」新設
  5. `farm.config.yaml` 参照済みだが実体不在だった `90_weather/` 配下の雛形 4 件を作成
- reason: Farm Core 自己批判レビュー（ゼロベース整合性監査）で、思想や設計判断に踏み込まない範囲の「明確な不整合」として確認された 5 件。利用者・AI 双方が混乱する原因になっていた。
- affected_files:
  - 削除: `40_trellis/rules/propagation_rules.md`
  - 変更: `40_trellis/rules/artifact_rules.md`, `agent.md`, `40_trellis/rules/farm_evolution_rules.md`
  - 新設: `40_trellis/rules/README.md`, `90_weather/farm_backlog.md`, `90_weather/decision_log.md`, `90_weather/farm_reviews/.gitkeep`, `90_weather/ai_work_logs/.gitkeep`
- related_log_ids: fb-011（`FARM_CORE_FEEDBACK.md`）

## 2026-05-24 / DEC-2026-05-24-02

- type: rule_change / template_addition
- subject: investor_deck テンプレート実体化とプロンプト簡略化（P0-1 対応）
- decision: generate_investor_deck.md のフローを「context_pack 廃止・slide_specs と generated を slides.md に統合」した 3 ステップに整理。同時に templates/investor_deck/ に deck_brief / slide_map の雛形を追加。
- reason: templates/investor_deck/ のテンプレートが全て未投入の状態では generate プロンプトが参照するファイルが存在せず、フローが完全に動かなかった。context_pack は現代 LLM のコンテキスト長では不要な中間工程と判断（監査エージェントの指摘 P1-3 / P2-5）。
- affected_files:
  - 新設: `40_trellis/templates/investor_deck/deck_brief.template.md`
  - 新設: `40_trellis/templates/investor_deck/slide_map.template.yaml`
  - 更新: `40_trellis/templates/investor_deck/README.md`（「未投入」状態を解消）
  - 更新: `40_trellis/prompts/generate_investor_deck.md`（必読 17 → 10、context_pack 廃止、フロー 3 ステップ化）
- related_log_ids: fb-011（`FARM_CORE_FEEDBACK.md`）

