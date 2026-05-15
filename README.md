# Farm

Farm(ファーム)は、AIエージェントによるコンテンツ開発を行うための環境設計フレームワークです。

生成AIによる成果物は、文脈・素材・制約・フィードバックによってコントロールされるため、本質的に、工業製品というよりは農作物や畜産物に近い声質を持ちます。

人間の役割は、成果物を毎回ゼロから手作りすることではなく、良い成果物を生むための環境エンジニアリングを行うことです。

このリポジトリでは、事業計画、プロダクト構想、投資家資料、営業資料、LP、マニュアル、動画などを、ひとつの栽培システムのアナロジーとして管理します。

---

## 基本原則

1. AI に命令するのではなく、条件を栽培する
2. AI の出力は完成品ではなく、収穫物である
3. プロンプトは命令文ではなく、成長方向を決める支柱である
4. コンテキストは土壌である。土壌が痩せていれば、成果物も痩せる
5. ドラフトは失敗ではなく作物である
6. ボツ案は廃棄物ではなく堆肥である
7. 人間は AI の操作者ではなく、栽培者である
8. プロジェクトは一回で完成しない。出荷・反応・改良を季節として回す

---

## Farm Core と Farm Instance

Farm は、フレームワーク本体である `Farm Core` と、個別プロジェクトで運用される `Farm Instance` に分かれる。

- `Farm Core`：ディレクトリ構成、運用ルール、テンプレート、プロンプト、スキーマを管理する
- `Farm Instance`：実際の事業、プロダクト、小説、資料制作などの個別プロジェクトを管理する

新しい事業や小説など、土壌・素材・成果物の目的が大きく異なる場合は、新しい Farm Instance を作成する。

例：

- `farm-your-business`
- `farm-your-product`
- `farm-your-novel`

Farm Coreには実プロジェクトの機密情報や素材を入れず、各Farm Instanceに実データを置く。

### Core に置くもの / Instance に置くもの

| 領域 | Core | Instance |
| --- | --- | --- |
| ディレクトリ構成（4層） | ✅ | （継承） |
| 運用ルール `40_trellis/rules/` | ✅ | （継承・必要に応じ上書き） |
| 汎用プロンプト・テンプレート `40_trellis/prompts/`, `40_trellis/templates/` | ✅（雛形） | 個別差し替え可 |
| `farm.config.yaml` / `glossary.yaml` | ✅（プレースホルダ） | ✅（実値で埋める） |
| `agent.md` | ✅ | （継承） |
| 実データ `00_soil/`, `10_seeds/`, `20_seedbank/` | ❌ | ✅ |
| 生成物 `50_greenhouse/` 〜 `99_compost/` | ❌ | ✅ |

Core リポジトリには `.gitkeep` のみで空のディレクトリ骨格を置く。事業情報や素材、生成物は一切コミットしない。

---

## クイックスタート：Farm Instance を作る

新しい事業・プロダクト・小説などを始めるときは、Farm Core をクローンして Instance 化します。

### 1. クローンしてリネーム

```bash
# Core を取得（履歴は引き継がない）
git clone --depth 1 git@github.com:matsumotokaya/farm.git farm-<your-name>
cd farm-<your-name>

# Core への参照を切り離し、自分の履歴に切り替える
rm -rf .git
git init
git add .
git commit -m "Initialize farm instance from farm-core"
```

`<your-name>` は対象事業・作品の slug にします（例：`farm-your-business`, `farm-your-product`, `farm-your-novel`）。

### 2. 設定を埋める

[farm.config.yaml](farm.config.yaml) のプレースホルダ `<...>` を実値に置き換える。最低限：

- `farm.name`（この Instance の識別名）
- `farm.created`（作成日）
- `focus.business` / `focus.product` / `focus.artifact`（今期の主対象）
- `businesses[]`（取り扱う事業の id・soil_path・product_ids）
- `artifacts.*.status`（実際に作るものを `planned` から `active` に変更）

### 3. 語彙を登録

[glossary.yaml](glossary.yaml) の `Instance 用語` セクションに、事業名・プロダクト名・固有名詞・禁止表現を追加する。
ここを最初に整備しないと、AI 生成物で表記揺れが必ず発生する。

### 4. Soil の最小集合を用意

