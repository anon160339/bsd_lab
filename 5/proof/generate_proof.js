
/*
https://poseidon-online.pages.dev/
r
   1       2
 x   y   z   w
1 2 3 4 5 6 7 8


xyzw:
7853200120776062878684798364095072458815029376092732009249414926327459813530
14763215145315200506921711489642608356394854266165572616578112107564877678998
1879402270149794212432036740081454186623842057661213288749068713224962094903
19419916100242727769718322657520778503680617689214632373938093157277816551712

12:
3330844108758711782672220159612173083623710937399719017074673646455206473965
14693904821945502268578313651525098196765636411922213115469821563817117273617

4,x,2:
4,7853200120776062878684798364095072458815029376092732009249414926327459813530n,14693904821945502268578313651525098196765636411922213115469821563817117273617n

7,z,1:
7,
1879402270149794212432036740081454186623842057661213288749068713224962094903n,
3330844108758711782672220159612173083623710937399719017074673646455206473965n

1,y,2
1,14763215145315200506921711489642608356394854266165572616578112107564877678998n,14693904821945502268578313651525098196765636411922213115469821563817117273617n,

r:
14629452129687363793084585378194807561782241384488665279773588974567494940279

*/

const votesSequence = [2, 4, 1, 0, 3] //pure randomness
const votes = [
    {
        //Alicja
        vote: 5n,
        s: 123n,
        k: 456n,
        entry_index: 0,
        merkle_leafs: [
            9051922361319954272403172740714292002550212200426269551764287908424859351883n,
            20834659803249070692757179431947800864861539131724928192328181380290181268458n,
            12926273887286769764467998999544163914307559922216585524378099580891955033415n
        ],
        previous_vote: 0n
    },{
        //Adam
        vote: 1n,
        s: 321n,
        k: 654n,
        entry_index: 1n,
        merkle_leafs: [
            19620391833206800292073497099357851348339828238212863168390691880932172496143n,
            20834659803249070692757179431947800864861539131724928192328181380290181268458n,
            12926273887286769764467998999544163914307559922216585524378099580891955033415n
        ],
        previous_vote: 0n
    },{
        //Ewa
        vote: 5n,
        s: 345n,
        k: 357n,
        entry_index: 2n,
        merkle_leafs: [
            7020003394394666990960673981134349377535980189597271278044812177123909403151n,
            14773286974096855589808739694181791015827463825449008199871790464929355935269n,
            12926273887286769764467998999544163914307559922216585524378099580891955033415n
        ],
        previous_vote: 0n
    },{
        //Wiktor
        vote: 5n,
        s: 11n,
        k: 11n,
        entry_index: 3n,
        merkle_leafs: [
            10540957019918467923199933588039634723571444319347712217290279586026394524342n,
            14773286974096855589808739694181791015827463825449008199871790464929355935269n,
            12926273887286769764467998999544163914307559922216585524378099580891955033415n
        ],
        previous_vote: 0n
    },{
        //Peggy
        vote: 3n,
        s: 13n,
        k: 18n,
        entry_index: 4n,
        merkle_leafs: [
            0n,
            14744269619966411208579211824598458697587494354926760081771325075741142829156n,
            13913873313840280729968880454698485487134798372912380218748403578357741578591n
        ],
        previous_vote: 0n
    }
];
//example command: `node gen_proof.js 1 2 3 4 5 6`
(async () => {
    const snarkjs = require('snarkjs');
    const fs = require('fs');
    const buildPoseidon = require('circomlibjs').buildPoseidon;
    const poseidon = await buildPoseidon();
    const F = poseidon.F;

    //poseidon hashes here
    let lastBlockHash = 0n;

    //verification
    const vKey = JSON.parse(fs.readFileSync('circuit_verifier.json'));

    //generate proofs
    for(let i = 0; i < votesSequence.length; i++){
        console.log("================================================================");
        //get proof inputs
        const proofInput = votes[votesSequence[i]];
        //add previous block
        proofInput.previous_vote = lastBlockHash;
        
        //create proof
        const {proof, publicSignals} = await snarkjs.groth16.fullProve(
            proofInput,
            'circuit_js/circuit.wasm',
            'circuit_prover.zkey'
        );

        //log
        console.log('Proof: ', proof);
        console.log('Public Signals: ', publicSignals);
        console.log("merkle root in hex:", BigInt(publicSignals[1]).toString(16).padStart(64, "0"));

        //verify
        const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);
        console.log("Verification:", res);

        //form next block (mod p)
        const proofInputs = [
            ...proof.pi_a.map(BigInt),
            ...proof.pi_b.flat().map(BigInt),
            ...proof.pi_c.map(BigInt),
            ...publicSignals.map(BigInt)
        ];

        lastBlockHash = F.toObject(poseidon(proofInputs));
        console.log("blockHash:", lastBlockHash);
        console.log("blockHash in hex:", BigInt(lastBlockHash).toString(16).padStart(64, "0"));
    }

    //exit
    process.exit(0);
})();