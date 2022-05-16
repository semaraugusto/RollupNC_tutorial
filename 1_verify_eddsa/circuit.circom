include "../circomlib/circuits/eddsamimc.circom";
include "../circomlib/circuits/mimc.circom";

template VerifyEdDSAMiMC(k) {
    signal input from_x;
    signal input from_y;
    signal input R8x;
    signal input R8y;
    signal input S;
    signal input in[k];
    
    component M = MultiMiMC7(k,220);
    // Hash inputs together
    
    component verifier = EdDSAMiMCVerifier();   
    // Add inputs to verifier
}

component main{public[from_x, from_y, R8x, R8y, S]} = VerifyEdDSAMiMC(3);
