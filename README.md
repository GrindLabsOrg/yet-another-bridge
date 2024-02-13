# Yet Another Bridge 🍭


<div align="center">
  <br />
  <br />
  <a href="https://yetanotherswap.com/bridge"><img alt="YAB" src="assets/YAB-header.jpg" width=600></a></a>
  <br />
  <h3><a href="https://yetanotherswap.com/bridge">Yet Another Bridge</a> is the cheapest, fastest and most secure bridge solution from Starknet to Ethereum</h3>
  <br />
</div>

## Ok, but how does it work?

YAB is conformed primarily by 2 Smart Contracts, one Smart Contract on L1 ETH blockchain 
(called [Payment Registry](contracts/solidity/src/PaymentRegistry.sol)), and one Smart 
Contract on L2 Starknet blockchain (called [Escrow](contracts/cairo/src/escrow.cairo)). Another vital entity for 
YAB's functionality is the Market Maker (MM for short).

And, of course, the users.

- To the user, the process is as follows:

    1. The User wants to bridge L2 ETH tokens from Starknet to L1 Ethereum
    2. The User deposits ETH tokens on L2 Escrow, while also sending some extra 
  information; such as where does the user want to receive the money on L1, how much 
  fee does he want to give to the Market Maker, etc. So the User sends to the Escrow 
  the amount plus a fee
    3. The User receives in his L1 wallet a transaction of the amount sent to Escrow 
  from a Payment Registry's address

    Done, the User has bridged tokens from L2 to L1, in the time it takes to complete 
    2 simple transactions.

- For an MM, the process is as follows:

    1. The MM holds his ETH tokens on his own private L1 wallet
    2. The MM monitors Escrow's activity logs and events, to detect any Users wanting 
  to bridge tokens
    3. MM detects a User that has transferred ETH tokens to L2 Escrow, and decides 
  the amount to bridge with the transfer fee is acceptable
    4. MM sends the ETH tokens on L1 to Payment Registry, specifying the User's orderID, 
  L1 recipient address and amount.
    5. Then, Payment Registry sends the ETH tokens to the User, and proves to the Escrow 
  contract, either using the messaging system or storage proofs, that the User has 
  received the appropriate funds.
    6. Escrow validates the proof, and sends the ETH Tokens (plus fees) to MM's 
  L2 wallet.

  Done, MM has sent ETH to a L1 address, and received same ETH plus fees on L2.

The whole process is shown in the following diagram:

![YAB-diagram](assets/YAB-diagram.png)

## Risks

### User

For the user, the only risk is the existence of a bug in the code of the smart contracts.
This risk is mitigated by having very simple, and thoroughly tested, smart contracts.

### Market Makers

The risk taken by market makers is the same as by the users, plus the fact that in the
end, MM will end up with its value in a L2; which are less battle-tested and have fewer
guarantees.

Additionally, since the capital is locked for a short period of time, the associated 
risks are mitigated. By minimizing the value held within the smart contracts, this 
becomes less appealing as a target to potential attackers, thereby significantly 
reducing its attractiveness as a potential exploit.

# This Project

In this repo you will find both Smart Contracts, L1 [Payment Registry contract](contracts/solidity/src/PaymentRegistry.sol) 
(written in Solidity) and L2 [Escrow contract](contracts/cairo/src/escrow.cairo) (written in Cairo), and an MM-bot 
(written in Python).

Both the [contracts](contracts/README.md) and the [MM-bot](mm-bot/README.md) have their own README, to deploy and 
use them correctly.

## Prerequisites

To make this project work, you must have installed the following:

- Python: to execute MM-bot
- Scarb: Cairo and Starknet toolchain
- Starkli: CLI tool for interacting with Starknet blockchain
- Starknet Foundry: for building, testing and developing Starknet contracts
- Ethereum Foundry: for building, testing and developing Ethereum contracts

All these are installed with `make deps`.

## Escrow

[Escrow](contracts/cairo/src/escrow.cairo) is a Smart Contract written in Cairo that resides in Ethereum's L2 Starknet.

This contract is responsible for receiving Users' payments in L2, and liberating them 
to the MM when, and only when, the MM has proved the L1 payment.

This contract has a storage of all orders. When a new order is made, by calling the 
`set_order` function, this contract reads the new order's details, verifies the Order 
is acceptable, and if so, it stores this data and accepts from the sender the 
appropriate amount of tokens. An Order's details are: the address where the User wants 
to receive the transaction on L1, the amount he wants to receive, and the amount he is 
willing to give the MM to concrete the bridge process.

Once Escrow has accepted the new order, it will emit a `SetOrder` event, containing 
this information so that MMs can decide if they want to accept this offer.

The user must wait until an MM picks its order, which should be almost instantaneous 
if the transfer fee is the suggested one.

After an MM consolidates an order, Escrow will receive a `claim_payment` call from 
Payment Registry, containing the information about how MM has indeed bridged the funds 
to the User's L1 address, and where does MM want to receive it's L2 tokens. Escrow 
will then cross-check this information to its own records, and if everything is in 
check, Escrow will transfer the bridged amount of tokens, plus the fee, to MM's L2 
address.

## Payment Registry

[Payment Registry](contracts/solidity/src/Payment Registry.sol) is a Smart Contract that resides in Ethereum's L1, responsible for 
receiving MM's transaction on L1, forwarding it to the User's address, and sending 
the information of this transaction to Escrow.

So, when MM wants to complete an order it has read on Escrow, it will call the 
`transfer` function from Payment Registry, containing the relevant information 
(orderID, User's address on L1, and amount). Payment Registry will verify the information 
is acceptable, store it, and send the desired amount to User's L1 address.

After this transfer is completed, MM must call `claimPayment` on Payment Registry to 
receive back the initial deposit made by the User, so that Payment Registry can verify 
MM has previously sent the order's amount to the User. If it has, this same function will 
call Escrow's `claim_payment`, informing Escrow that MM has indeed bridged funds for User, 
and that he wants to receive back his amount on L2. Then, as mentioned before, Escrow will 
release MM's funds to his desired L2 address.

## MM-bot

[MM-bot](mm-bot/src/main.py) is a bot responsible for being a YAB's market maker.

When run, MM-bot constantly reads Escrow's events and stores them in its own database; 
With this, the bot can detect almost instantaneously when a user creates a new order, 
allowing it to be the one who bridges the tokens for the user.

It reads every new order's information, analyzes if it capable of completing such 
order, and, if so, it makes the transfer to Payment Registry using the funds available 
on its L1 address. After this transfer is complete, MM-bot will execute the appropriate 
payment claim so that it can receive back its tokens on L2.

MM-bot has a L1 address to transfer funds to user through Payment Registry (as stated above), 
and a L2 address to receive the L2 tokens after successfully completing the bridge.
