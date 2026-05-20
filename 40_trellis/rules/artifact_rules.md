# 成果物ルール (artifact_rules.md)

> 支柱 (trellis)：AI が任意の成果物を生成する前後に必ず従うルール群。
> 各成果物固有のルールはこのファイルを継承して上書きする。

## 1. 情報の出所原則

- 数値、効果、優位性、市場サイズ等の主張は、必ず `00_soil/claims/claim_registry.yaml` の `claim_id` を伴うこと。
- claim_id を持たない主張は出力に含めない。代わりに「未検証」と書くか、出力から外す。
- 用語と固有名詞は `glossary.yaml` の正規表記に従う。
- タグライン、ワンライナー、短い説明文などのブランドコピーは、`00_soil/brand/key_copy.md` を優先参照する。
- 価格、提供形態、PoC 条件などの商用条件は、`00_soil/business/commercial_offer.md` を優先参照する。
- コンセプトに対する顧客や投資家からの想定懸念・誤解およびその切り返しロジックは、`00_soil/objections/common_objections.md` を優先参照し、先回りして不安を払拭する構成を盛り込むこと。

## 2. 禁止表現原則

- `00_soil/brand/prohibited_expressions.yaml` の `severity: block` 項目は絶対に出さない。
- `severity: warn` は使ってよいが、人間レビュー時に確認対象として明示する。

## 2.5 動的参照データの扱い

- `00_soil/brand/key_copy.md` に確定文言がある場合、AI は同じ役割のコピーを新規発明せず、まずそこから再利用・調整する。
- `00_soil/business/commercial_offer.md` に暫定条件がある場合、AI はそれを確定事項のように断定しない。
- 上記ファイルが存在しない、または必要項目が未記入なら、AI は推測で埋めず `missing_info.md` に不足として列挙する。

## 3. 既知の制約の扱い

- `00_soil/product/known_limitations.md` に書かれた制約を「隠して」魅力的に語ることは禁止。
- 成果物の種類に応じて適切な深さで言及する（投資家資料は章末、営業資料は FAQ、LP は誤認しない範囲）。

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
