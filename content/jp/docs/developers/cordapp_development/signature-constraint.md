---
title: "Signature Constraint"
linkTitle: "Signature Constraint"
date: 2021-07-28T17:02:56+09:00
tags: ["security"]
---

CorDappの開発において、アップグレードは避けられません。CorDappのライフサイクルの間に、バグフィックスやビジネス要件の変更によるアップデートがないことはほとんどありません。アップグレードは小さなものもあれば、大規模な計画を必要とする複雑な変更の場合もあります。いずれにしても、これは見過ごせないテーマです。

読み進める前に、この記事はステート、フロー、コントラクトなどの[Cordaの主要な概念](https://training.corda.net/key-concepts/concepts/)を基本的に理解していることを前提としています。これらを理解していなければ、この記事の残りの部分はあまり意味をなさないので、まずはそれらに慣れることをお勧めします。

## ExplicitおよびImplicitなContractのアップグレード

Cordaでは、アップグレードを管理する方法が2つあります:

* **Explicit(明示的)**: すべてのノードで同じバージョンのコントラクトを持つCorDappsを動作させる必要があります。
* **Implicit(暗黙的)**: それぞれのノードが異なるタイミングでアップグレードできるようにすることで

**Explicit(明示的)** なアップグレードのコンセプトはとても簡単です。基本的にアップグレードが必要なときは、すべてのノードがそれを行う必要があります。Explicitアップグレードの欠点は、すべてのノードが、アップグレードされるコントラクトに属する元帳の既存の状態をすべて更新する必要があることです。これは重い処理になります。また、Cordaのような分散型台帳システムでは、すべてのノードに同時にアップグレードを要求することができない場合もあります。

一方、**Implicit(暗黙的)** のアップグレードでは、CorDappの異なるバージョンのノードが相互に取引を行うことができます。例えば、ノードAとノードBの両方がCorDappのバージョン1で動作していたとします。新しいバージョン（バージョン2）がリリースされ、ノードAはアップグレードし、ノードBはバージョン1のままだったとします。この時点で、ノードBは、トランザクション内のコントラクト・アタッチメントがトランザクションで使用される制約を満たす限り、ノードAとの間でトランザクションを開始することができます。このアプローチでは、ネットワークやノードの管理者がアップグレードの計画を立てる際に、より柔軟に対応することができます。

これを実現するためには、ノードがトランザクションで提示されたコントラクトが信頼できるかどうかをどのように判断するかが重要な問題となります。

## Contract Constraint

Contract constraintは、着信したトランザクションのcontractが受け入れられるかどうかを決定するアプローチとみなすことができます。

Cordaでは、いくつかのタイプのconstraintがサポートされています:

* **Hash constraint**: この状態で使用できるアプリのバージョンは1つだけです。これにより、元のバージョンで作成されたStateを利用しながら、将来的にアプリがアップグレードされることを防ぎます。これは、explicit upgradeに使用されます。
* **Compatibility zone whitelisted (or CZ whitelisted) constraint**: 互換性ゾーン演算子は、コントラクトクラス名で使用可能なバージョンのハッシュをリストアップします。
* **Signature constraint**: 特定の鍵で署名されたどのバージョンのアプリでも使用できます。Corda 4以降のバージョンでは、アプリが署名されている場合、この方法がデフォルトで使用されます。
* **Always accept constraint**: どのバージョンのアプリでも使用できます。これは安全ではありませんが、テストには便利です。

Cordaの公式ドキュメントによると、[Hash constraintとCompatibility zone whitelisted constraintは、Signature constraintが実装される前の初期のCordaバージョンの名残です。](https://docs.corda.net/docs/corda-os/4.8/api-contract-constraints.html#signature-constraints).

## Signature Constraintを使ったアップグレード

### Contract アップグレード

Corda 4では、CorDappが署名されている場合、デフォルトでSignature constraint が使用されます。キーは、[CompositeKey](https://docs.corda.net/docs/corda-enterprise/4.8/api-core-types.html#compositekey)またはシンプルなPublicKeyのいずれかです。着信トランザクションを処理する際、ノードはその中のcontract attachmentが、そのSignature constraintで指定された正しい署名者を持っているかどうかを確認します。

ノードが信頼していないcontract attachmentを使用するトランザクションを受信したが、同じコントラクトクラスと同じ署名を持つアタッチメントがノード上に存在する場合、ノードはそのcontractのコードを信頼しているかのように実行します。つまり、ノードは古いバージョンのCorDappを実行しているトランザクションを検証するために、すべてのバージョンのCorDappをアップロードする必要はなくなりました。代わりに、CorDappコントラクトの任意のバージョンがインストールされていれば十分です。

output stateを追加する際には、`TransactionBuilder`が適切な制約とattachmentを選択してくれます。そのため、ほとんどの場合、コード内で使用する制約の種類を指定することを気にする必要はありません。

CorDappのアップグレードとは、基本的にCorDappを新しいバージョンのJARファイルで置き換えることを意味します。また、新しいバージョンがstateの既存の状態と互換性があるかどうかを確認するために、様々なことに注意する必要があります。例えば、あるstateに新しいフィールドが導入された場合、そのフィールドを`Nullable`にすることで、古いバージョンのアプリで生成されたstateをデシリアライズする際に問題が発生しないようにします。

ここでは、Kotlinでの例です：

![image](/static/images/kotlin-sample.png)

## フローアップグレード

フローのアップグレードでは、異なるバージョンで動作しているノード間のトランザクションをどのように処理するかは、CorDapp 開発者がコントロールします。

フローのアップグレードの際に考慮すべき主な点は、フローのバージョニングです。@`InitiatingFlow`アノテーションには、デフォルトで1となるバージョンプロパティが用意されています。このプロパティが重要なのは、相手がどのバージョンのフローを実行しているかを判断するのに役立ち、それに応じて正しいビジネスロジックが実行されるようにフローを実装できるからです。

下記は、フローのバージョン番号を指定する例です：

![image](/static/images/kotlin-sample2.png)

下記は、カウンターパーティのフローバージョンを取得する例です：

![image](/static/images/kotlin-sample3.png)

## Backward-compatibility（後方互換性）

CorDappの構造は、2つの独立したモジュールに分割することが推奨されています。

* contracts.jarには、ステートとコントラクトロジックが格納されています。
* workflow.jarにはフロー、サービス、その他のサポートライブラリが格納されています。

contracts.jarはトランザクションに添付され、ネットワーク内のノード間で送信されますが、その中のコードはノードがトランザクションを検証するために必要なデータ構造とスマートコントラクトロジックを定義しているからです。CorDappのすべてが1つのモジュールに入っていると、フローのコードは使われていないにもかかわらず、一緒に流されてしまいます。

アップグレードは、コントラクトとワークフローの両方のモジュールの変更を伴うとは限りません。フローのビジネスロジックを変更する必要があるためにアップグレードが起こる場合もあれば、スマートコントラクトのコードを更新する必要がある場合もあります。コントラクトとワークフローの両方が変更される場合は、新バージョンのフローが旧バージョンのフローや旧バージョンのコントラクトと後方互換性があるかどうかを確認することが重要です。

## Hash contractからSignature contractへの移行

これまでの議論では、すべてのステートが同じタイプの制約によって作成されるという前提で話を進めてきました。しかし、現在Hash contractを使用していて、今後Signature contractに変更しようとしている場合、元帳上の既存の状態をSignature contractを使用するように移行する必要があります。

この記事の範囲外ですが、このトピックに関するいくつかのリソースがありますので、参考にしてみてください：

* [Unconstraint Signature Constraint Migration](https://medium.com/corda/unconstraint-signature-constraint-migration-e95a66789eab)
* [contract-constraint-migration in Corda Advanced Bootcamps](https://github.com/snedamle/corda_advanced_bootcamps/tree/master/contract-constraint-migration)
