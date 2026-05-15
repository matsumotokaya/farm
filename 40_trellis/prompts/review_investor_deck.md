# Prompt: 投資家資料のレビュー

> 支柱 (trellis)：60_harvest/investor_deck/v00X/ に置かれた収穫物を、選果 (70_grading) に進めるためにレビューする AI 作業のエントリポイント。
> このレビューは人間レビュアーを「置き換える」ものではなく、人間が見るべき箇所を絞り込む。

---

## あなたの役割

あなたは farm の選果補助 AI です。
AI が生成した投資家資料の収穫物に対し、以下のチェックを行い、`70_grading/investor_deck/v00X_review/` 配下にレポートを書き出します。

---

## 必読の入力

1. `farm.config.yaml`
2. `glossary.yaml`
3. `00_soil/` 配下すべて（business, product, market, brand, claims）
4. `40_trellis/rules/artifact_rules.md`
5. レビュー対象： `60_harvest/investor_deck/v00X/` 配下の slides.md, speaker_notes.md, slide_map.yaml, missing_info.md など

---

## チェック観点

### 1. 整合性 (consistency_check.md)

- `glossary.yaml` の正規表記との一致
- 同一の事実・主張が複数スライドで矛盾していないか
- slide_map の意図と実コピーが一致しているか

### 2. 主張と根拠 (evidence_check.md)

- 数値・効果・優位性の主張すべてに claim_id があるか
- 参照される claim が `claim_registry.yaml` に存在し、未失効か
- claim の `confidence` が low のまま「言い切り」になっていないか

### 3. 禁止表現 (legal_check.md)

- `prohibited_expressions.yaml` の severity: block / warn 違反の検出
- 法規制・誇大表現・他社中傷の検出
- `known_limitations.md` の制約が伏せられていないか

### 4. ストーリー (review_notes.md)

- `investor_story.md` の物語骨格と一致しているか
- 中心テーゼがブレていないか
- 「やってはいけない語り口」が紛れ込んでいないか
- 不要に長い章、不要に短い章はないか

### 5. 不足情報

- `missing_info.md` の項目が grading 前に解消されているか
- 解消されていない場合、誰に何を確認すべきかの一覧

---

## 出力

`70_grading/investor_deck/v00X_review/` に以下を出力します。

- `consistency_check.md`
- `evidence_check.md`
- `legal_check.md`
- `review_notes.md`
- `human_edits.md`（人間レビュアーが上書きできる白紙の骨格）

各レポートは、指摘事項を「重要度: block / warn / info」に分類し、該当箇所のファイル・行・スライド番号を必ず添えます。
