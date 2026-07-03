# Farm Release Notes (リリースノート)

本ドキュメントは、Farmフレームワークのアップデートおよび機能追加の歴史を記録するリリースノートです。

---

## [2026-07-03] v2 — 全面再設計（機構化・コンパイルモデル・構造の縮約）

farm-xtrust（初の実運用Instance）での数か月の運用で観測された破綻パターンを踏まえ、フレームワークをゼロベースで再設計した。

### 設計判断（なぜ変えたか）

v1の失敗はすべて同じ根から出ていた：(1)書き込み時分類のコストがLLMの得意分野（読み出し時統合）と逆向き、(2)生成事故のたびに散文ルールを追加してルール総量がAIの遵守能力を超えた、(3)同じ主張が5層以上に複製され手動の依存管理（sources.yaml/soil_changelog）が腐った、(4)実体が1人+1セッションなのに7体の仮想エージェント組織を演じた、(5)正規ルートが近道より重く、実運用でバイパスされた。

### 主な変更

- **構造の縮約**: 10ディレクトリ → 4+納屋（`0_soil` / `1_seeds` / `2_harvest` / `9_compost` / `barn`）。seedbank / nursery / greenhouse / grading / market / weatherを廃止し、昇格ラダーをseeds→soilの1段に統一
- **コンパイルモデル**: 成果物は手で維持せずsoilから再生成する。版番号ディレクトリを廃止し、履歴はgit・出荷はgit tagで管理
- **機構化（barn/farm.sh）**: 散文ルール12ファイル1,500行 → 1ファイル（barn/rules.md）+検査スクリプト。soil索引の自動生成、成果物のstale検出（frontmatterのdepends_on/built_from×git履歴）、健康診断（status）
- **儀式の一本化**: seed_index / soil_changelog / decision_log / ai_work_logsの手動台帳を全廃し、「セッション終わりの蒸留」1つに集約。変更ログはgit commitメッセージが担う
- **OKF/LLM Wikiの整理**: frontmatter+リンク追跡（Traversal）は継続。手動維持のsoil_index.mdはスクリプト生成の`_index.md`に置換。owner/freshness_slaのような組織メタデータは削除。クエリ永続化は蒸留の儀式に統合
- **ロールの縮約**: 7仮想エージェント+Orchestrator → 「二つの帽子」（生成/監査の分離）のみ
- **v1の知見の保存**: 表現統制（物理削除3ステップ）、objections（誤解前提の生成事故対策）、claims成熟度（validated/pending/desired、Evidence Request Queueを吸収）、FARM_CORE_FEEDBACK還流は、形を変えて全て継承

---

## [2026-06-30] OKF (Open Knowledge Format) & LLM Wiki パターンの統合

### 追加・変更内容
AI時代のナレッジ管理（Markdown＋メタデータ）の統一規格である **OKF** と、知識の累積・自律保守を促す **LLM Wiki** のコンセプトをFarmフレームワークの仕様として統合しました。

（このバージョンのファイル構成はv2で再編された。詳細はgit履歴の該当コミットを参照）

- **OKF仕様**: 正規情報へのYAMLフロントマター適用を義務化
- **検索最適化（芋づる式検索）**: メタデータフィルタリングとリンク追跡（Traversal Search）
- **Lint（定期検診）プロトコル**: 矛盾検知、リンク切れ、鮮度チェック
- **Queryの永続化**: チャットで生まれた知見のアセット保存
