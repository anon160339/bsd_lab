#!/usr/bin/env bash
circom circuit.circom --r1cs --sym --wasm
snarkjs groth16 setup circuit.r1cs ceremony_final.ptau circuit_prover.zkey
snarkjs zkey export verificationkey circuit_prover.zkey circuit_verifier.json