# Soil Readiness Audit — <artifact> <version>

> このテンプレートは、`70_grading/<artifact>/<version>_review/soil_readiness_audit.md` として
> コピーして使用します。
>
> **目的**：full rewrite / 新規 artifact 生成 / メジャー版上げの前に、
> 「現在の `00_soil/` の状態で、この成果物が責任をもって作れるか」を判定する Gate。
>
> readiness gate のルールは `40_trellis/rules/artifact_rules.md` §9 を参照。

---

## 1. 対象

- artifact: `<artifact_name>`
- version (目標): `<v00X>`
- 起票日: `<YYYY-MM-DD>`
- 起票者: `<orchestrator / human>`

---

## 2. 必須 Soil チェック（artifact 種別ごと）

artifact 種別ごとに「揃っていなければ生成を開始してはならない」soil を確認する。
チェック対象は `40_trellis/prompts/generate_<artifact>.md` の「必読の入力」と一致させること。

| # | 必要な soil | パス | 期待される粒度 | 現状 | 判定 |
|---|---|---|---|---|---|
| 1 | <例: ポジショニング> | `00_soil/business/positioning.md` | 1文で言える形 | `<draft / candidate / canonical / missing>` | `<P0 / P1 / OK>` |
| 2 | <例: 中心命題> | `00_soil/brand/core_message.md` | 読者向けの中心命題が確定 | | |
| 3 | <例: Issue framing> | `00_soil/brand/issue_messaging.yaml` | 主要 Issue が canonical | | |
| 4 | <例: ガードレール> | `00_soil/brand/guardrails.md` | 避ける論点が明示 | | |
| 5 | <例: 主張台帳> | `00_soil/claims/claim_registry.yaml` | 主要主張に source あり | | |

判定の意味：

- **P0**: これがないと、AI は推測で埋めてしまう。**生成開始を許可しない**。
- **P1**: 不足しているが、`missing_info.md` で人間に問い合わせながら進めてよい。
- **OK**: そのまま生成可。

---

## 3. P0 missing soil 一覧（生成開始を止めるもの）

> ここに 1 件でもあれば、その artifact の生成は **開始しない**。
> 先に該当 soil を埋めるか、人間に明示的な「P0 を承知の上で進める」承認を取る。

```yaml
p0_missing: []
# 例：
# p0_missing:
#   - item: 中心命題（core_message）
#     path: 00_soil/brand/core_message.md
#     reason: 読者向けの正の命題が未定。生成すると修正履歴メモが本文に漏れるリスクが高い。
#     action: 人間に確認し canonical 化してから再 audit
```

---

## 4. P1 missing soil 一覧（進めながら埋めるもの）

```yaml
p1_missing: []
# 例：
# p1_missing:
#   - item: 競合比較の出典
#     path: 00_soil/market/evidence_sources.yaml
#     reason: 競合スライドの数値が claim_id 未付与
#     action: missing_info.md に転記し、生成中に並行収集
```

---

## 5. Issue framing / Key copy の固定状況

| 種別 | ファイル | 必要なエントリ | 状態 |
|---|---|---|---|
| タグライン | `00_soil/brand/key_copy.md` | tagline | `<draft / canonical>` |
| ワンライナー | `00_soil/brand/key_copy.md` | one_liner | `<draft / canonical>` |
| Issue framing | `00_soil/brand/issue_messaging.yaml` | <ISSUE-XXX> | `<draft / canonical>` |

> いずれも `canonical` でない場合、AI は同じ役割のコピーを毎回発明することになり、
> 成果物間でメッセージが揺れる。生成前に確定すべき。

---

## 6. 判定

```yaml
verdict: <go / hold / block>
# go: 生成開始可
# hold: P1 のみ残っており、missing_info.md 運用で進める
# block: P0 が残っているため、soil を埋めてから再 audit
reason: <一文で根拠>
next_action: <次にやること>
```
