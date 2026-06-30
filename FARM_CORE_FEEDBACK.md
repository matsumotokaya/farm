# Farm Core Feedback Log

> **このファイルの役割**
> この Farm Instance の運用で気づいた、Farm Core（フレームワーク本体）への改善フィードバックを蓄積する。
> Instance 固有の運用課題ではなく、**次の Instance を作るときに最初から入っていてほしかったもの** を記録する。

> **重要**
> このファイルは蓄積専用であり、どこかへ自動送信されるものではない。
> 必要になったときだけ、人間がこのファイルを配布元や別の Farm へ共有すればよい。

> **蓄積ルール**
> 詳細は `40_trellis/rules/farm_evolution_rules.md` の「ルール 8」を参照。
> - AI・人間を問わず、Farm Core への改善案に気づいたら追記する
> - 送信・反映のタイミングは人間が判断する
> - Farm Instance 固有の運用メモは `90_weather/` 側で扱い、このファイルには混ぜない

---

## ゼロベース監査サマリー（2026-05-24）

> **このセクションの目的**
> 2026-05-24 に実施した Farm Core のゼロベース・批判的レビュー（4 エージェント並列監査）の結果を一覧化。
> **次回セッション開始時に最初に読むこと。** 対応済み・未対応を明示しているので、続きの作業はここから判断する。
>
> 運用中の Farm Instance にも修正を加えたい場合、各問題の「インスタンスへの影響」欄を参照。

### 凡例

| 記号 | 意味 |
| :--- | :--- |
| ✅ | 対応済み（Farm Core 本体に反映） |
| ❌ | 未対応（次の作業対象） |
| ⏸ | 保留・将来拡張（意図的に後回し） |

---

### P0：致命的（初回1時間で詰む）

| # | 問題 | 状態 | 対応内容 / 次のアクション | インスタンスへの影響 |
| :--- | :--- | :---: | :--- | :--- |
| P0-1 | **templates/investor_deck/ が空**。`generate_investor_deck.md` が要求する `slide_map.template.yaml` / `deck_brief.template.md` / `slides.template.md` の実体がゼロ | ✅ | `deck_brief.template.md` / `slide_map.template.yaml` 新設。フロー 3 ステップ化・context_pack 廃止・必読 17→10 に削減（D-10〜D-13） | 投資家資料・営業資料を生成しようとすると、参照先テンプレが存在せず AI が毎回ゼロから構造を発明してしまい再現性ゼロ |
| P0-2 | **00_soil に必須ディレクトリが不在**。`market/`、`product/`、`claims/` ディレクトリ自体が存在しない。generate_investor_deck が要求する 17 ファイルのうち多くが未実体化 | ❌ | `00_soil/market/`、`00_soil/product/`、`00_soil/claims/` のディレクトリと最低限の雛形 md / yaml を Farm Core に同梱する | Instance 側で作業開始時に「土壌を埋めよ」と言われてもどこに何を置けばいいかわからない。.gitignore で無視されるため雛形も残らない |
| P0-3 | **examples/ が存在しない**。初回体験が「ゼロから全 Soil を埋める作業」から始まるため、最初の成果物が出るまでに1〜2日かかる | ❌ | `examples/seed_business/` に架空 SaaS で全 Soil・seed_index・deck_brief を埋めたサンプルセットを同梱する。`generate_investor_deck.md` が即動く状態を作る | 初回ユーザーの離脱率が極めて高い。競合の Gamma/Tome と比べて初速が2桁劣る |
| P0-4 | **Soil Readiness Gate が「正しく動けば動くほど初稿が出ない」構造**。必須 Soil が空の状態では Gate が必ず block を返す。P0-2 が解消されないと永続する | ❌ | P0-2 解消が先決。その上で「Lite モード（Gate なし）で v001 を出してから補完する」逃げ道を artifact_rules §9.3 に追記する | Block 判定の都度、人間が Soil を埋める前処理が発生する。現状は Soil が空なら生成は一切始まらない |

---

### P1：重大（継続使用で詰む / 品質劣化）

