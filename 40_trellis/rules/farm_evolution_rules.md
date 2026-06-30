# Farm Evolution Rules

> 支柱 (trellis)：farm 自体を更新するためのルール。
> 成果物制作中に見つかった運用上の課題を、消えない形で扱う。

## 1. ファーム改善は成果物と同じライフサイクルで扱う

ファーム改善も、いきなり README やルールに直書きしない。
原則として以下の順で扱う。

1. 気づき：`90_weather/farm_reviews/`
2. 改善候補：`90_weather/farm_backlog.md`
3. 採用ルール：`40_trellis/rules/`
4. 正規モデル：`00_soil/farm/`
5. 入口説明：`README.md`

## 2. 事実、仮説、決定を分ける

ファーム改善メモには、最低限以下を分けて書く。

- observed: 実際に起きたこと
- risk: 放置した場合のリスク
- proposal: 改善案
- decision: 採用した決定
- next_action: 次にやること

## 3. README は入口に留める

README はすべての詳細を置く場所ではない。
README には、利用者が迷わないための入口、主要ディレクトリ、代表的な流れだけを書く。
詳細ルールは `40_trellis/rules/`、正規概念は `00_soil/farm/`、レビュー結果は `90_weather/farm_reviews/` に分離する。

## 4. 暫定情報を soil に入れる場合は明示する

営業条件、価格、PoC 条件のように、まだ動く情報を `00_soil/` に入れる場合は、ファイル冒頭で暫定性を明示する。
外部向け成果物では、暫定条件を確約のように扱わない。

## 5. Artifact が増えたら config を更新する

新しい成果物種別を実際に作り始めたら、`farm.config.yaml` の `artifacts` を更新する。
`status: planned` のまま greenhouse に成果物が増え続ける状態を避ける。

## 6. Missing Info は backlog ではない

`missing_info.md` は、その成果物を進めるための不足情報である。
ファーム自体の改善課題は `90_weather/farm_backlog.md` に分ける。
混ぜると、営業上の未確定情報とシステム改善課題が見分けにくくなる。

## 7. 変更したらログに残す

ファームの構造、運用ルール、情報分類を変えた場合は、必ず `90_weather/decision_log.md` に残す。
小さな文言修正は不要だが、置き場所やライフサイクルの変更は記録する。

ログを書くときは、**過去ログ内の具体表現言及を抽象化する** ルールに従うこと。
「『X』を削除した」のように対象語を生のまま残すと、AI がそれを再学習するため、
`<旧表現>` のような抽象化表現に置き換える。詳細は `40_trellis/rules/expression_governance_rules.md` §3 を参照。

## 8. Farm Core へのフィードバックは別で蓄積する

この Farm Instance の改善課題と、Farm Core（テンプレート本体）への改善要望は分けて扱う。

- Instance 固有の運用改善は、従来通り `90_weather/farm_reviews/` や `90_weather/farm_backlog.md` に記録する。
- 「次の Instance を作るときに最初から入っていてほしかったもの」は、ルートの `FARM_CORE_FEEDBACK.md` に蓄積する。
- `FARM_CORE_FEEDBACK.md` は蓄積専用であり、自動送信や自動反映は前提にしない。
- 人間が必要と判断したときだけ、このファイルを別の Farm や配布元へ共有する。

最低限、以下の項目を残す。

- `id`
- `date`
- `source`
- `category`
- `observed`
- `proposal`
- `priority`
- `status`

---

## 9. ログ記録先 早見表（どこに何を書くか）

Farm には複数の記録ファイル／ディレクトリがあり、目的別に書き分ける。迷ったら本表を参照。

| 書きたい内容 | 記録先 | 主な参照ルール |
| :--- | :--- | :--- |
| `00_soil/` の正規情報を追加・更新・削除した事実と Why | `90_weather/soil_changelog.md` | `layer_protocol_rules.md` §3 |
| 版昇格（`v00X → v00(X+1)`）の決定 | `90_weather/decision_log.md` | `artifact_rules.md` §11.5 |
| Farm の構造・運用ルール・情報分類を変えた決定 | `90_weather/decision_log.md` | 本ルール §7 |
| 表現統制（grep ベースの削除・置換）を実施した記録 | `90_weather/decision_log.md`（対象語は抽象化して記述） | `expression_governance_rules.md` §3 |
| 運用中の気づき・違和感（まだ提案前のメモ） | `90_weather/farm_reviews/<topic>.md` | 本ルール §1.1 |
| Farm 改善の候補（提案として整形済み） | `90_weather/farm_backlog.md` | 本ルール §1.2、§6 |
| 成果物を進めるための不足情報（その artifact 固有） | `50_greenhouse/<artifact>/missing_info.md` | `artifact_rules.md` §7 |
| 取りに行けば説得力が上がる外部データのリクエスト | `70_grading/<artifact>/<version>_review/evidence_request_queue.md` | `evidence_request_rules.md` §3 |
| 生成作業の入出力・判断履歴（毎回の作業ログ） | `90_weather/ai_work_logs/` | `artifact_rules.md` §6 |
| 「次の Instance に最初から入っていてほしい」改善要望 | ルートの `FARM_CORE_FEEDBACK.md` | 本ルール §8 |

### 振り分けの判断順序

1. **対象が `00_soil/` の変更そのものか？** → `soil_changelog.md`
2. **対象が成果物の版昇格や Farm 構造変更か？** → `decision_log.md`
3. **対象が「これからどうするかの提案」か？** → 未整形なら `farm_reviews/`、整形済みなら `farm_backlog.md`
4. **対象が「特定の artifact を進めるのに足りないもの」か？** → `missing_info.md`（既存資料）または `evidence_request_queue.md`（外部リサーチ）
5. **対象が「Farm Core 自体への要望」か？** → `FARM_CORE_FEEDBACK.md`

複数に該当しそうな場合は、**「読み返すときに最初に開きそうな場所」** を一次置き場とし、他から参照リンクを残す。
