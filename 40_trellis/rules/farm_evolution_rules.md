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