| # | 問題 | 状態 | 対応内容 / 次のアクション | インスタンスへの影響 |
| :--- | :--- | :---: | :--- | :--- |
| P1-1 | **思想（分散・最小介入）と実装（中央集権）の真逆**。「中央台帳を廃止した」と謳うが、全 sources.yaml をスキャンして影響範囲を特定するのはオーケストレーターであり機能上は中央集権と同じ。agent.md の「Entry/Exit のみ介入」宣言と agent_orchestration_rules の全フロー主導が矛盾 | ❌ | README / agent.md の建付けを「軽量な中央照合役は不可避」と正直に書き直す。「分散」の本質を「ファイル単位の自律申告（sources.yaml）でスキャン対象を最小化すること」に再定義する | コンセプトとルールの矛盾がそのまま AI の迷走を生む。特にマルチセッションで動作が不安定になる |
| P1-2 | **農業メタファーが認知負荷・SEO・AI 一貫性を破壊**。独自語彙 25 以上（ロール7種・ライフサイクル状態9種・メタファー9種）。ロール名が日英混在（Cultivator / 栽培担当）で LLM の自己参照が毎回揺れる。`grep "draft"` `grep "output"` `grep "review"` がヒットしない | ❌ | 即効策：ロール名を英語1種に統一（`agent_orchestration_rules.md` 内の日本語ロール名を括弧注釈に降格）。中長期：ディレクトリ名の実用名への移行を検討（ブランド判断が必要） | Instance で複数セッションにわたって作業すると、AI が「Cultivator」「栽培担当」「Cultivator（栽培担当）」で揺れ、ロールが不安定になる。Soil Keeper / Inspector など高頻度に出るロールで顕著 |
| P1-3 | **プロトコル過剰で「価値を生む前に儀式で疲弊」**。必読 17 ファイル、生成後に更新必須のメタファイル 7 種（sources.yaml / current.yaml / soil_changelog / decision_log / ai_work_logs / missing_info / evidence_request_queue / artifact_manifest）。README L308「日常運用の摩擦が大きすぎる」をアンチパターンと自認しているのに Farm 自体がそれを体現 | ❌ | **「必読の入力」を 17 → 7 に削減**（core_message / key_copy / claim_registry / known_limitations / commercial_offer / deck_brief / asset_index に絞り、残りは rules 側で暗黙ロード）。context_pack を廃止（現代 LLM のコンテキスト長なら不要）。slide_specs と generated を統合 | Instance 側で毎回のメタファイル更新コストが高く、sources.yaml や current.yaml が最初の数版でメンテ放棄される |
| P1-4 | **current.yaml が版上げ即日で腐る**。自動更新機構も検査スクリプトもなく、人間・AI の規律依存のみ。layer_protocol §5.5 自身が「将来拡張」と保留 | ⏸ | 20行程度のチェックスクリプト（`90_weather/checks/check_current_pointer.sh`）を Farm Core に同梱。`current.yaml` の指す実ファイルが存在するか / 最大版番号と一致するかを検査 | 版上げのたびに current.yaml を手動更新し忘れ、プロンプトが古い版を正本として参照し続ける |
| P1-5 | **投資家資料以外のユースケースが完全未対応**。farm.config.yaml は sales_deck / lp / flyer / video / manual を planned で列挙するが、対応プロンプト・テンプレ・Soil 構成例がゼロ。README の「ユースケース別 Soil 最小構成」も investor_deck のみ | ❌ | 最低限 B. 営業資料 の `generate_sales_deck.md` と Soil 最小構成を `generate_investor_deck.md` の派生として追加。LP・マニュアルは P2 で対応 | 投資家資料以外を作ろうとしたユーザーが迷子になる。farm.config.yaml の planned 項目に対応する手引きが全くない |
| P1-6 | **claim_registry.yaml のスキーマ正本がない**。`artifact_rules.md` §1 と `evidence_request_rules.md` §2 が `claim_id` / `maturity` / `requested_evidence_id` を要求するが、正規スキーマ定義（`00_soil/claims/` のテンプレ）への参照リンクが両ファイルとも欠落 | ❌ | `00_soil/claims/claim_registry.template.yaml` を Farm Core に追加し、evidence_request_rules.md §2.1 の `claim_registry.yaml` 記述例をそこへのリンクに差し替える | Instance で claim を登録しようとすると「どこに書くか・どのスキーマで書くか」がわからず、毎回 evidence_request_rules を参照する手間が発生する |
| P1-7 | **evidence_request_queue.template.md が使われずに死ぬ**。missing_info.md との役割分担が `evidence_request_rules §5` で「重複したら missing_info を一次置き場に」と曖昧で、実運用では missing_info に集約され空のまま放置される | ❌ | evidence_request_rules §5 の役割分担をより明確に（「外部データ取得依頼は必ず queue に」と断言する）。または両ファイルを「二段構え」ではなく Inspector の必須出力として流れに組み込む | Inspector レビューが missing_info 一本に集約され、「取りに行けば説得力が上がるデータ」の能動的リサーチが行われなくなる |

