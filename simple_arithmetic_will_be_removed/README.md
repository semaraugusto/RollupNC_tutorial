Simple arithmetic constraints

This is a test to see if setup is working on your system
 
```
template SimpleChecks() {
    signal input a;
    signal input b;
    signal input c;
    signal input d;
    signal output out;
    
    // force a + b = c
    a + b === c;

    // force b * c = d
    // fill this in

    // output c + d
    out <== c + d;
}
component main{public[c]} = SimpleChecks();
```


Compile your circuit `circom <circuit_path> --r1cs --wasm --sym`

Generate your input `node generate_circuit_input.js` (generates input.json).

Calculate the witness `node <circuit_name>_js/generate_witness.js <circuit_name>_js/<circuit_name>.wasm input.json witness.json`.

Perform the circuit specific part of the trusted setup to get your zkey and and verification_key.json: 
```
snarkjs groth16 setup <circuit_name>.r1cs ../pot_18_final.ptau <circuit_name>.zkey
snarkjs zkey export verificationkey <circuit_name>.zkey verification_key.json
```
Generate the proof `snarkjs groth 16 prove <circuit_name>.zkey witness.wtns proof.json public.json` .

Verify the proof `snarkjs groth16 verify verification_key.json public.json proof.json`.

[Bonus]
Modify the circuit and input to take in length-4 arrays of a, b, c, and d, and perform the checks in a for loop. Output the sums of c and d arrays. To get you started:
