---
type: "<情報カテゴリ。例: business_model, product_spec, brand_guideline, market_hypothesis, claim_registry 等>"
title: "<ドキュメントの簡潔なタイトル（日本語）>"
description: "<ドキュメントの概要・目的の簡潔な要約（1-2文）>"
status: canonical  # canonical (正規情報) または deprecated (アーカイブ化された古い情報)
timestamp: "<作成または最後に正確性を検証した日時。ISO 8601フォーマット。例: 2026-06-30T13:30:00+09:00>"
owner: "<この情報を管理・更新する責任を持つ役割。例: product-lead, marketing-team, CEO 等>"
freshness_sla: "<この情報の見直し・更新周期の取り決め。例: monthly, quarterly, yearly, adhoc>"
depends_on_seeds: []  # この正規情報への昇格元の素材（Seed）のファイルパスやIDがあれば記述（任意）
tags: []  # 検索用タグの配列。例: [pricing, spec, core_message]
---

# ドキュメントタイトル（または見出し）

ここには、AIが推測を交えず、本番の生成や回答に用いてよい正規情報（仕様、数値、事実、決定されたポリシーなど）をマークダウン形式で記述します。
情報は簡潔かつ客観的に表現し、可能な限り数値や根拠を伴わせてください。

## 関連コンセプト / Concept Links
OKFの接続性を活かすため、関連する他のSoilドキュメントへの相対リンクをここに記述します。
AIはこれを辿って「芋づる式（Traversal）」に関連知識を自動探索します。
- [関連ドキュメントタイトル](../path/to/another_concept.md)
- [関連ドキュメントタイトル2](../path/to/another_concept_2.md)
