---
title: "Cordaによるテスト駆動開発(TDD)"
linkTitle: "Tdd Corda"
date: 2021-09-15T12:44:25+09:00
tags: ["開発"]
type: docs
description: >
  Cordaによるテスト駆動開発(TDD)
---

> **注**：この記事は、CorDappの開発にすでに慣れているソフトウェア開発者を対象としています。

##　TDDとは
テスト駆動開発(TDD)とは、プロのソフトウェア開発者がクリーンでテスト可能かつ保守可能なコードを書くために用いるプログラミングスタイルです。

### TDDの3つの法則
TDDのワークフローはシンプルです。新しい機能を追加する際には、3つのステップを踏む必要があります。

1. 失敗するユニットテストを書く。
2. それをパスするためのコードを書く。
3. リファクタリングして、さらにユニットテストを追加する。

### メリット
- 不具合の大幅な減少。アプリケーションのすべての部分を管理するテストが増えます。
- コードアーキテクチャ設計の改善。開発者は設計とその影響について最初に考える必要があります。
- コードの保守性が向上します。バグの修正、古い機能の更新、新しい機能の追加が簡単かつ迅速にできます。

### 欠点
- 初期の学習曲線。TDD を習得するにはある程度の時間が必要ですが、その時間は本番環境でのデバッグや問題解決に必要な時間に充当されます。TDD は常に良い投資です。

