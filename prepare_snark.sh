set -e 
snarkjs powersoftau new bn128 18 pot18_0000.ptau -v
echo "test" | snarkjs powersoftau contribute pot18_0000.ptau pot18_0001.ptau --name="First Contribution" -v
snarkjs powersoftau prepare phase2 pot18_0001.ptau pot18_final.ptau -v 
