pragma circom 2.0.3;
include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/poseidon.circom";
include "./hasher.circom";

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

template SetMembership(length) {
  signal input element;
  signal input set[length];
  signal output out;
  
  signal diffs[length];
  signal product[length + 1];
  product[0] <== element;

  for (var i = 0; i < length; i++) {
    diffs[i] <== set[i] - element;
    product[i + 1] <== product[i] * diffs[i];
  }
  component is_zero = IsZero();
  is_zero.in <== product[length];
  out <== is_zero.out;
}
// Verifies that merkle proof is correct for given merkle root and a leaf
// pathIndices input is an array of 0/1 selectors telling whether given pathElement is on the left or right side of merkle path
template ManyMerkleTreeChecker(levels, length, nInputs) {
    signal input leaf[nInputs];
    signal input pathElements[levels];
    signal input pathIndices[levels];
    signal input roots[length];
    signal output out;

    component selectors[levels];
    component hashers[levels];

    component leaf_hasher = Poseidon(nInputs);
    for (var i = 0; i < nInputs; i++){
        log(leaf[i]);
        leaf_hasher.inputs[i] <== leaf[i];
    }

    for (var i = 0; i < levels; i++) {
        selectors[i] = DualMux();
        selectors[i].in[0] <== i == 0 ? leaf_hasher.out : hashers[i - 1].hash;
        selectors[i].in[1] <== pathElements[i];
        selectors[i].s <== pathIndices[i];

        hashers[i] = HashLeftRight();
        hashers[i].left <== selectors[i].out[0];
        hashers[i].right <== selectors[i].out[1];
    }

    // verify that the resultant hash (computed merkle root)
    // is in the set of roots
    component set = SetMembership(length);
    set.element <== hashers[levels - 1].hash;
    for (var i = 0; i < length; i++) {
        set.set[i] <== roots[i];
    }
    set.out === 1;
}

component main = ManyMerkleTreeChecker(2, 2, 3);