---

### P2：改善余地（品質・保守性）

| # | 問題 | 状態 | 対応内容 / 次のアクション | インスタンスへの影響 |
| :--- | :--- | :---: | :--- | :--- |
| P2-1 | **design_handoff_rules.md の連携先未指定**。artifact_rules のどこにも「スライド型 artifact は design_handoff_rules を継承する」指示がない。Inspector の評価対象かも不明 | ❌ | artifact_rules §5（出力経路の原則）に「スライド型 artifact は design_handoff_rules.md を必読」と1行追加する | スライド型成果物の生成時に slide_markdown フォーマットが使われない。AI が毎回独自構造で出力する |
| P2-2 | **seed_index.yaml のテンプレ・例がない**。README は「Weekly に索引化せよ」と命じるが、書式テンプレも記入例も存在しない | ❌ | `10_seeds/seed_index.template.yaml` を Farm Core に追加（タグ・出典・一行説明・ライフサイクル状態の書式） | 1ヶ月後に `10_seeds/inbox/` に素材が100個溜まっても索引化が行われず放置される（アンチパターン再現） |
| P2-3 | **PROJECT.md が形骸化する**。起動時1回の会話で埋めてしまうと以降は更新されない。更新トリガーが定義されていない | ❌ | agent.md に「farm.config.yaml の focus または artifacts の status が変わったら PROJECT.md を同時更新する」トリガーを追記 | 複数セッション後、PROJECT.md の current_status が古いまま残り、AI が「どこまで進んでいるか」を誤読する |
| P2-4 | **「初回 30 分ガイド」が存在しない**。README は350行以上あるが「最初の30分で何をすれば初稿に近づくか」を教えるショートカットパスがない | ❌ | README の冒頭か QUICKSTART.md を新設。ステップ0〜3（PROJECT.md 最小入力 → farm.config.yaml の focus 欄だけ埋める → examples/ を使って soil を仮置き → generate プロンプトを実行）を明示 | 新規ユーザーが README の半分も読まないうちに離脱する。「使い方が分からない」という印象で終わる |
| P2-5 | **context_pack.md が LLM の現世代では不要な中間工程**。Deck Brief + Soil 直接参照で代替可能。context_pack のメンテコストがインラインで読むコストを上回る | ❌ | generate_investor_deck.md から context_pack フェーズを削除し、「Deck Brief → slide_map → slides」の 3 ステップに整理 | 毎回 context_pack を生成・維持するコストが生産的な作業時間を圧迫する |
| P2-6 | **sources.yaml / soil_changelog.md の Why 欄が規律依存のみで劣化確実**。自動検査も書式検証もない | ❌ | Why 欄が空の場合に Inspector が警告を出す評価ゲートを review_investor_deck.md に追加する | 数版後に Why が空の soil_changelog エントリが増え、Cultivator が「なぜ変わったか」を推測するしかなくなる |

---

### 対応済み一覧（2026-05-24 実施）

