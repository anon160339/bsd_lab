#!/usr/bin/env bash
# Already generated ceremonies:
# https://github.com/iden3/snarkjs?tab=readme-ov-file#7-prepare-phase-2
# Fake ceremony:
snarkjs powersoftau new bn128 12 ceremony_phase0.ptau -v 
snarkjs powersoftau contribute ceremony_phase0.ptau ceremony_phase1.ptau --name="First contribution Name" -v -e="Random text 1"
snarkjs powersoftau prepare phase2 ceremony_phase1.ptau ceremony_final.ptau -v