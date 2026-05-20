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
```
