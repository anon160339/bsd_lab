(async () => {
    const snarkjs = require('snarkjs');
    const fs = require('fs');

    const proofInput = {
        a: 6,
        b: 7
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