| # | 内容 | 対応ファイル |
| :--- | :--- | :--- |
| ✅ D-1 | `propagation_rules.md` 削除（layer_protocol_rules.md と完全重複・孤児） | `40_trellis/rules/propagation_rules.md` 削除 |
| ✅ D-2 | `artifact_rules.md §2` タイトルを「外部公開資料の表現チェック」に改名し守備範囲分離を明示 | `40_trellis/rules/artifact_rules.md` |
| ✅ D-3 | `40_trellis/rules/README.md`（ルール索引）新設。全 7 ルールの守備範囲・適用タイミング・紛らわしいペア表 | `40_trellis/rules/README.md` 新設 |
| ✅ D-4 | `agent.md §1` にルール索引への参照を追記（他 4 ルールファイルへの入口） | `agent.md` |
| ✅ D-5 | `farm_evolution_rules.md §9`「ログ記録先 早見表」新設（8 種類の記録先の使い分け表と判断順序） | `40_trellis/rules/farm_evolution_rules.md` |
| ✅ D-6 | `90_weather/farm_backlog.md` 雛形新設（書式テンプレ付き） | `90_weather/farm_backlog.md` 新設 |
| ✅ D-7 | `90_weather/decision_log.md` 雛形新設（書式テンプレ付き） | `90_weather/decision_log.md` 新設 |
| ✅ D-8 | `90_weather/farm_reviews/`、`90_weather/ai_work_logs/` ディレクトリ新設（.gitkeep） | `90_weather/` 配下 |
| ✅ D-9 | `.gitignore` に上記 90_weather 追加ファイルの追跡例外を追加 | `.gitignore` |
| ✅ D-10 | `templates/investor_deck/deck_brief.template.md` 新設（ターゲット・目的・制約・構成希望の雛形） | `40_trellis/templates/investor_deck/` |
| ✅ D-11 | `templates/investor_deck/slide_map.template.yaml` 新設（構成合意ゲート用、12スライド雛形付き） | `40_trellis/templates/investor_deck/` |
| ✅ D-12 | `generate_investor_deck.md` のフロー簡略化（必読 17→10、context_pack 廃止、slide_specs+generated → slides.md 統合、3ステップ化） | `40_trellis/prompts/generate_investor_deck.md` |
| ✅ D-13 | `templates/investor_deck/README.md` を「未投入」状態から実態に合わせて更新 | `40_trellis/templates/investor_deck/README.md` |

---

### 次のセッションで着手すべき順序（推奨）

1. ~~**P0-1**：`templates/investor_deck/` の実体化~~ ✅ 対応済み
2. **P0-2**：`00_soil/market/`・`product/`・`claims/` の雛形ディレクトリ追加
3. **P0-3**：`examples/seed_business/` 同梱（架空 SaaS で全 Soil 埋め済み）
4. **P1-5**：`generate_sales_deck.md` と営業資料 Soil 最小構成の追加
5. **P1-6**：`00_soil/claims/claim_registry.template.yaml` 新設
6. **P1-2**：ロール名の日英混在解消（英語1種に統一）
7. **P1-3**：必読 17 → 7 への削減・context_pack 廃止（P2-5 と同時対応）

---

## 汎用化：問題一覧（2026-05-24）

> **このセクションの目的**
> Farm は「小説・ニュースレター・マニュアル・脚本など、あらゆるコンテンツを栽培できる汎用フレームワーク」のはずだが、
> 現状の実装は新規事業開発に特化した前提が多く混入している。
> 次セッション以降で本格対応するための問題一覧。

### 暫定対応済み（2026-05-24）

| # | 内容 | 対応ファイル |
| :--- | :--- | :--- |
| ✅ G-1 | `artifact_rules.md §1` の「claim_id 必須」「商用条件」「投資家の懸念」等を §1.1 として分離し、「事業系・論述系の追加ルール」と明示。§1 本体は汎用ルールのみに整理 | `artifact_rules.md` |
| ✅ G-2 | `artifact_rules.md §2.5` から `commercial_offer.md` / `issue_messaging.yaml` の事業系参照を削除し、汎用表現に置き換え | `artifact_rules.md` |
| ✅ G-3 | `artifact_rules.md §3` の「`00_soil/product/known_limitations.md`」「投資家資料は章末、営業資料は FAQ」を汎用化 | `artifact_rules.md` |
| ✅ G-4 | `farm.config.yaml` の `artifacts:` に novel / screenplay / newsletter / article / video_script を追加（status: planned） | `farm.config.yaml` |
| ✅ G-5 | `40_trellis/rules/README.md` の `artifact_rules` と `evidence_request_rules` の説明に「事業系・論述系のみ適用」を明記 | `40_trellis/rules/README.md` |

### 本格対応が必要な問題一覧（次セッション以降）

#### Core レベル（フレームワーク全体に影響する）

