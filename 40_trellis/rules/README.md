# Trellis Rules（ルール索引）

> 支柱 (trellis)：Farm の運用ルール群。AI エージェントはここを起点に必要なルールへたどり着く。
> 各ルールは独立に読めるが、適用場面が重なる箇所は本索引で交通整理する。

## 必読の優先順位

AI エージェントが起動直後に必ず読むのは以下 3 つ（`agent.md` の指示）。

1. `00_soil/farm/operating_model.md`（動作モデル）
2. `agent_orchestration_rules.md`（役割分担とイベント駆動フロー）
3. `layer_protocol_rules.md`（層間プロトコル：sources.yaml / soil_changelog / 参照モード）

残りは「該当する作業に入ったときに参照する」運用。下表の「適用タイミング」を参照。

---

## ルール一覧

| ルールファイル | 守備範囲 | 関連ファイル | 適用タイミング |
| :--- | :--- | :--- | :--- |
| `agent_orchestration_rules.md` | 役割定義（Orchestrator / Cultivator / Inspector 等）、イベント駆動フロー、サブエージェント間連携 | `agent.md`, `layer_protocol_rules.md` | 起動時必読。タスク分担を判断するたび参照 |
| `layer_protocol_rules.md` | sources.yaml の自己申告仕様、soil_changelog の書式、exact vs canonical latest 参照モード | `00_soil/`, `60_harvest/`, `current.yaml`, `90_weather/soil_changelog.md` | 起動時必読。生成・版昇格・参照を書くたび |
| `artifact_rules.md` | 任意 artifact の生成前後ルール（出所原則、外部公開表現チェック、Soil Readiness Gate、版昇格チェック等）。事業系・論述系には §1.1 の追加ルールが適用される | `glossary.yaml`, `prohibited_expressions.yaml`, `claim_registry.yaml`（事業系のみ） | 成果物を生成・レビュー・昇格させる前に必読 |
| `evidence_request_rules.md` | 検証可能な主張を含む artifact（事業系・論述系）向け：説得材料を能動的に取りに行くキュー運用、claim maturity 管理 | `claim_registry.yaml`, `evidence_request_queue.template.md`, `missing_info.md` | 事業系 artifact の Inspector レビュー時・出荷前チェック時 |
| `expression_governance_rules.md` | **内部統制**：ルール文・ログ・本文への対象語の混入防止（grep ベースの物理削除型統制） | `guardrails.md`, `decision_log.md` | 「特定の語を全プロジェクトから消したい」と判断したとき |
| `design_handoff_rules.md` | スライド型成果物のデザイン工程への引き継ぎ規則（slide_markdown フォーマット） | `templates/slide_markdown.md` | スライド形式の成果物を生成するとき |
| `farm_evolution_rules.md` | Farm 自体の改善ライフサイクル、暫定情報の扱い、ログ記録先の振り分け表 | `farm_reviews/`, `farm_backlog.md`, `decision_log.md`, `FARM_CORE_FEEDBACK.md` | Farm の構造・ルール・分類を変えるとき |

---

## 守備範囲が紛らわしいペア

混同しがちな組み合わせを明示する。

### 表現の統制（外部 vs 内部）

| 対象 | 担当ルール |
| :--- | :--- |
| **外部公開資料の本文に出していい表現か**（誇大表現・法規リスク） | `artifact_rules.md` §2 → `00_soil/brand/prohibited_expressions.yaml` |
| **ルール文・ログ・内部ドキュメントに対象語を残さない**（AI 再学習防止） | `expression_governance_rules.md` |

両者は「禁止」というキーワードを共有するが、目的・対象・手段が異なる。

### 不足の扱い（受動 vs 能動）

| 性質 | 担当ファイル |
| :--- | :--- |
| **足りないから生成を止める**（受動的検出） | `missing_info.md`（`artifact_rules.md` §7） |
| **取りに行けば資料が一段強くなる**（能動的リサーチ要求） | `evidence_request_queue.md`（`evidence_request_rules.md`） |

### ログの記録先

`farm_evolution_rules.md` 末尾の「ログ記録先 早見表」を参照。

---

## このファイルの更新ポリシー

- ルールファイルを追加・削除・改名したら、本索引も同じコミットで更新する。
- 索引と本体ファイルが乖離した場合、本索引を**正**とせず、本体ファイルを正本として扱う（本索引はあくまでナビゲーション）。
