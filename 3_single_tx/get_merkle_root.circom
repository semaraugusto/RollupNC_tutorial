pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

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

// Verifies that merkle proof is correct for given merkle root and a leaf
// pathIndices input is an array of 0/1 selectors telling whether given pathElement is on the left or right side of merkle path
template LeafExistance(levels) {
    signal input leaf;
    signal input pathElements[levels];
    signal input pathIndices[levels];
    signal input root;
    signal output out;

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

    out <== hashers[levels - 1].hash
    // verify that the resultant hash (computed merkle root)
    // is in the set of roots
    /* component set = SetMembership(length); */
    /* set.element <== hashers[levels - 1].hash; */
    /* for (var i = 0; i < length; i++) { */
    /*     set.set[i] <== roots[i]; */
    /* } */
    /* set.out === 1; */
    /* out <== 1; */
}

component main = ManyMerkleTreeChecker(2, 2);
/* template GetMerkleRoot(k){ */
/* // k is depth of tree */
/**/
/*     signal input leaf; */
/*     signal input paths2_root[k]; */
/*     signal input paths2_root_pos[k]; */
/**/
/*     signal output out; */
/**/
/*     // hash of first two entries in tx Merkle proof */
/*     component merkle_root[k]; */
/*     merkle_root[0] = MultiMiMC7(2,91); */
/*     merkle_root[0].in[0] <== paths2_root[0] - paths2_root_pos[0]* (paths2_root[0] - leaf); */
/*     merkle_root[0].in[1] <== leaf - paths2_root_pos[0]* (leaf - paths2_root[0]); */
/**/
/*     // hash of all other entries in tx Merkle proof */
/*     for (var v = 1; v < k; v++){ */
/*         merkle_root[v] = MultiMiMC7(2,91); */
/*         merkle_root[v].in[0] <== paths2_root[v] - paths2_root_pos[v]* (paths2_root[v] - merkle_root[v-1].out); */
/*         merkle_root[v].in[1] <== merkle_root[v-1].out - paths2_root_pos[v]* (merkle_root[v-1].out - paths2_root[v]); */
/**/
/*     } */
/**/
/*     // output computed Merkle root */
/*     out <== merkle_root[k-1].out; */
/**/
/* } */
