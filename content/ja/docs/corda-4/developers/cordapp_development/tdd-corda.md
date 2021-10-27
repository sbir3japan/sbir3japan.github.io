---
title: "Test Driven Development (TDD) with Corda"
linkTitle: "Tdd Corda"
date: 2021-09-15T12:44:25+09:00
tags: ["開発"]
type: docs
description: >
  Test-driven Development with Corda
---
> **NOTE**: This article is intended for software developers who are already familiar with CorDapp development.

## What is TDD
Test Driven Development (TDD) is an programming style used by professional software developers to write clean, testable and maintenable code. 

### The three laws of TDD
The TDD workflow is simple. Every time you want to add a new functionality, you need to do it in three steps: 
1. write a unit test that fails.
2. Write the code to make it pass.
3. Refactor and add more unit tests.

<img src="/docs/images/developers/tdd-1.png" alt="tdd" style="width:300px;"/>

### Benefits
- Drastic reduction of defects. There are more tests that control every single part of the application.
- Better code architecture design. Developers need to think first about design and its implications.
- Improved code maintainability. Easier and faster to fix bugs, update old functionalities and add new ones. 

### Drawbacks
- Initial learning curve. TDD requires some time to be mastered, but it is taken from the time you would need to debug and fix problems in production. TDD is a always good investment.

### Learn more about TDD
Some useful resources to learn TDD:
- [Uncle Bob's The Three Rules of TDD](http://butunclebob.com/ArticleS.UncleBob.TheThreeRulesOfTdd)
- [Agile Alliance - What is TDD](https://www.agilealliance.org/glossary/tdd/)
- [Kent Beck - Test Driven Development by Example](https://www.amazon.co.jp/-/en/Kent-Beck-ebook/dp/B095SQ9WP4)
- [アジャイルソフトウェア開発](https://ja.wikipedia.org/wiki/%E3%82%A2%E3%82%B8%E3%83%A3%E3%82%A4%E3%83%AB%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2%E9%96%8B%E7%99%BA)

# TDD and Corda in practice
Let's try to develop the [Cordapp Template in kotlin](https://github.com/corda/cordapp-template-kotlin) using TDD. This cordapp will:
- create a state
- make a transaction between PartyA and PartyB to spend this state

## Testing States
### 1. Make a unit test that fails
A best practice in Corda is to always start from the *states*, since they are the smallest application unit.

<img src="/docs/images/developers/tdd-2.png"/>

You don't start by developing the state object, but from its unit test. So, let's write a unit test:
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
At this point you still don't have a `TemplateState.kt`, so this code will not even compile. So, let's make it compile by creating an empty `TemplateState.kt` and then run the unit test to see it fail:
```bash
msg
java.lang.NoSuchFieldException: msg
```
This is an important step to also check that the testing environment is working correctly.

### 2. Make it pass
Making this unit test pass is trivial:
```kotlin
package net.corda.samples.example.states

data class TemplateState(var msg: String)
```
(in Kotlin we will use [Data Classes](https://www.callicoder.com/kotlin-data-classes/#kotlin-data-classes))

If you run the unit test now, it will pass.

As you can see, at this point the state data class does not even implement the `:ContractState` interface nor the annotation `@BelongsToContract(TemplateContract::class)`. This is because we still did not implement the unit test of the contract, so we cannot do it  (of course, once you are familiar with CorDapp development and TDD, you can immediately add those implementations).

### 3. Refactor
There is nothing to do at this moment, so we will continue with the contract.

## Testing contracts
A contract in Corda is triggered during the [transaction (Tx) verification](https://docs.corda.net/docs/corda-os/4.8/key-concepts-contracts.html#transaction-verification). A Tx will receive a State in input and it will trigger its contract to verify that the information contained are correct and the command contains the right signatures. 

<img src="/docs/images/developers/tdd-3.png" style="width:300px;"/>

### 1. Make a unit test that fails

Now, we only have a State so far, we did not implement a Flow. How can we do? Corda provides a helpful DSL to create a mock Tx and commands.

So, to recap, we need:
- a mock Tx
- a state to be passed to the Tx
- a command with some signatures as input

So, we can write the unit test using the DSL this way:

> Read more about MockNetwork: https://docs.r3.com/en/platform/corda/4.8/open-source/api-testing.html#mocknetwork

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

This code does not compile for the following reasons:
- `TemplateState` cannot receive Alice and Bob signatures at the moment. This is normal because we only implementedd `var msg:String`
- `TemplateContract` is not implemented and so its `TemplateContract.ID`

So let's fix `TemplateState` to receive the signatures and implement the necessary interfaces and annotations:
```kotlin
@BelongsToContract(TemplateContract::class)
data class TemplateState(val msg: String,
                         val sender: Party,
                         val receiver: Party,
                         override val participants: List<AbstractParty> = listOf(sender,receiver)
) : ContractState
```
And let's create the `TemplateContract` that verifies two things:
- the transaction has only one output state
- the command and the output state have the same signatures

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
Now run the unit test and it will fail:
```bash
Contract verification failed: Failed requirement: All of the participants must be signers. 
```

### 2. Make it pass
The contract verification fails because we did not include alice.publickey in the transaction command. It can be easily fixed by this:

```kotlin
command(listOf(alice.publicKey, bob.publicKey), TemplateContract.Commands.Create())
```

Run the unit test again and it will pass. We have verified that the contract constraint works correctly.

### 3. Refactor
At this point you can add more requirements in the TemplateContract.verify and implement the unit tests to make them pass.

## Flows
### 1. Make a unit test that fails
Now that State and Contract have been implemented, we can proceed to write the Flow.

Testing a Corda flow requires some initial boilerplate in order to setup a mocked Corda network and create the mocked Corda nodes.

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

Then, let's write a flow that creates a transaction that will spend a TemplateState between Alice and Bob.

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
This code does not compile because we did not implement the flow. Let's do it:

```kotlin
@InitiatingFlow
@StartableByRPC
class Initiator(private val message: String, private val receiver: Party) : FlowLogic<Unit>() {
    
    @Suspendable
    override fun call() {
    }
```


Run the unit test and you will see it fail.

### 2. Make it pass
To achieve this, you have to actually write the code of the flow.

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

### 3. Refactor
You can make the code cleaner now by refactoring some parts with the advantage to have unit tests that will help you understand if you are breaking things or not.

## Conclusion
Test Driven Development allows you to not only write cleaner and more maintainable code, but also to discover the libraries offered by Corda core to write unit and integration tests.