---
title: "Corda Open Sourceの商用環境への利用"
linkTitle: "Corda Open Sourceの商用環境への利用"
date: 2021-07-11T17:35:31+09:00
description: >
  Corda Open Sourceの商用環境への利用
---

### Question
Corda Open Sourceを商用環境に使うことは可能でしょうか？

### Answer
いいえ。

Corda Enterpriseは商用版であり、Corda Open Sourceは公式製品サポートのつかないトライアル版です。

Corda Open Sourceは誰でも無料でGithubから入手して、自由に利用することができますが、オープンソースソフトウェアなので、SBI R3 JapanまたはR3社の公式サポートを受けることができません


商用利用する際のリスクは一般的に以下です。

- 障害発生時に公式製品サポートを利用することができないので、復旧に時間とコストがかかる、あるいは原因究明に至らない可能性がある
- アプリケーションのエンドユーザーがセキュリティー上の懸念を示す可能性がある
- サービスのリリース前判定（社内決済、社内セキュリティー・チェックリストのクリア）を通らない可能性がある

 
Corda Enterpriseを使うことで

- 公式の日本語製品サポート
- 迅速なパッチ提供
- パフォーマンス向上（トランザクションの並行処理機能など）
- Corda Firewall
- 高可用性構成
- が利用可能になります。