`00_soil/` に最低限の正規情報を置く。空のまま生成を始めると AI は推測で埋め始める。
成果物の種類によって必要な soil は異なる（後述の「ユースケース別 Soil の最小構成」を参照）。

### 5. AI への最初の指示

新しいセッションで AI（Claude / Cursor / Gemini など）に [agent.md](agent.md) を読ませる。
これ以降 AI は「ファーム長（Orchestrator）」として振る舞い、[40_trellis/rules/](40_trellis/rules/) のルールに従う。

### 6. Core からの更新を取り込みたい場合

Core 側で改善があったときに取り込みたい場合は、Core を upstream として追加する：

```bash
git remote add core git@github.com:matsumotokaya/farm.git
git fetch core
# 必要な変更だけ cherry-pick する。merge は Instance の実データと衝突しやすいので避ける。
git cherry-pick <commit-hash>
```

Core を fork して使う運用も可。その場合は GitHub の private fork を推奨（Instance は機密を含む）。

---

## ディレクトリ構成（MVP）

**人間の基本操作（役割）**
原則として、人間は上から順番にフォルダを確認・管理するわけではありません。人間の役割は「環境設定」と「収穫の評価」です。
主な操作は **`10_seeds/inbox` に素材を投げ込むこと** と、**`60_harvest` や `80_market` に出来上がった成果物を評価（フィードバック）すること** に集約されます。

これを踏まえ、ディレクトリは大きく4つの層（役割）に分かれています。

### 1. FOUNDATION（前提・地盤）
AIが最も信頼すべき、プロジェクトの確定した正規情報です。
| パス | 役割 |
| --- | --- |
| `00_soil/` | 土壌：正規情報（事業、プロダクト、市場、ブランド、主張） |

### 2. INPUTS（素材の入力）
人間が新しい素材を投げ込んだり、AIが使えるように一時保管する場所です。
| パス | 役割 |
| --- | --- |
| `10_seeds/` | 種：未整理素材の置き場（スクショ、メモ、参考等）。**人間の主なインプット口**。 |
| `20_seedbank/` | 種子庫：再利用可能な選別済み素材 |

### 3. PROCESS（AIの作業場）
AIが成果物を生成するためのプロセス領域です。
| パス | 役割 |
| --- | --- |
| `30_nursery/` | 苗床：未成熟なドラフト・アイデア |
| `40_trellis/` | 支柱：テンプレート、プロンプト、運用ルール |
| `50_greenhouse/` | 温室：AI が生成作業を行う場所 |

### 4. OUTPUTS & FEEDBACK（収穫と評価）
出来上がった成果物を確認し、フィードバックを与え、アーカイブする層です。
| パス | 役割 |
| --- | --- |
| `60_harvest/` | 収穫：AI が生成したまとまった成果物。**人間の主な評価対象**。 |
| `70_grading/` | 選果：レビューと編集記録 |
| `80_market/` | 出荷：公開・提出・配布した確定版 |
| `90_weather/` | 天候記録：外部反応、意思決定、フィードバック |
| `99_compost/` | 堆肥：ボツ案、失敗生成物、旧版（生成時には参照しない） |

ファイル名は実務的に（lower_snake_case）、フォルダ名は農業メタファーで統一する。

---

## 情報のライフサイクル

farm 内の情報は、常に以下のライフサイクルを持ちます。

1. `raw`：未整理。とりあえず入れた素材
2. `indexed`：最低限の説明・タグ・出典が付与された状態
3. `candidate`：再利用候補として選別された状態
4. `canonical`：正規情報として成果物生成に使ってよい状態
5. `generated`：AI によって生成されたドラフト
6. `reviewed`：人間が確認・編集した状態
7. `published`：実際に提出・公開・配布した状態
8. `deprecated`：古くなったが、履歴として残す状態
9. `composted`：直接は使わないが、将来の参考・肥料として残す状態

**⚠️ 重要ルール**
AI が成果物生成に使ってよい情報は、原則として `canonical`、`reviewed`、`published` のいずれかとする。`raw` や `candidate` を使う場合は、必ず未確定情報として扱う。

---

## 正規情報への昇格ルール

`10_seeds/` や `20_seedbank/` の情報は、自動的に `00_soil/` の正規情報にはなりません。
正規情報として扱うには、以下のいずれかを満たす必要があります。

