if [ -f ./powersOfTau28_hez_final_16.ptau ]; then
    echo "powersOfTau28_hez_final_16.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_16.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_16.ptau
fi

snarkjs powersoftau verify powersOfTau28_hez_final_16.ptau
circom merkle.circom --r1cs --wasm --sym
# snarkjs r1cs info merkle.r1cs
# snarkjs r1cs print merkle.r1cs merkle.sym
# snarkjs r1cs export json merkle.r1cs merkle.r1cs.json
# cat merkle.r1cs.json

node generate_challenge_leaf_existence_input.js
cd merkle_js;
node generate_witness.js merkle.wasm ../input.json ../witness.wtns
cd ..
#
snarkjs groth16 setup merkle.r1cs powersOfTau28_hez_final_16.ptau merkle_0000.zkey
echo "test" | snarkjs zkey contribute merkle_0000.zkey merkle_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey contribute merkle_0001.zkey merkle_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"
snarkjs zkey export bellman merkle_0002.zkey  challenge_phase2_0003
snarkjs zkey bellman contribute bn128 challenge_phase2_0003 response_phase2_0003 -e="some random text"
snarkjs zkey import bellman merkle_0002.zkey response_phase2_0003 merkle_0003.zkey -n="Third contribution name"
snarkjs zkey verify merkle.r1cs powersOfTau28_hez_final_16.ptau merkle_0003.zkey
snarkjs zkey beacon merkle_0003.zkey merkle_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
snarkjs zkey verify merkle.r1cs powersOfTau28_hez_final_16.ptau merkle_final.zkey
snarkjs zkey export verificationkey merkle_final.zkey verification_key.json
snarkjs groth16 prove merkle_final.zkey witness.wtns proof.json public.json
snarkjs groth16 verify verification_key.json public.json proof.json
