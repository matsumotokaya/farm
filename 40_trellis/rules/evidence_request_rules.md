# Evidence Request Rules

> 支柱 (trellis)：AI が成果物を生成・レビューする過程で、「不足している説得材料（数値・出典・事例）」を
> **能動的にリクエスト化** するためのルール。
>
> Farm における `missing_info.md`（不足検出）と本ルールの `evidence_request_queue.md`（取りに行く説得材料）は
> 役割が異なる。両者の混同は Farm を「あるもので作るだけの静的な資料置き場」に退化させるため、
> 本ルールで明示的に分離する。

---

## 1. なぜ Evidence Request Queue が必要か

`missing_info.md` は「現状の soil で埋まらない項目」を検出する仕組みである。
一方、実際の資料作成では、**「伝えたい仮説・説得ロジックがまずあり、それを支えるために必要なデータを取りに行く」** ことが本筋になる。

- `missing_info.md` の発想：「足りないから書けません」
- `evidence_request_queue.md` の発想：「この主張を通すには、これを取りに行けば資料が一段強くなる」

両者の役割分担：

| ファイル | 役割 | 主な対象 |
| :--- | :--- | :--- |
| `missing_info.md` | 不足情報の一覧。生成を止める／推測で埋めない判断材料 | soil に存在しないが、生成上どうしても必要な事実 |
| `evidence_request_queue.md` | 取りに行くべき説得材料のキュー。資料の説得力を上げる能動的リサーチ要求 | 既存 soil にはないが、見つかれば論旨を大幅に強化できる外部データ |

---

## 2. claim maturity（主張の成熟度）

`00_soil/claims/claim_registry.yaml` に登録される各 claim、および生成過程で扱う主張は、
以下のいずれかの maturity を持つ。

| maturity | 意味 | 外部提出での扱い |
| :--- | :--- | :--- |
| `validated` | 一次出典が確認済みで、数値・主張共に検証済み | そのまま外部提出可 |
| `source_pending` | 仮の数値・主張で書いてあるが、出典未確認。Evidence Request の対象 | **内部ドラフトのみ可**。外部提出前に validated へ昇格、または appendix / source note に分離 |
| `desired` | まだ手元にない数値・事例。あれば資料を一段強化できる | 外部提出には出さない。リサーチタスク化 |
| `rejected` | 一度検討したが、根拠が薄い／論旨に合わない／信頼できる出典がないと判断 | 出さない。なぜ落としたかの記録を残す |

各 claim が `validated / source_pending / desired / rejected` のいずれかを必ず持つこと。

### 2.1 claim_registry.yaml への記述例

```yaml
claims:
  - claim_id: CL-2026-001
    text: <主張本文>
    maturity: source_pending      # validated / source_pending / desired / rejected
    source: <出典 or null>
    confidence: <low / medium / high>
    requested_evidence_id: ER-2026-014   # 対応する evidence request（あれば）
```

---

## 3. Evidence Request Queue の運用

### 3.1 生成タイミング

以下のいずれかのタイミングで、`70_grading/<artifact>/<version>_review/evidence_request_queue.md` を作成または更新する。

- 成果物レビュー時（Inspector の必須出力）
- 生成中に「この主張を通すにはこの数字が欲しい」と AI が気づいた時点
- 出荷前チェック（80_market への配置前）

### 3.2 Inspector の責務

AI が成果物をレビューする際、以下を **proactive** に列挙すること：

- この主張は、どの数値・事例があればさらに強くなるか
- 既存 soil にない外部データで、見つけられれば資料の説得力を大幅に上げるもの
- `source_pending` のまま外部提出されようとしている主張

「指摘されたから書く」ではなく、Inspector の能動的な仕事として扱う。

### 3.3 テンプレート

`40_trellis/templates/artifact_common/evidence_request_queue.template.md` を
`70_grading/<artifact>/<version>_review/evidence_request_queue.md` にコピーして使う。

---

## 4. source_pending の外部提出時の扱い

`source_pending` の数値・主張は、以下のいずれかを満たすまで外部提出版（`80_market/`）に残さない：

1. **昇格**：一次出典を取得し `validated` に昇格させる
2. **分離**：本文からは外し、appendix / source note セクションに「出典確認中」として分離する
3. **削除**：論旨上不要と判断し、本文から落とす

artifact_manifest.yaml には、`source_pending` 由来の表現が残っているか否かを必ず記録する。

---

## 5. missing_info との関係

- `missing_info.md` に書くべきもの：**soil に存在しないが、その artifact を進めるために必要な事実**
  （例：当社の現在の従業員数、製品の現在の価格）
- `evidence_request_queue.md` に書くべきもの：**外部に取りに行けば説得力が上がるデータ**
  （例：業界統計、第三者調査、競合事例の数字）

両者が重複する場合（社内事実が外部にも存在する等）は、`missing_info.md` 側を一次置き場とし、
`evidence_request_queue.md` から `missing_info.md` への参照を残す。

---

## 6. 出荷ゲート

`80_market/` に出荷する前に、必ず以下を確認すること（Before Publishing チェックに含む）：

- `evidence_request_queue.md` の `source_pending` 起源の主張が本文に残っていないか
- 残っている場合、appendix への分離 / 削除 / validated 昇格 のいずれかが完了しているか
- 完了が済んでいない `source_pending` 主張が本文に残ったまま出荷されようとしている場合、Inspector は **block 判定** を出す