- 事業方針として採用された
- プロダクト仕様として採用された
- 投資家資料・営業資料・LPなどで継続的に使うと判断された
- 根拠・出典・利用条件が確認された
- 古い情報との矛盾が解消された

昇格時には、必要に応じて「どの素材から昇格したか」「なぜ正規情報にしたか」「未確定部分は何か」「将来見直すタイミング」を記録します。これがないと、`00_soil` が古い仮説の残る“偉そうなゴミ箱”になってしまいます。

---

## AI の参照優先順位

AI が成果物を生成・レビューする際は、AI自身が「どの情報を信じればいいか」を見失わないよう、以下の優先順位で情報を参照します。

1. `00_soil/`：正規情報
2. `80_market/`：過去に公開・提出された出荷版
3. `70_grading/`：レビュー済みの編集記録
4. `20_seedbank/`：再利用可能な選別済み素材
5. `90_weather/`：外部反応、意思決定、学び
6. `60_harvest/`：AI生成初稿
7. `30_nursery/`：未成熟なドラフト・アイデア
8. `10_seeds/`：未整理素材
9. `99_compost/`：直接利用しない参考情報

**⚠️ 検索汚染防止ルール**
`99_compost/` の情報は、古い情報が本番に復活する事故を防ぐため「原則、生成時には参照しない。再発掘するときだけ見る」ものとします。

---

## マニフェストとソースマップ

成果物が「何を根拠に作られたか」を後から追えるよう、以下の管理ファイルを用います。

### 各成果物のマニフェスト (`artifact_manifest.yaml`)
`80_market/` に入れる出荷版には、必ずマニフェストを置きます。これにより「これは何を根拠に作った資料なのか」「誰に出した版か」「既知の課題（未確定部分）は何か」を明確にします。

### ソースマップ (`source_map.yaml`)
価格、機能、主張など、複数の資料に使われる正規情報が「どの成果物で使われているか」を管理します。価格や仕様を変更した際、どの資料を更新すべきか、どの資料に矛盾が出るかを可視化します。

---

## 定期メンテナンス

farm は放置すると情報が腐敗し破綻します。そのため、以下の定期メンテナンスを行います。

### Weekly
- `10_seeds/inbox/` の新規素材を確認・索引化する
- 使える素材を `20_seedbank/` に昇格し、不要素材を `99_compost/` に移す
- `90_weather/farm_backlog.md` を確認する

### Monthly
- `00_soil/` の正規情報を見直す（古い仮説、古い価格の更新）
- `80_market/` の公開版と現在の正規情報の差分を確認する
- `source_map.yaml` を更新する

### Before Publishing（出荷前）
- `claim_registry.yaml` や禁止表現を確認する
- 未実装機能を現在形で書いていないか、出典のない数字がないか確認する
- `artifact_manifest.yaml` を作成する

---

## アンチパターン（破綻の予防接種）

farm は、以下の状態になると機能しなくなります。

1. `10_seeds/` に素材を入れるだけで、索引化しない
2. `00_soil/` に未確定情報を入れすぎる
3. 古い情報を `deprecated` にせず、正規情報として残し続ける
4. AI生成物をレビューせずに `80_market/` に入れる
5. 出荷版の根拠ファイル（マニフェスト）を記録しない
6. ボツ案と正規情報が混ざる
7. フォルダは増えるが、昇格・降格ルールがない
8. READMEだけ立派で、日常運用の摩擦が大きすぎる

---

## ユースケース別 Soil の最小構成

`00_soil/` に何を置けば AI が「推測で埋める」状態を避けられるかは、作る成果物によって変わります。Farm Core が想定する代表的な構成を示します。

### A. 新規事業の事業計画 / 投資家資料

