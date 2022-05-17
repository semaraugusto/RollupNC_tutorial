alias snarkjs="node /home/semar/Projects/zku/RollupNC_tutorial/3_verify_merkle/node_modules/snarkjs/cli.js" 
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau contribute pot12_0001.ptau pot12_0002.ptau --name="Second contribution" -v -e="some random text"
snarkjs powersoftau export challenge pot12_0002.ptau challenge_0003
snarkjs powersoftau challenge contribute bn128 challenge_0003 response_0003 -e="some random text"
snarkjs powersoftau import response pot12_0002.ptau response_0003 pot12_0003.ptau -n="Third contribution name"
snarkjs powersoftau verify pot12_0003.ptau
snarkjs powersoftau beacon pot12_0003.ptau pot12_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"
snarkjs powersoftau prepare phase2 pot12_beacon.ptau pot12_final.ptau -v
snarkjs powersoftau verify pot12_final.ptau
circom circuit.circom --r1cs --wasm --sym
snarkjs r1cs info circuit.r1cs
snarkjs r1cs print circuit.r1cs circuit.sym
snarkjs r1cs export json circuit.r1cs circuit.r1cs.json
cat circuit.r1cs.json
cd circuit_js;

node generate_witness.js circuit.wasm ../input.json ../witness.wtns
cd ..
#
snarkjs groth16 setup circuit.r1cs pot12_final.ptau circuit_0000.zkey
snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v
snarkjs zkey contribute circuit_0001.zkey circuit_0002.zkey --name="Second contribution Name" -v -e="Another random entropy"
snarkjs zkey export bellman circuit_0002.zkey  challenge_phase2_0003
snarkjs zkey bellman contribute bn128 challenge_phase2_0003 response_phase2_0003 -e="some random text"
snarkjs zkey import bellman circuit_0002.zkey response_phase2_0003 circuit_0003.zkey -n="Third contribution name"
snarkjs zkey verify circuit.r1cs pot12_final.ptau circuit_0003.zkey
snarkjs zkey beacon circuit_0003.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
snarkjs zkey verify circuit.r1cs pot12_final.ptau circuit_final.zkey
snarkjs zkey export verificationkey circuit_final.zkey verification_key.json
snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json
snarkjs groth16 verify verification_key.json public.json proof.json
