alias snarkjs="node ../node_modules/snarkjs/cli.js" 
if [ -f ./powersOfTau28_hez_final_16.ptau ]; then
    echo "powersOfTau28_hez_final_16.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_16.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_16.ptau
fi

# echo "verifying ptau"
# snarkjs powersoftau verify powersOfTau28_hez_final_16.ptau
echo "compiling circom"
circom eddsa.circom --r1cs --wasm --sym
# snarkjs r1cs info eddsa.r1cs
# snarkjs r1cs print eddsa.r1cs eddsa.sym
# snarkjs r1cs export json eddsa.r1cs eddsa.r1cs.json
# cat eddsa.r1cs.json

node generate_input/generate_circuit_input.js
cd eddsa_js;
node generate_witness.js eddsa.wasm ../input.json ../witness.wtns
cd ..
#
snarkjs groth16 setup eddsa.r1cs powersOfTau28_hez_final_16.ptau eddsa_0000.zkey
echo "test" | snarkjs zkey contribute eddsa_0000.zkey eddsa_final.zkey --name="1st Contributor Name" -v
snarkjs zkey verify eddsa.r1cs powersOfTau28_hez_final_16.ptau eddsa_final.zkey
snarkjs zkey export verificationkey eddsa_final.zkey verification_key.json
snarkjs groth16 prove eddsa_final.zkey witness.wtns proof.json public.json
snarkjs groth16 verify verification_key.json public.json proof.json