### Learn more about TDD
Some useful resources to learn TDD:
- [Uncle Bob's The Three Rules of TDD](http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd)
- [Agile Alliance - What is TDD](https://www.agilealliance.org/glossary/tdd/)
- [Kent Beck - Test Driven Development by Example](https://www.amazon.co.jp/-/en/Kent-Beck-ebook/dp/B095SQ9WP4)
- [アジャイルソフトウェア開発](https://ja.wikipedia.org/wiki/%E3%82%A2%E3%82%B8%E3%83%A3%E3%82%A4%E3%83%AB%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2%E9%96%8B%E7%99%BA)

# TDDとCordaの実践
TDDを使って[Cordapp Template in kotlin](https://github.com/corda/cordapp-template-kotlin)の開発をしてみましょう。このcordappは
- 状態を作る
- この状態を使うためにPartyAとPartyBの間でトランザクションを行う

## Testing States
### 1. 失敗するユニットテストの作成
Corda のベスト プラクティスは、アプリケーションの最小単位である *state* から始めることです。

<img src="/docs/images/developers/tdd-2.png"/>。

ステートオブジェクトの開発から始めるのではなく、そのユニットテストから始めるのです。では、ユニットテストを書いてみましょう。
```kotlin
import org.junit.Test

class TemplateStateTest {
    @Test
    fun hasFieldOfCorrectType() {
        // Does the field exist?
        TemplateState::class.java.getDeclaredField("msg")
        // Is the field of the correct type?
        assertEquals(TemplateState::class.java.getDeclaredField("msg").type, String()::class.java)
    }

}
```
この時点では、まだ`TemplateState.kt`がないので、このコードはコンパイルすらできません。そこで、空の`TemplateState.kt`を作成してコンパイルし、ユニットテストを実行して失敗を確認してみましょう。

``bash
msg
java.lang.NoSuchFieldException: msg
```
このステップは、テスト環境が正しく動作しているかどうかを確認するためにも重要なステップです。

### 2. 通過させる
このユニットテストをパスさせるのは簡単です。
```kotlin
package net.corda.samples.example.states

data class TemplateState(var msg: String)
```
(Kotlinでは[Data Classes](https://www.callicoder.com/kotlin-data-classes/#kotlin-data-classes)を使用します)

このユニットテストを実行すると、パスします。

ご覧の通り、この時点では状態データクラスは `:ContractState` インターフェースもアノテーション `@BelongsToContract(TemplateContract::class)` も実装していません。これは、コントラクトのユニットテストをまだ実装していないので、できないのです（もちろん、CorDappの開発やTDDに慣れてくれば、すぐにそれらの実装を追加することができます）。

### 3. リファクタリング
現時点では何もすることがないので、コントラクトを続けます。

## コントラクトのテスト
Cordaのコントラクトは、[トランザクション(Tx)の検証](https://docs.corda.net/docs/corda-os/4.8/key-concepts-contracts.html#transaction-verification)の際にトリガーされます。Txは入力でStateを受け取り、含まれる情報が正しいかどうか、コマンドに正しい署名が含まれているかどうかを検証するためにコントラクトを起動します。

<img src="/docs/images/developers/tdd-3.png" style="width:300px;"/>。

### 1. 失敗するユニットテストを作る

さて、ここまではStateだけで、Flowの実装はしていませんでした。どうすればいいのでしょうか？CordaはモックのTxとコマンドを作成するための便利なDSLを提供しています。

つまり、おさらいすると、必要なのは
- 模擬Tx
- Txに渡される状態
- いくつかのシグネチャを入力とするコマンド

そこで、DSLを使ってユニットテストを書いてみましょう。

> MockNetworkについてもっと読む： https://docs.r3.com/en/platform/corda/4.8/open-source/api-testing.html#mocknetwork

```kotlin
class ContractTests {
    private val ledgerServices: MockServices = MockServices(listOf("net.corda.samples.example"))
    private var alice = TestIdentity1(CordaX500Name("Alice", "TestLand", "US"))
    private var bob = TestIdentity1(CordaX500Name("Bob", "TestLand", "US"))

    @Test
    fun testForContract() {
        val state = TemplateState("Hello-World", alice.party, bob.party)
        ledgerServices.ledger {
            transaction {
                //passing transaction
                input(TemplateContract.ID, state)
                output(TemplateContract.ID, state)
                command(bob.publicKey, TemplateContract.Commands.Create())
                verifies()
            }
        }
    }
}
```
このコードは以下の理由でコンパイルされません。
- 現時点では`TemplateState`はAliceとBobのシグネチャを受け取ることができません。これは `var msg:String` を実装しただけなので正常です。
- `TemplateContract` が実装されていないので、その `TemplateContract.ID` も実装されていません。

そこで、`TemplateState`がシグネチャを受け取れるように修正し、必要なインターフェイスやアノテーションを実装しましょう。
```kotlin
@BelongsToContract(TemplateContract::class)
data class TemplateState(val msg: String,
                         val sender: Party,
                         val receiver: Party,
                         override val participants: List<AbstractParty> = listOf(sender,receiver)
) : ContractState
```
そして、2つのことを検証する`TemplateContract`を作ってみましょう。
- トランザクションは1つの出力状態しか持たない
- コマンドと出力状態の署名が同じであること
```kotlin
class TemplateContract : Contract {
    companion object {
        @JvmStatic
        val ID = "net.corda.samples.example.contracts.TemplateContract"
    }

    override fun verify(tx: LedgerTransaction) {
        val command = tx.commands.requireSingleCommand<Commands.Create>()
        requireThat {
            "Only one output state should be created." using (tx.outputs.size == 1)
            val out = tx.outputsOfType<TemplateState>().single()
            "All of the participants must be signers." using (command.signers.containsAll(out.participants.map { it.owningKey }))
        }
    }

    interface Commands : CommandData {
        class Create : Commands
    }
}
```
ここでユニットテストを実行すると、失敗します。
```bash
Contract verification failed: Failed requirement: All of the participants must be signers. 
```
### 2. 通過させる
トランザクションコマンドにalice.publickeyが含まれていないため、コントラクトの検証に失敗します。これで簡単に修正できます。
```kotlin
command(listOf(alice.publicKey, bob.publicKey), TemplateContract.Commands.Create())
```
ユニットテストを再度実行すると、合格します。コントラクト制約が正しく動作することが確認できました。

### 3. リファクタリング
この時点で、TemplateContract.verifyに要件を追加し、それが通るようにユニットテストを実装します。

## フロー
### 1. 失敗するユニットテストを作る
StateとContractの実装が完了したので、フローの記述に進みます。

Corda フローのテストでは、モックされた Corda ネットワークを設定し、モックされた Corda ノ- ドを作成するために、いくつかの初期の定型文が必要です。
```kotlin
class FlowTests {
    private lateinit var network: MockNetwork
    private lateinit var a: StartedMockNode
    private lateinit var b: StartedMockNode

    @Before
    fun setup() {
        network = MockNetwork(MockNetworkParameters(cordappsForAllNodes = listOf(
                TestCordapp.findCordapp("com.template.samples.example.contracts"),
                TestCordapp.findCordapp("com.template.samples.example.flows")
        )))
        a = network.createPartyNode()
        b = network.createPartyNode()
        network.runNetwork()
    }

    @After
    fun tearDown() {
        network.stopNodes()
    }
}
```
次に、AliceとBobの間でTemplateStateを消費するトランザクションを作成するフローを書いてみましょう。
```kotlin
@Test
fun `DummyTest`() {
    val flow = Initiator("Hello, World!", b.info.legalIdentities[0])
    a.startFlow(flow)
    network.runNetwork()

    val inputCriteria: QueryCriteria = QueryCriteria.VaultQueryCriteria().withStatus(StateStatus.UNCONSUMED)
    val state = b.services.vaultService.queryBy(TemplateState::class.java, inputCriteria).states[0].state.data
    assertNotNull(state)
}
```
このコードがコンパイルされないのは、フローを実装していないからです。やってみましょう。
```kotlin
@InitiatingFlow
@StartableByRPC
class Initiator(private val message: String, private val receiver: Party) : FlowLogic<Unit>() {
    
    @Suspendable
    override fun call() {
    }
```
ユニットテストを実行すると、失敗するのがわかります。

### 2. 通過させる
そのためには、実際にフローのコードを書く必要があります。
<details>
  <summary>See the code</summary>
<p>

```kotlin
@InitiatingFlow
@StartableByRPC
class Initiator(private val message: String, private val receiver: Party) : FlowLogic<SignedTransaction>() {
    override val progressTracker = ProgressTracker()

    @Suspendable
    override fun call(): SignedTransaction {
        //Hello World message
        val msg = message
        val sender = ourIdentity

        // Step 1. Get a reference to the notary service on our network and our key pair.
        // Note: ongoing work to support multiple notary identities is still in progress.
        val notary = serviceHub.networkMapCache.notaryIdentities[0]

        //Compose the State that carries the Hello World message
        val output = TemplateState(msg, sender, receiver)

        // Step 3. Create a new TransactionBuilder object.
        val builder = TransactionBuilder(notary)
                .addCommand(TemplateContract.Commands.Create(), listOf(sender.owningKey, receiver.owningKey))
                .addOutputState(output)

        // Step 4. Verify and sign it with our KeyPair.
        builder.verify(serviceHub)
        val ptx = serviceHub.signInitialTransaction(builder)


        // Step 6. Collect the other party's signature using the SignTransactionFlow.
        val otherParties: MutableList<Party> = output.participants.stream().map { el: AbstractParty? -> el as Party? }.collect(Collectors.toList())
        otherParties.remove(ourIdentity)
        val sessions = otherParties.stream().map { el: Party? -> initiateFlow(el!!) }.collect(Collectors.toList())

        val stx = subFlow(CollectSignaturesFlow(ptx, sessions))

        // Step 7. Assuming no exceptions, we can now finalise the transaction
        return subFlow<SignedTransaction>(FinalityFlow(stx, sessions))
    }
}
```
</p>
</details>

### 3. リファクタリング
コードの一部をリファクタリングすることで、コードをよりクリーンにすることができます。また、ユニットテストを行うことで、自分が壊しているかどうかを把握することができます。

## 結論
テスト駆動開発では、よりクリーンで保守性の高いコードを書くことができるだけでなく、ユニットテストや統合テストを書くために Corda core が提供するライブラリを利用することができます。