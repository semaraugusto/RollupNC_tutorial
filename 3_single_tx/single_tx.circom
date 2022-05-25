pragma circom 2.0.3;
include "./merkle.circom";
include "./eddsa.circom";
include "./poseidon.circom";

// k is depth of accounts tree
template ProcessTx(k){

    // accounts tree info
    signal input accounts_root;
    signal input intermediate_root;
    signal input accounts_pubkeys[2**k][2];
    signal input accounts_balances[2**k];

    // transactions info
    signal input sender_pubkey[2];
    signal input sender_balance;
    signal input receiver_pubkey[2];
    signal input receiver_balance;
    signal input amount;
    signal input signature_R8x;
    signal input signature_R8y;
    signal input signature_S;
    signal input sender_proof[k];
    signal input sender_proof_pos[k];
    signal input receiver_proof[k];
    signal input receiver_proof_pos[k];

    // output signal output new_accounts_root;
    // verify sender account exists in accounts_root
    component senderExistence = GetMerkleRoot(k, 3);

    // check that transaction was signed by sender
    component signatureCheck = VerifyEdDSAPoseidon(5);

    // debit sender account and hash new sender leaf
    // check intermediate tree with new sender balance
    component intermediate_tree = GetMerkleRoot(k, 3);

    // verify receiver account exists in intermediate_root
    component receiverExistence = GetMerkleRoot(k, 3);

    // credit receiver account and hash new receiver leaf
    component updated_tree = GetMerkleRoot(k, 3);

    // output final accounts_root
}

component main{public [accounts_root]} = ProcessTx(1);
