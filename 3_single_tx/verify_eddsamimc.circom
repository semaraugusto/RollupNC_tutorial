pragma circom 2.0.3;
include "../node_modules/circomlib/circuits/eddsaposeidon.circom";
include "../node_modules/circomlib/circuits/poseidon.circom";

/* include "../../node_modules/circomlib/circuits/poseidon.circom"; */

template PoseidonHashT4() {
    var nInputs = 3;
    signal input inputs[nInputs];
    signal output out;

    component hasher = Poseidon(nInputs);
    for (var i = 0; i < nInputs; i ++) {
        hasher.inputs[i] <== inputs[i];
    }
    out <== hasher.out;
}

template VerifyEdDSAPoseidon(k) {
    signal input from_x;
    signal input from_y;
    signal input R8x;
    signal input R8y;
    signal input S;
    signal input preimage[k];
    
    component M = PoseidonHashT4();
    for (var i = 0; i < k; i++){
        log(preimage[i]);
        M.inputs[i] <== preimage[i];
    }
    
    component verifier = EdDSAPoseidonVerifier();   
    // Add inputs to verifier
    verifier.enabled <== 1;
    log(from_x);
    log(from_y);
    log(R8x);
    log(R8y);
    log(S);
    verifier.Ax <== from_x;
    verifier.Ay <== from_y;
    verifier.R8x <== R8x;
    verifier.R8y <== R8y;
    verifier.S <== S;
    log(M.out);
    verifier.M <== M.out;
}
