//example command: `node gen_proof.js 1 2 3 4 5 6`
(async () => {
    const snarkjs = require('snarkjs');
    const fs = require('fs');

    const last_index = process.argv.length - 1;

    const proofInput = {
        vote: process.argv[last_index - 5],
        s: process.argv[last_index - 4],
        k: process.argv[last_index - 3],
        entry_index: process.argv[last_index - 2],
        merkle_leafs: [0,0,0,0,0,0,0,0,0],
        merkle_root: process.argv[last_index - 1],
        previous_vote: process.argv[last_index]
    };
    let proof, publicSignals;
    try{
        const result = await snarkjs.groth16.fullProve(
            proofInput,
            'circuit_js/circuit.wasm',
            'circuit_prover.zkey'
        );
        proof = result.proof;
        publicSignals = result.publicSignals;
    }
    catch(e){
        console.log("FAILED TO CONSTRUCT THE PROOF!!!!!");
        process.exit(1);
    }

    //console.log('Proof: ', proof);
    //console.log('Public Signals: ', publicSignals);

    const vKey = JSON.parse(fs.readFileSync('circuit_verifier.json'));
    const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);
    if(res){
        console.log(proof);
        process.exit(0);
    }
    else{
        console.log("FAILED TO VERIFY THE PROOF!!!!!");
        process.exit(1);
    }
})();