| # | 問題 | 深刻度 | 対応の方向性 |
| :--- | :--- | :---: | :--- |
| GC-1 | **`evidence_request_rules.md` 自体が事業系専用**。「説得材料」「claim maturity」「投資家への説得ロジック」という概念は、小説・マニュアル等には存在しない。「Core ルール」として全 artifact に適用されるのは誤り | 高 | 事業系 Kit に移動するか、「事業系・論述系 artifact のみ適用」を冒頭で明示し、Farm Core の必読リストから外す |
| GC-2 | **`00_soil/` の雛形構成が事業系前提**。`brand/`・`business/`・`product/`・`market/`・`claims/`・`objections/` というディレクトリ命名とファイル群は、新規事業開発の語彙体系。小説なら `characters/`・`world/`・`plot/`・`themes/`、ニュースレターなら `audience/`・`voice/`・`topics/` が対応する | 高 | 「Soil はプロジェクト種別に応じて自由に構成する」ことを README と agent.md に明記。種別ごとの Soil 構成例を `examples/` または `kits/` に追加 |
| GC-3 | **`generate_investor_deck.md` しかプロンプトが存在しない**。Farm Core に同梱するプロンプトが 1 種類では「汎用フレームワーク」として機能しない。他のユースケースを始めようとした時に手引きがゼロ | 高 | 最低限 `generate_article.md`（記事・コラム汎用）と `generate_narrative.md`（小説・脚本汎用）を追加して、非事業系ユースケースのスタート地点を用意する |
| GC-4 | **`glossary.yaml` が事業系用語を前提とした説明**。「Farm Core 用語」「Instance 用語」の分類はよいが、Instance 用語の記入例が事業系（`competitors`・`features`・`pricing` 等）に偏っている | 中 | 小説用・ニュースレター用の記入例を並列で追加。または「コンテンツ種別に応じて自由に定義」という注記を強調 |
| GC-5 | **`design_handoff_rules.md` と `slide_markdown.md` テンプレートがスライド（事業資料）専用**。Farm Core に同梱する出力フォーマットが「スライド型」だけでは、小説・記事・ニュースレター等の handoff ルールが存在しない | 中 | `document_markdown.md`（記事・マニュアル・ニュースレター向けの章立て出力テンプレ）と `narrative_markdown.md`（小説・脚本向けの場面出力テンプレ）を追加 |
| GC-6 | **`README.md` の「ユースケース別 Soil 最小構成」が A. 投資家資料のみ**。新規事業以外のユーザーが Soil を何から揃えればいいかわからない | 中 | B. 小説、C. ニュースレター、D. 技術マニュアル 等の Soil 最小構成セクションを追加 |

#### テンプレート・プロンプトレベル

| # | 問題 | 深刻度 | 対応の方向性 |
| :--- | :--- | :---: | :--- |
| GT-1 | **`deck_brief.template.md` と `slide_map.template.yaml` が投資家資料向け特化**（今セッションで追加）。これは `templates/investor_deck/` に配置されているので内容自体は正しいが、他の artifact 向けの brief / map テンプレートが存在しない | 中 | 汎用の `brief.template.md`（どの artifact にも使える「今回の依頼書」）を `templates/artifact_common/` に追加。各 artifact 固有の brief はその派生とする |
| GT-2 | **Soil Readiness Audit のチェック項目が事業系前提**。`soil_readiness_audit.template.md` の「必須 Soil」欄の記入例が business / product / market 向け | 低 | テンプレートの例示を汎用化し、「各 artifact のプロンプトに対応する必須 Soil を記入する」というプロセスの説明に変える |

### 本格対応の推奨アーキテクチャ（次セッション用メモ）

Farm Core の汎用化には 2 つのアプローチがある。次セッション冒頭でどちらを採用するか確認する。

**案 A：Core をシン化 + ユースケース Kit を分離**
```
farm/
  40_trellis/rules/       ← 全 artifact 共通のルールだけ残す（claim_id 等は Kit 側へ）
  kits/
    new_business/         ← 投資家資料・事業計画用の rules 拡張・templates・soil 構成例
    novel/                ← 小説・脚本用の rules 拡張・templates・soil 構成例
    newsletter/           ← ニュースレター・記事用
```
→ Core が純粋に汎用になる。ただし既存の事業系インスタンスが Kit を参照するよう移行が必要。

**案 B：Core に並列追加（現状路線の拡張）**
```
farm/
  40_trellis/
    prompts/
      generate_investor_deck.md   ← 既存
      generate_novel_chapter.md   ← 追加
      generate_newsletter.md      ← 追加
    templates/
      investor_deck/              ← 既存
      narrative/                  ← 追加（小説・脚本向け）
      document/                   ← 追加（記事・マニュアル向け）
```
→ 移行コストが低い。ただし Core がどんどん膨らむリスクがある。

