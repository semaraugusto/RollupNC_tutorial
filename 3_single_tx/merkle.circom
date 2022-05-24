pragma circom 2.0.0;
/* include "../node_modules/circomlib/circuits/poseidon.circom"; */
include "../node_modules/circomlib/circuits/comparators.circom";
include "./poseidon.circom";

// checks for existence of leaf in tree of depth k

// if s == 0 returns [in[0], in[1]]
// if s == 1 returns [in[1], in[0]]
template DualMux() {
    signal input in[2];
    signal input s;
    signal output out[2]; 

    s * (1 - s) === 0;
    out[0] <== (in[1] - in[0])*s + in[0];
    out[1] <== (in[0] - in[1])*s + in[1];
}

// Verifies that merkle proof is correct for given merkle root and a leaf
// pathIndices input is an array of 0/1 selectors telling whether given pathElement is on the left or right side of merkle path
template GetMerkleRoot(levels, nInputs) {
    signal input leaf[nInputs];
    signal input pathElements[levels];
    signal input pathIndices[levels];
    signal output out;

    component selectors[levels];
    component hashers[levels];

    component M = PoseidonHashT4();
    for (var i = 0; i < nInputs; i++){
        M.inputs[i] <== leaf[i];
    }

    for (var i = 0; i < levels; i++) {
        selectors[i] = DualMux();
        selectors[i].in[0] <== i == 0 ? M.out : hashers[i - 1].hash;
        selectors[i].in[1] <== pathElements[i];
        selectors[i].s <== pathIndices[i];

        hashers[i] = HashLeftRight();
        hashers[i].left <== selectors[i].out[0];
        hashers[i].right <== selectors[i].out[1];
    }
    out <== hashers[levels - 1].hash;
}

template MerkleTreeChecker(levels, nInputs) {
    signal input leaf[nInputs];
    signal input pathElements[levels];
    signal input pathIndices[levels];
    signal input root;
    signal output out;

    component selectors[levels];
    component hashers[levels];

    component M = PoseidonHashT4();
    for (var i = 0; i < nInputs; i++){
        M.inputs[i] <== leaf[i];
    }

    for (var i = 0; i < levels; i++) {
        selectors[i] = DualMux();
        selectors[i].in[0] <== i == 0 ? M.out : hashers[i - 1].hash;
        selectors[i].in[1] <== pathElements[i];
        selectors[i].s <== pathIndices[i];

        hashers[i] = HashLeftRight();
        hashers[i].left <== selectors[i].out[0];
        hashers[i].right <== selectors[i].out[1];
    }
    component is_equal = IsEqual();
    is_equal.in[0] <== hashers[levels-1].hash;
    is_equal.in[1] <== root;
    out <== is_equal.out;
}
