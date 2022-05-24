pragma circom 2.0.3;
include "../node_modules/circomlib/circuits/eddsaposeidon.circom";
include "./poseidon.circom";

template VerifyEdDSAPoseidon(k) {
    signal input from_x;
    signal input from_y;
    signal input R8x;
    signal input R8y;
    signal input S;
    signal input leaf[k];
    
    component M = PoseidonHash(k);
    for (var i = 0; i < k; i++){
        M.inputs[i] <== leaf[i];
    }
    
    component verifier = EdDSAPoseidonVerifier();   
    // Add inputs to verifier
    verifier.enabled <== 1;
    verifier.Ax <== from_x;
    verifier.Ay <== from_y;
    verifier.R8x <== R8x;
    verifier.R8y <== R8y;
    verifier.S <== S;
    verifier.M <== M.out;
}
