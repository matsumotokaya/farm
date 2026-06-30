# 成果物ルール (artifact_rules.md)

> 支柱 (trellis)：AI が任意の成果物を生成する前後に必ず従うルール群。
> 各成果物固有のルールはこのファイルを継承して上書きする。

## 1. 情報の出所原則

- 用語と固有名詞は `glossary.yaml` の正規表記に従う。
- プロジェクト内で繰り返し使うコピー・フレーズ・定型表現は、`00_soil/` に正規定義があればそこから再利用・調整する。毎回新規発明すると表現が揺れる。
- `00_soil/` に正規定義のあるテキストを変更した場合は、各ファイル末尾の `change_log` への追記と `90_weather/soil_changelog.md` への Log ID 記録を必須とする。
- 正規定義の対象ファイルが存在しない、または必要項目が未記入なら、AI は推測で埋めず `missing_info.md` に不足として列挙する。

### 1.1 検証可能な主張を含む artifact（事業系・論述系）の追加ルール

> 数値・効果・優位性・市場規模などの「主張」を含む artifact（事業計画、投資家資料、論文、記事等）にのみ適用する。
> 小説・詩・脚本など、主張の検証が目的でない artifact には適用しない。

- 検証可能な主張は、`00_soil/claims/claim_registry.yaml` の `claim_id` を伴うこと。
- 各 claim は `maturity: validated / source_pending / desired / rejected` のいずれかを必ず持つ（詳細は `40_trellis/rules/evidence_request_rules.md` §2）。
- `source_pending` / `desired` の主張は内部ドラフトでは使ってよいが、外部提出版（`80_market/`）の本文には残さない。
- claim_id を持たない主張は出力に含めない。代わりに「未検証」と書くか、出力から外す。
- 想定される読者の懸念・誤解とその切り返しロジックが `00_soil/objections/` に存在する場合は参照し、先回りした構成を盛り込む。

## 2. 外部公開資料の表現チェック（誇大表現・法規リスク）

> 本セクションは **外部公開資料の本文に出力してよい表現か** を扱う。
> 「ルール文・ログ・内部ドキュメントに対象語を残さない」内部統制は
> `40_trellis/rules/expression_governance_rules.md` を参照（守備範囲が異なる）。

- `00_soil/brand/prohibited_expressions.yaml` の `severity: block` 項目は絶対に出さない。
- `severity: warn` は使ってよいが、人間レビュー時に確認対象として明示する。
- ルール文や guardrails に「『X』を使わない」型の記述を新しく書かないこと
  （AI への抑止として効かず、対象語の再混入を招く）。表現を止めたい場合は、
  ルール記述ではなく対象語のプロジェクト全体からの物理削除・置換で対応する
  （詳細は `expression_governance_rules.md`）。

## 2.5 動的参照データの扱い

- `00_soil/` 配下に「正規のコピー・フレーズ・定型表現」が定義されている場合、AI は同じ役割の表現を新規発明せず、まずそこから再利用・調整する。
- 暫定・未確定の情報（価格、仕様、条件など）が Soil に含まれる場合、AI はそれを確定事項のように断定しない。
- 必要な Soil ファイルが存在しない、または必要項目が未記入なら、AI は推測で埋めず `missing_info.md` に不足として列挙する。

## 3. 既知の制約の扱い

- `00_soil/` に既知の制約・スコープ外事項が定義されている場合、それを「隠して」魅力的に語ることは禁止。
- 成果物の種類と読者に応じた適切な深さで言及する（どこに・どのくらい書くかは artifact ごとのプロンプトで定義する）。

## 4. 再利用優先原則

- 同じ表現や図解を二度発明しない。
- 生成前に `20_seedbank/asset_index.yaml` を確認し、使える素材があれば再利用する。
- 再利用した場合は、出力中に `seedbank_ref: <asset_id>` を残す（後段の grading で検証可能にする）。

## 5. 出力経路の原則

- AI が直接書いてよいのは `50_greenhouse/` まで。
- `60_harvest/` への移動は、版番号 (`v001` 等) を付与してから。
- `70_grading/` 以降は人間が主導する。AI は提案にとどまる。
- `80_market/` は出荷スナップショット。生成後の自動上書き禁止。

## 6. ログ原則

