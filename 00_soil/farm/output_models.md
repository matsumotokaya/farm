# Output Models

このファイルは Farm が生成する成果物（Artifact）の出力形式（Output Model）を定義します。

## slide_markdown

`slide_markdown` は、1つのプレゼン資料を 1つの Markdown ファイルで表現する出力モデルです。
「デザインがまだないスライド」ではなく、「スライドとして成立する内容を Markdown で表現した最終テキスト形態」として扱います。ユーザーまたはデザイナーがこの後に見た目を作る場合、Farm の到達点は `slide_markdown.md` となります。

### 向いている成果物
- 営業資料
- 投資家向け資料
- 事業計画のプレゼン版
- 説明会資料
- 採用資料
- IR資料
- 提案資料

### 配置
`60_harvest/<artifact>/<version>/slide_markdown.md`

### 形式
- 1つのデッキ全体を1ファイルにまとめます。
- 各スライドは `---` で区切ります。
- 各スライドは `## Slide 01: ...` の形式で始めます（タイトルは `Slide 00`）。
- 以下の要素を必ず含めます：
  - `Slide Text`: スライド上に載せる確定文言
  - `Image Request`: GPT Image 等、画像生成・デザイン制作に渡せる1ページ分の依頼文
  - `Visual Direction`: 構図、図解、レイアウト、強調箇所
  - `Grounding`: 参照元、claim_refs、seedbank_refs、暫定条件
  - `Prohibited`: 描画上・営業上の禁止事項
