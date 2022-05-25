# Verifying an EdDSA Signature

Create a circuit that hashes a private input vec of size k and checks EdDSA signature for this message

Generate input with generate_input/generate_circuit_input.js. Do usual circom prove/verification to make sure its ok. 
We're using circomlib 0.0.8. Make sure to run `yarn` on root directory.

For this part of the assignment you just need to hash the leaf values together and input values correctly to the eddsa signature circuit.