- 生成作業を行ったら `90_weather/ai_work_logs/` に作業ログを残す。
  - 入力：使用した soil / seedbank / prompt のリスト
  - 出力：作られたファイルのリスト
  - 判断：迷った点、選んだ選択肢、捨てた選択肢
- 重要な意思決定は `90_weather/decision_log.md` にも記録する。

## 7. 不明点 STOP 原則

- 必要な情報が `00_soil/` にない場合、AI は推測で埋めない。
- `50_greenhouse/<artifact>/missing_info.md` を作成し、人間に問い合わせる項目を列挙する。

## 8. 命名原則

- バージョンは `v001`, `v002` の 3 桁ゼロ埋め。
- 出荷ディレクトリは `YYYY-MM-DD_<slug>` 形式。
- ファイル名は実務的に lower_snake_case。

## 9. Soil Readiness Gate（生成開始前の必須判定）

新規 artifact の生成、full rewrite、メジャー版上げを開始する前に、
**現在の `00_soil/` でその成果物が責任をもって作れるか** を判定する Gate を必ず通すこと。

### 9.1 手順

1. `40_trellis/templates/artifact_common/soil_readiness_audit.template.md` を
   `70_grading/<artifact>/<version>_review/soil_readiness_audit.md` にコピーする。
2. その artifact の `generate_<artifact>.md` プロンプトの「必読の入力」と照合し、
   必須 soil の充足状況と粒度を埋める。
3. 各 soil を `P0 / P1 / OK` に分類する。
   - **P0**: 欠けていると AI が推測で埋めてしまうため、生成開始を **許可しない**。
   - **P1**: 不足だが、`missing_info.md` で並行解消しながら進めてよい。
4. `verdict: go / hold / block` を記入する。

### 9.2 ゲート判定の意味

- `block`（P0 残あり）：生成を開始しない。soil を埋めるか、人間が「P0 を承知の上で進める」明示承認を出すまで止まる。
- `hold`（P1 のみ）：`missing_info.md` を整備した上で生成可。
- `go`：そのまま生成可。

### 9.3 適用しなくてよいケース

- minor revision（誤字修正、表現微調整のみで、構成・主張・主要コピーを変えない場合）
- 既存版の selective update（特定スライド・段落のみの差し替え）

これらでも、参照する soil に未確定情報がある場合は `missing_info.md` への記載は必須。

## 10. 生成過程の矯正メモを本文へ漏らさない原則

- レビューや会話の中で出てきた「これは中心ではない」「これに寄りすぎないように」
  といった矯正メモ（負の指示）は、**生成された成果物の本文に出してはならない**。
- 具体的には、「<A> ではなく <B>」「<A> を主題にしない」のような否定形矯正文を、
  読者向け本文・スライドコピー・LP のキャッチに残してはならない。
- そのような文が出力されかけた場合、出力前に必ず **<B> の正の定義** に書き換える。
- 「<A> を中心にしない」という運用上の判断は、本文ではなく guardrails 系 soil
  （`00_soil/brand/guardrails.md` 等）と作業ログに記録する。

詳細は `40_trellis/rules/expression_governance_rules.md` を参照。

## 11. 版昇格時の必須チェック（Version Promotion Checklist）

`60_harvest/<artifact>/v00X/` に新版を昇格させたとき、以下のチェックをすべて完了させること。
詳細は `40_trellis/rules/layer_protocol_rules.md` §5 を参照。

1. **current pointer の更新**
   `60_harvest/<artifact>/current.yaml` の `current_version` と `primary_file` を新版に書き換える。

2. **sources.yaml と実ディレクトリ名の整合確認**
   新版ディレクトリ内 `sources.yaml` の `version:` フィールドと実ディレクトリ名（`v00X`）が一致していること。

3. **canonical latest reference 配下の旧版参照の監査**
   prompt / context_pack / deck_brief / README など「最新版追従でよい」ファイルに、旧版番号の版付きパス（例：`v003`）が残っていないか grep で機械的に確認する。残っていた場合は `current.yaml` 経由または無番号パスに書き換える。

4. **exact reference の意図確認**
   旧版番号がどこかに残っていた場合、それが「歴史的事実として固定したい exact reference」か、単なる更新漏れかを判定する。前者なら残してよい、後者なら 3 のとおり書き換える。

5. **soil_changelog への記録は不要**
   版昇格は artifact 側のイベントなので、`soil_changelog.md` ではなく `90_weather/decision_log.md` に記録する。
