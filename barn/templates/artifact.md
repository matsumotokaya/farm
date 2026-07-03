---
artifact: <成果物名。例: business_plan>
audience: <対象読者。例: 投資家>
status: draft   # draft | shipped
depends_on:
  - 0_soil/identity.md
  - 0_soil/claims.md
built_from: <ビルド時のcommit hash（git rev-parse --short HEAD）>
built_at: <YYYY-MM-DD>
---

# <成果物タイトル>

本文はここから。depends_on に列挙したsoilだけを根拠に生成する。
新しい主張・数字・言い回しが必要になったら、先にsoilへ足してから使う。
