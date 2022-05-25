# Processing one transaction

One way of implementing rollups is with the use of merkle-trees. This means we can commit the merkle-root to the layer-1 chain and the deltas of the balances of the users instead of submitting each individual transaction to the l1.

Note that you need to copy your solution for eddsa to this directory!

For this rollup implementation, processing a single transaction involves the following tasks:
Assume Alice is the sender and Bob the receiver of this transaction.
* Checking if Alice is in the merkle-tree of accounts that the rollup maintains.
* Checking if message has been signed by Alice
* Debiting Alice's account
* Checking if the intermediate root (the merkle-tree with Alice's account debited and Bob's account unchanged) matches the intermediate root received as input
* Checking if Bob also exists in the merkle-tree of accounts
* Crediting Bob's account.
* Updating merkle-tree state with Alice's account debited and Bob's account credited and output root


To see how multiple transactions would be handled (warning: old version of circom/circomlib) you can check here: 
https://github.com/rollupnc/RollupNC/blob/master/circuits/update_state_verifier.circom
