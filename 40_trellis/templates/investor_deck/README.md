# 投資家資料テンプレート

`generate_investor_deck.md` プロンプトが参照するテンプレート群。

## 同梱テンプレート

| ファイル | 配置先（Instance 側） | 役割 |
| :--- | :--- | :--- |
| `deck_brief.template.md` | `50_greenhouse/investor_deck/deck_brief.md` | 「この版でどんな資料を作るか」を人間が AI に渡すブリーフ。ターゲット・目的・制約・構成希望を書く。 |
| `slide_map.template.yaml` | `50_greenhouse/investor_deck/slide_map.yaml` | 全スライドの構成・並び・key_message・claim_id の一覧。**人間の構成合意ゲート**（`human_approved: true` になるまで AI は本文生成に進まない）。 |

## 共通テンプレート（別ディレクトリ）

| ファイル | 配置先（Instance 側） | 役割 |
| :--- | :--- | :--- |
| `../slide_markdown.md` | `50_greenhouse/investor_deck/slides.md` | スライド本文の出力フォーマット。Slide Text / Speaker Notes / Image Request / Visual Direction / Grounding / Prohibited の 6 セクション構成。 |
| `../artifact_common/soil_readiness_audit.template.md` | `70_grading/investor_deck/<version>_review/soil_readiness_audit.md` | 生成前 Soil Readiness Gate の監査シート。 |
| `../artifact_common/evidence_request_queue.template.md` | `70_grading/investor_deck/<version>_review/evidence_request_queue.md` | Inspector が生成する「取りに行けば説得力が上がる外部データ」のリクエストキュー。 |
| `../artifact_common/current.yaml` | `60_harvest/investor_deck/current.yaml` | 最新版を canonical latest reference で指すポインタファイル。 |

## 使い方（generate プロンプトとの対応）

1. `deck_brief.template.md` → `50_greenhouse/investor_deck/deck_brief.md` にコピーして埋める
2. AI が `slide_map.template.yaml` を雛形に `slide_map.yaml` を生成 → 人間が確認・承認
3. AI が `slides.md`（`slide_markdown.md` 書式）を生成
4. AI が `missing_info.md` を更新

詳細は `40_trellis/prompts/generate_investor_deck.md` を参照。
