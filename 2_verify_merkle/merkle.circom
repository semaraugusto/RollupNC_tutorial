pragma circom 2.0.0;
include "../../node_modules/circomlib/circuits/poseidon.circom";

// checks for existence of leaf in tree of depth k
template HashLeftRight() {
    signal input left;
    signal input right;

    signal output hash;

    var nInputs = 2;
    component hasher = Poseidon(nInputs);
    left ==> hasher.inputs[0];
    right ==> hasher.inputs[1];

    hash <== hasher.out;
}



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
  
  signal diffs[length];
  signal product[length + 1];
  product[0] <== element;

  for (var i = 0; i < length; i++) {
    diffs[i] <== set[i] - element;
    product[i + 1] <== product[i] * diffs[i];
  }

  product[length] === 0;
}
// Verifies that merkle proof is correct for given merkle root and a leaf
// pathIndices input is an array of 0/1 selectors telling whether given pathElement is on the left or right side of merkle path
template ManyMerkleTreeChecker(levels, length) {
    signal input leaf;
    signal input pathElements[levels];
    signal input pathIndices[levels];
    signal input roots[length];

    component selectors[levels];
    component hashers[levels];

    for (var i = 0; i < levels; i++) {
        selectors[i] = DualMux();
        selectors[i].in[0] <== i == 0 ? leaf : hashers[i - 1].hash;
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
}

component main = ManyMerkleTreeChecker(2, 2);
