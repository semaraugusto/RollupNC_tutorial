pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/mimc.circom";

template MiMCHash(nInputs) {
    signal input inputs[nInputs];
    signal output out;

    component hasher = MultiMiMC7(nInputs, 91);
    for (var i = 0; i < nInputs; i ++) {
        hasher.inputs[i] <== inputs[i];
    }
    out <== hasher.out;
}

template HashLeftRight() {
    signal input left;
    signal input right;

    signal output hash;

    component hasher = MiMCHash(2);
    left ==> hasher.inputs[0];
    right ==> hasher.inputs[1];

    hash <== hasher.out;
}