---

## Feedback Log

```yaml
- id: fb-001
  date: YYYY-MM-DD
  source: どの作業・成果物・会話で気づいたか
  category: ルール / テンプレート / ディレクトリ構成 / 運用概念 など
  observed: |
    実際に困ったこと、欠陥、追加で必要だと感じたこと。
  proposal: |
    Farm Core にどういう初期機能・初期ルール・初期テンプレートが欲しいか。
  priority: P0
  status: open

- id: fb-006
  date: 2026-05-21
  source: farm-xtrust business_plan_investor soil readiness audit and issue messaging review
  category: artifact_rules / 00_soil brand / generation gate
  observed: |
    事業計画を作る前に、そもそも現在のsoilで事業計画が作れるかを判定する
    readiness gateがFarm Coreに存在しない。そのため、足りない根拠があるまま
    greenhouse / harvestに進み、AIが未確定情報を補完してしまう。

    また、タグライン、Issueごとの切り口、繰り返し使う言い回しが成果物ごとに
    生成されると、同じ事業であるにもかかわらず毎回メッセージが揺れる。
  proposal: |
    Farm Coreに以下を追加する：
    1. 70_grading/<artifact>/<version>_review/soil_readiness_audit.mdのテンプレート
    2. full rewrite / new artifact generationの前にP0 missing soilを確認するgateルール
    3. 00_soil/brand/issue_messaging.yamlのテンプレート
    4. key_copy.mdとissue_messaging.yamlを変更する場合のchange_log必須化
    5. artifact_rules.mdに「タグライン・Issue framing・定型言い回しを生成時に発明しない」ルールを追加
  priority: P0
  status: closed
  resolution: |
    2026-05-24 反映済み。
    - `40_trellis/templates/artifact_common/soil_readiness_audit.template.md` 新設
    - `40_trellis/rules/artifact_rules.md` §9（Soil Readiness Gate）新設
    - `00_soil/brand/issue_messaging.yaml` 雛形新設（change_log セクション組込み）
    - `00_soil/brand/key_copy.md` に change_log セクション追加
    - `artifact_rules.md` §2.5 に「Issue framing / 定型フレーズを生成時に発明しない」「key_copy / issue_messaging 変更時の change_log + soil_changelog 二重記録必須」を追加
    - `40_trellis/prompts/generate_investor_deck.md` に readiness gate 呼び出しと参照優先順位を組み込み

- id: fb-007
  date: 2026-05-22
  source: farm-xtrust business_plan_investor evidence request運用見直し
  category: artifact_rules / 70_grading / research workflow
  observed: |
    Farm Coreのmissing_info / missing_soilは、情報不足を検出するには有効だが、
    「足りないからできません」で止まりやすい。実際の資料作成では、
    まず伝えたい仮説・説得ロジックがあり、そのロジックを支えるために
    必要なデータを取りに行くのが基本である。
  proposal: |
    Farm CoreにEvidence Request Queueを標準導入する。
    1. 40_trellis/rules/evidence_request_rules.mdを標準ルールとして追加
    2. claim maturityにvalidated / source_pending / desired / rejectedを導入
    3. 70_grading/<artifact>/<version>_review/evidence_request_queue.mdテンプレートを追加
    4. 成果物レビュー時に、AIが「この主張を通すには何の数字が必要か」を
       proactiveに列挙するgateを追加
    5. source_pendingの数字は内部ドラフトで使えるが、外部提出前にvalidatedへ昇格、
       もしくはappendix / source noteに分離する運用を明記
    6. missing_infoは「不足一覧」、evidence_request_queueは「取りに行くべき
       説得材料」として役割分担する
  priority: P0
  status: closed
  resolution: |
    2026-05-24 反映済み。
    - `40_trellis/rules/evidence_request_rules.md` 新設（claim maturity / 役割分担 / 出荷ゲート明文化）
    - `40_trellis/templates/artifact_common/evidence_request_queue.template.md` 新設
    - `40_trellis/rules/artifact_rules.md` §1 に claim maturity と source_pending の外部提出禁止を追加
    - `40_trellis/prompts/review_investor_deck.md` に Evidence Request の能動列挙ゲート（§2.5）を追加

- id: fb-008
  date: 2026-05-23
  source: farm-xtrust investor_deck v002表現レビュー
  category: 00_soil構造 / artifact_rules / generation hygiene
  observed: |
    生成物の読者向け本文に、「主題は<旧表現>ではなく」のような
    修正履歴由来の否定形表現が混入した。これは読者が知る必要のない
    生成過程の矯正メモが、そのまま成果物に漏れた状態である。
  proposal: |
    Farm Coreに「正の定義」と「生成用ガードレール」の分離設計を標準導入する。
    1. artifactごとに、読者向けの中心命題だけを書くcore_message系soilを用意する
    2. avoid / do_not_center_on / correction_historyはguardrails系soilへ分離する
    3. artifact_rules.mdに「生成過程の矯正メモを本文へ漏らさない」原則を追加する
    4. 「AではなくB」のような否定形矯正文は、出力前に必ずBの正の定義へ書き換える
    5. context_packはcore_messageを最上位参照にし、guardrailsは補助参照へ下げる
  priority: P0
  status: closed
  resolution: |
    2026-05-24 反映済み。
    - `00_soil/brand/core_message.md` 新設（読者向け中心命題の正規置き場、change_log 組込み）
    - `00_soil/brand/guardrails.md` 新設（do_not_center_on / avoid_tone / correction_history の集約、本文持込禁止を明示）
    - `40_trellis/rules/artifact_rules.md` §10「生成過程の矯正メモを本文へ漏らさない原則」追加
    - `40_trellis/prompts/generate_investor_deck.md` の参照優先順位を core_message 最上位／guardrails 補助に改訂

- id: fb-009
  date: 2026-05-23
  source: farm-xtrust business_plan_investor版整理と参照先更新作業
  category: versioning / layer_protocol / artifact_rules / generation workflow
  observed: |
    「その時点の厳密な版を固定参照したいケース」と「単にそのartifactの
    最新版を正本として見たいケース」が、Farm Core上で区別されていない。
    版上げのたびに大量の手修正が必要になり、実体と参照名が乖離する。
  proposal: |
    1. exact reference と canonical latest reference を分離
    2. 60_harvest/<artifact>/current.yaml ポインタファイル追加
    3. artifact_rules.md / layer_protocol_rules.md / agent.md に運用ルール追加
    4. version promotion時の必須チェック追加
    5. 将来的に自動更新フローまたは検査ルールを Farm Core に含める
  priority: P0
  status: closed
  resolution: |
    2026-05-24 反映済み。
    - `40_trellis/templates/artifact_common/current.yaml` 雛形新設
    - `40_trellis/rules/layer_protocol_rules.md` §5「Exact vs Canonical Latest Reference」新設
    - `40_trellis/rules/artifact_rules.md` §11「版昇格時の必須チェック」新設
    - `agent.md` に簡潔な参照モード使い分けルールを追記
    - 将来拡張（自動更新フロー）は layer_protocol_rules §5.5 に保留として明示

- id: fb-010
  date: 2026-05-24
  source: farm-xtrust investor_deck v003 / business_plan v004 制作時の表現統制議論
  category: ルール / artifact_rules / agent.md テンプレート
  observed: |
    複数セッションにわたって、同じ「特定の表現を使わないでほしい」要望が繰り返し発生した。
    Farm Coreのartifact_rules.mdには「禁止表現原則」セクションはあるが、
    これは外部公開資料の誇大表現チェック用であり、内部ドキュメント・ルール文・
    ログ本文に「『X』を使わない」型の記述が残ることでAIが該当単語を学習してしまう
    問題を解けない。
  proposal: |
    Farm Coreに以下を default で含める：
    1. 新規ルールファイル：40_trellis/rules/expression_governance_rules.md のテンプレート
    2. agent.md テンプレートに「表現統制ルール」セクションを default で含める
    3. artifact_rules.md の「禁止表現原則」セクションを再設計
    4. farm_evolution_rules.md ルール7 に「過去ログの具体表現言及は抽象化する」を追加
    5. （任意）cross-project向けに /Users/kaya.matsumoto/AGENTS.md にも同等のルールを記載
  priority: P0
  status: closed
  resolution: |
    2026-05-24 反映済み（Farm Core 内に閉じた範囲）。
    - `40_trellis/rules/expression_governance_rules.md` 新設（原則 / 統制手順3ステップ / ログ抽象化 / 例外）
    - `agent.md` に「表現統制（grep ベース）」セクションを default で追加
    - `40_trellis/rules/artifact_rules.md` §2 を「外部公開資料向け」に限定し、内部統制は expression_governance_rules.md に委譲する旨を明記
    - `40_trellis/rules/farm_evolution_rules.md` §7 に「過去ログの具体表現言及は抽象化する」追記
    - 提案 5（/Users/kaya.matsumoto/AGENTS.md への追加）は Farm 外のため本対応の範囲外。別途指示を受けた時点で実施する。

- id: fb-011
  date: 2026-05-24
  source: farm-core 自己批判レビュー（ゼロベース整合性監査）
  category: ルール / ディレクトリ構成 / docs / オンボーディング
  observed: |
    Farm Core を独立コンサル視点でゼロベース監査した結果、以下の議論の余地のない
    不整合・抜けが確認された。
    1. `40_trellis/rules/propagation_rules.md` が `layer_protocol_rules.md` §1〜§4 の
       劣化コピーで完全重複、かつ `agent.md` から参照されない孤児ファイル化していた。
    2. `artifact_rules.md` §2「禁止表現原則」と `expression_governance_rules.md` が
       本文では分離されていたが、セクション名（タイトル）が同義語で誤読を招いていた。
    3. ルールファイルが計 7 本（README 追加前）あるにも関わらず、`agent.md` は
       3 本しか読み込み指示しておらず、残り 4 本（artifact_rules, evidence_request_rules,
       expression_governance_rules, design_handoff_rules, farm_evolution_rules）への
       入口が存在しなかった。
    4. ログ記録先が `soil_changelog.md` / `decision_log.md` / `farm_reviews/` /
       `farm_backlog.md` / `missing_info.md` / `evidence_request_queue.md` /
       `FARM_CORE_FEEDBACK.md` / `ai_work_logs/` の 8 種類に分散しているが、
       使い分けの早見表が存在せず、新規ユーザー（および AI）が判断に迷う構造だった。
    5. `farm.config.yaml` の `meta.backlog` / `logging.decision_log` /
       `logging.ai_work_log_dir` / `meta.reviews` が実体ファイル・ディレクトリ無しで
       参照されており、初回利用時に必ず実体不在で詰まる状態だった。
  proposal: |
    Farm Core に以下を default で含める：
    1. `propagation_rules.md` を削除し、`layer_protocol_rules.md` に統合する
    2. `artifact_rules.md` §2 のセクションタイトルを「外部公開資料の表現チェック
       （誇大表現・法規リスク）」に改名し、冒頭引用で `expression_governance_rules.md`
       との守備範囲分離を明示する
    3. `40_trellis/rules/README.md`（ルール索引）を新設し、全ルールの守備範囲・
       関連ファイル・適用タイミングを 1 表で示す
    4. `agent.md` に「上記 3 つ以外のルールは README.md 索引を参照」と追記する
    5. `farm_evolution_rules.md` 末尾に「ログ記録先 早見表」を追加し、判断順序を明文化する
    6. `farm.config.yaml` が参照する `90_weather/farm_backlog.md` /
       `90_weather/decision_log.md` / `90_weather/farm_reviews/` /
       `90_weather/ai_work_logs/` の雛形を Farm Core に同梱する
  priority: P0
  status: closed
  resolution: |
    2026-05-24 反映済み。
    - `40_trellis/rules/propagation_rules.md` 削除（layer_protocol_rules.md §1〜§4 で完全カバー、参照漏れなしを grep 確認済み）
    - `40_trellis/rules/artifact_rules.md` §2 タイトルを「外部公開資料の表現チェック（誇大表現・法規リスク）」に変更し、冒頭で expression_governance_rules.md との守備範囲分離を引用ブロックで明示
    - `40_trellis/rules/README.md` 新設（全 7 ルールの索引、紛らわしいペアの守備範囲表、ログ記録先早見表への誘導）
    - `agent.md` の §1 にルール索引（README.md）への参照を追記
    - `40_trellis/rules/farm_evolution_rules.md` §9「ログ記録先 早見表」を新設（8 種類の記録先の使い分け表と判断順序）
    - `90_weather/farm_backlog.md` / `90_weather/decision_log.md` 雛形新設（書式テンプレートと参照ルール明記）
    - `90_weather/farm_reviews/.gitkeep` / `90_weather/ai_work_logs/.gitkeep` 追加
```
