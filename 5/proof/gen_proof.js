(async () => {
    const snarkjs = require('snarkjs');
    const fs = require('fs');

    const proofInput = {
        vote: 69,
        s: 7,
        k: 3,
        entry_index: 3,
        merkle_leafs: [0,0,0,0,0,0,0,0,0],
        merkle_root: 33,
        previous_vote: 11
    };
    const { proof, publicSignals } = await snarkjs.groth16.fullProve(
    proofInput,
    'circuit_js/circuit.wasm',
    'circuit_prover.zkey'
    );

    console.log('Proof: ', proof);
    console.log('Public Signals: ', publicSignals);

    const vKey = JSON.parse(fs.readFileSync('circuit_verifier.json'));
    const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);
    console.log("Verification result:", res);
})();