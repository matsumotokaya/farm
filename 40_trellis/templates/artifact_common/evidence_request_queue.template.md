# Evidence Request Queue — <artifact> <version>

> このテンプレートは、`70_grading/<artifact>/<version>_review/evidence_request_queue.md` として
> コピーして使用します。
>
> **目的**：この成果物の説得力を上げるために、外部に取りに行くべきデータ（数値・事例・出典）を
> 能動的にキュー化します。
>
> 運用ルール: `40_trellis/rules/evidence_request_rules.md`
> 関連：`missing_info.md`（不足検出は別役割）、`claim_registry.yaml`（claim maturity）

---

## 1. 対象

- artifact: `<artifact_name>`
- version: `<v00X>`
- 起票日: `<YYYY-MM-DD>`
- 起票者: `<orchestrator / inspector / human>`

---

## 2. Evidence Requests

各リクエストは以下のフォーマットで記述する。

```yaml
requests:
  - id: ER-YYYY-XXX
    status: open                  # open / in_progress / closed_validated / closed_rejected
    related_claim_id: <CL-... または null>
    target_artifact_section: <スライド番号 / 章 / セクション>
    hypothesis: |
      <この主張を通したい>
    evidence_needed: |
      <どんな種類のデータがあれば論旨が強くなるか>
      （統計値 / 第三者調査 / 事例 / 比較数値 など）
    candidate_sources:
      - <調査機関名 / レポート名 / URL or 検索キーワード>
    why_it_matters: |
      <なぜこれがあると説得力が大きく上がるか>
    deadline: <YYYY-MM-DD または null>
    owner: <担当 or null>
```

### サンプル

```yaml
requests:
  - id: ER-2026-001
    status: open
    related_claim_id: CL-2026-014
    target_artifact_section: Slide 04（市場機会）
    hypothesis: |
      日本企業の業務データのうち、クラウド型生成AIに入力できない
      （機密・規制等の理由で）データが過半を占める。
    evidence_needed: |
      国内企業のクラウド AI 利用に関するデータ送信可否の調査統計、
      または業種別の機密データ取り扱いポリシー調査。
    candidate_sources:
      - IPA セキュリティ白書
      - 経産省 DX レポート（最新版）
      - 民間調査会社の生成AI業務利用調査
    why_it_matters: |
      この数字が出ると「クラウド AI では届かない領域がある」が
      仮説から事実ベースの主張に格上げできる。
    deadline: 2026-06-01
    owner: matsumoto
```

---

## 3. claim maturity の更新メモ

このレビュー過程で `claim_registry.yaml` の maturity を更新した場合、ここに記録する。

| date | claim_id | from | to | reason |
|---|---|---|---|---|
| `<YYYY-MM-DD>` | `<CL-...>` | `<source_pending>` | `<validated>` | `<出典取得済み>` |

---

## 4. 本文残存チェック（出荷前）

`source_pending` または `desired` 起源の数値・主張が、外部提出版の本文に残っていないか確認する。

```yaml
remaining_in_body:
  source_pending: []   # 残っていれば list-up（出荷前に処理必須）
  desired: []          # 残っていれば list-up
```

すべて空であることが、`80_market/` への出荷条件。