| パス | 中身 |
| --- | --- |
| `00_soil/business/positioning.md` | 事業のポジショニング、何屋か、なぜ今か |
| `00_soil/business/investor_story.md` | 投資家に語る物語の骨格（課題→洞察→解→規模） |
| `00_soil/business/business_model.md` | 収益モデル、ユニットエコノミクス、価格仮説 |
| `00_soil/product/<product>.md` | プロダクトの仕様（一行で言える形） |
| `00_soil/product/feature_catalog.yaml` | 機能の正規一覧（命名揺れ防止） |
| `00_soil/product/known_limitations.md` | 既知の制約・未実装機能（伏せない） |
| `00_soil/market/market_hypothesis.md` | 想定市場、TAM/SAM/SOM の仮説と根拠 |
| `00_soil/market/evidence_sources.yaml` | 引用した統計・調査の出典 |
| `00_soil/brand/messaging_rules.yaml` | トーン、言ってよいこと/だめなこと |
| `00_soil/brand/prohibited_expressions.yaml` | 禁止表現（`severity: block / warn`） |
| `00_soil/claims/claim_registry.yaml` | 数値・効果主張と根拠の台帳（`claim_id` 必須） |

これらが揃ってから [40_trellis/prompts/generate_investor_deck.md](40_trellis/prompts/generate_investor_deck.md) を AI に渡す。未整備の項目がある場合、AI は推測で進めず `50_greenhouse/<artifact>/missing_info.md` に列挙して停止する（[40_trellis/rules/artifact_rules.md](40_trellis/rules/artifact_rules.md) §7）。

---

## 投資家資料を作るときの流れ（運用例）

新規事業の事業計画書・投資家資料を Farm で作る典型的な流れ。

1. `10_seeds/inbox/` に素材を入れる（メモ、参考スライド、調査結果のスクショ、対話ログ等）
2. `10_seeds/seed_index.yaml` で索引化する（タグ・出典・一行説明を付与＝`raw → indexed`）
3. 使える素材を `20_seedbank/` に昇格する（`indexed → candidate`）
4. 正規情報として固めたいものを `00_soil/` に昇格する（`candidate → canonical`、昇格理由とタイムスタンプを記録）
5. [40_trellis/prompts/generate_investor_deck.md](40_trellis/prompts/generate_investor_deck.md) と [40_trellis/templates/investor_deck/](40_trellis/templates/investor_deck/) を使う
6. `50_greenhouse/investor_deck/` で生成（`deck_brief.md` → `context_pack.md` → `slide_map.yaml` → `slide_specs/` → `generated/`）
7. `60_harvest/investor_deck/v00X/` に初稿を保存する（`generated`）
8. [40_trellis/prompts/review_investor_deck.md](40_trellis/prompts/review_investor_deck.md) を使い `70_grading/investor_deck/v00X_review/` でレビュー（`reviewed`）
9. `80_market/investor_deck/YYYY-MM-DD_<slug>/` に出荷版と `artifact_manifest.yaml` を保存する（`published`）
10. `90_weather/` に投資家の反応・質問・学びを記録する
11. 古い版・ボツ案は `99_compost/` に移す（`composted`）

**ポイント**：1回で完成版を狙わない。`v001` の収穫を投資家にぶつけ、`90_weather/` で得た反応を `00_soil/` に還元してから `v002` を栽培する。これが「季節を回す」運用。

---

## ファーム自体を更新するときの流れ

farm 自体も成果物です。資料を作る過程で見つかった運用上の課題、置き場所の迷い、レビュー観点の不足は、会話で流さず管理します。

1. 気づきや違和感を `90_weather/farm_reviews/` に記録する
2. 改善候補を `90_weather/farm_backlog.md` に追加する
3. 採用する運用ルールを `40_trellis/rules/` に反映する
4. 正規の運用モデルになったものを `00_soil/farm/` に反映する
5. 入口として必要な内容だけ README に戻す

---

## AIエージェントとの連携（マルチエージェント・オーケストレーション）

farmは単一のAIプロンプトで全てを処理するのではなく、イベント駆動型のマルチエージェントシステムとして動作します。AIがコンテキスト限界に陥らないよう、全体を指揮する「オーケストレーター」と、局所的な作業を行う「サブエージェント」を組み合わせて運用します。

- プロジェクト直下の `agent.md` が、AIに対する一番最初のシステム指示（エントリーポイント）となります。
- AIエージェントの具体的な振る舞いやルール定義は `40_trellis/rules/agent_orchestration_rules.md` に記載されています。

---

## 設定ファイル

- `farm.config.yaml`：farm 全体の設定（対象事業、対象成果物、運用ルール）
- `glossary.yaml`：用語集（事業固有の言い回し、固有名詞、禁止表現の参照）
