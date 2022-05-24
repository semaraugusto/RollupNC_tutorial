set -e
alias snarkjs="node /home/semar/Projects/zku/RollupNC_tutorial/3_verify_merkle/node_modules/snarkjs/cli.js" 
if [ -f ../powersOfTau28_hez_final_16.ptau ]; then
    echo "powersOfTau28_hez_final_16.ptau already exists. Skipping."
else
    pushd ../
    echo 'Downloading powersOfTau28_hez_final_16.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_16.ptau
    popd
fi

# echo "verifying ptau"
# snarkjs powersoftau verify powersOfTau28_hez_final_16.ptau
echo "compiling circom"
circom single_tx.circom --r1cs --wasm --sym
# snarkjs r1cs info single_tx.r1cs
# snarkjs r1cs print single_tx.r1cs single_tx.sym
# snarkjs r1cs export json single_tx.r1cs single_tx.r1cs.json
# cat single_tx.r1cs.json

node generate_input/generate_circuit_input.js
cd single_tx_js;
node generate_witness.js single_tx.wasm ../input.json ../witness.wtns
cd ..
#
snarkjs groth16 setup single_tx.r1cs ../powersOfTau28_hez_final_16.ptau single_tx_0000.zkey
echo "test" | snarkjs zkey contribute single_tx_0000.zkey single_tx_final.zkey --name="1st Contributor Name" -v
snarkjs zkey verify single_tx.r1cs ../powersOfTau28_hez_final_16.ptau single_tx_final.zkey
snarkjs zkey export verificationkey single_tx_final.zkey verification_key.json
snarkjs groth16 prove single_tx_final.zkey witness.wtns proof.json public.json
snarkjs groth16 verify verification_key.json public.json proof.json
