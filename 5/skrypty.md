# `/user`

### `/user/flake.nix`
```nix
{
  description = "Node.js secp256k1 development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "node-secp256k1-shell";

          packages = with pkgs; [
            nodejs_20
            nodePackages.npm
            nodePackages.pnpm
            nodePackages.yarn
          ];

          shellHook = ''
            echo "🔐 Node.js secp256k1 dev shell"
            echo "Node version: $(node --version)"
          '';
        };
      }
    );
}

```

### `/user/package.json`
```json
{
  "type": "module",
  "dependencies": {
    "@noble/secp256k1": "^3.0.0",
    "circomlibjs": "^0.1.7"
  }
}

```

### `/user/generate_keyPair.js`
```javascript
import * as secp from '@noble/secp256k1';
import { createHash, createHmac, randomBytes } from 'crypto';

// ---- REQUIRED SETUP ----
secp.hashes.sha256 = (msg) =>
    createHash('sha256').update(msg).digest();

secp.hashes.hmacSha256 = (key, msg) =>
    createHmac('sha256', key).update(msg).digest();

secp.utils.randomBytes = randomBytes;
// ------------------------

const Uint8ArrayToHex = v => Buffer.from(v).toString('hex');

// Generate keypair
const privKey = randomBytes(32);
console.log("privKey", privKey.toString('hex'),);
const pubKey = secp.getPublicKey(privKey);
console.log("pubKey", Uint8ArrayToHex(pubKey));

// Sign
const message = Buffer.from('hello secp256k1');
console.log("message", message.toString());
const sig = await secp.sign(message, privKey);
console.log("sig", Uint8ArrayToHex(sig));

// Verify
const ok = secp.verify(sig, message, pubKey);
console.log("ok", ok);
```

### `/user/admin_generate_users.js`
```javascript
import * as secp from '@noble/secp256k1';
import { createHash, createHmac, randomBytes } from 'crypto';

// ---- REQUIRED SETUP ----
secp.hashes.sha256 = (msg) =>
    createHash('sha256').update(msg).digest();

secp.hashes.hmacSha256 = (key, msg) =>
    createHmac('sha256', key).update(msg).digest();

secp.utils.randomBytes = randomBytes;
// ------------------------

const Uint8ArrayToHex = v => Buffer.from(v).toString('hex');

//================================================================
//Admin

const admin_privateKey = Buffer.from('d0ebe3276e1a9a87ab5c183aa76099578963f5053fcfcdf2492b5382838c158a', 'hex');
const admin_publicKey = secp.getPublicKey(admin_privateKey);

//================================================================
//Users

const userNames = ["Alicja", "Adam", "Ewa", "Wiktor", "Peggy"];

for (const name of userNames){
    //print name
    console.log("name:", name);
    
    //generate keypair
    const privateKey = randomBytes(32);
    console.log("privKey:", privateKey.toString('hex'),);
    const publicKey = secp.getPublicKey(privateKey);
    console.log("pubKey:", Uint8ArrayToHex(publicKey));

    //permissions
    const permissions = 32 | 16 | 8 | 4 | 2 | 1;
    console.log("permissions:", permissions);

    //construct hash
    let message = {
        name: name,
        publicKey: Uint8ArrayToHex(publicKey),
        permissions: permissions
    };
    console.log("message:", message);
    message = Buffer.from(JSON.stringify(message));
    //const hash = createHash('sha256').update(message).digest('hex');
    //console.log("messageHash:", hash);

    //admin sign
    const signature = await secp.sign(message, admin_privateKey);
    console.log("signature:", Uint8ArrayToHex(signature));

    //verify
    const ok = secp.verify(signature, message, admin_publicKey);
    console.log("Verification:", ok);
    
    console.log("==================================")
};
```

### `/user/alice_sign_attachments.js`
```javascript
import * as secp from '@noble/secp256k1';
import { createHash, createHmac, randomBytes } from 'crypto';
import fs from "fs";

// change this to your file

function hashFile(filePath) {
  return new Promise((resolve, reject) => {
    const hash = createHash("sha256");
    const stream = fs.createReadStream(filePath);

    stream.on("error", reject);
    stream.on("data", chunk => hash.update(chunk));
    stream.on("end", () => resolve(hash.digest("hex")));
  });
}

// ---- REQUIRED SETUP ----
secp.hashes.sha256 = (msg) =>
    createHash('sha256').update(msg).digest();

secp.hashes.hmacSha256 = (key, msg) =>
    createHmac('sha256', key).update(msg).digest();

secp.utils.randomBytes = randomBytes;
// ------------------------

const Uint8ArrayToHex = v => Buffer.from(v).toString('hex');

//================================================================
//Alice

const alice_privateKey = Buffer.from('8dfc2aab04a48914bee1fef90f5357f9120651f172d879ea29fd2222cf8b72dc', 'hex');
const alice_publicKey = secp.getPublicKey(alice_privateKey);
console.log("Alice's public key:", Uint8ArrayToHex(alice_publicKey))
console.log("==================================")

const filesToSign = [
    {
        publicAddress: "https://raw.githubusercontent.com/REDACTED_USERNAME/bsd_lab/refs/heads/master/5/attachments/majster.jpg",
        localAddress: "../attachments/majster.jpg"
    },{
        publicAddress: "https://raw.githubusercontent.com/REDACTED_USERNAME/bsd_lab/refs/heads/master/5/attachments/readme.md",
        localAddress: "../attachments/readme.md"
    }
];

//================================================================
//Signing

for (const file of filesToSign){
    const hash = await hashFile(file.localAddress);
    let message = {
        hash: hash,
        address: file.publicAddress
    };
    console.log("message:", message);
    message = Buffer.from(JSON.stringify(message));

    //alice sign
    const signature = await secp.sign(message, alice_privateKey);
    console.log("signature:", Uint8ArrayToHex(signature));

    //verify
    const ok = secp.verify(signature, message, alice_publicKey);
    console.log("Verification:", ok);
    
    console.log("==================================")
}

```

### `/user/alice_sign_poll.js`
```javascript
import * as secp from '@noble/secp256k1';
import { createHash, createHmac, randomBytes } from 'crypto';

// ---- REQUIRED SETUP ----
secp.hashes.sha256 = (msg) =>
    createHash('sha256').update(msg).digest();

secp.hashes.hmacSha256 = (key, msg) =>
    createHmac('sha256', key).update(msg).digest();

secp.utils.randomBytes = randomBytes;
// ------------------------

const Uint8ArrayToHex = v => Buffer.from(v).toString('hex');

const SerializeBigInt = v => v.toString();

//================================================================
//Alice

const alice_privateKey = Buffer.from('8dfc2aab04a48914bee1fef90f5357f9120651f172d879ea29fd2222cf8b72dc', 'hex');
const alice_publicKey = secp.getPublicKey(alice_privateKey);
console.log("Alice's public key:", Uint8ArrayToHex(alice_publicKey))
console.log("==================================")

const poll = {
    name: "my-first-anon-poll",
    start: null,
    end: null,
    attachments:[
        {
            hash: '7aadde35111e11442c89ee7ea02e191c5bcca18218ef6955feedb54b45be4f23',
            address: 'https://raw.githubusercontent.com/REDACTED_USERNAME/bsd_lab/refs/heads/master/5/attachments/majster.jpg'
        },{
            hash: '2b8244fd9086fc945a340b85f28ab7f759351715f07479ee887c2fea98f8870e',
            address: 'https://raw.githubusercontent.com/REDACTED_USERNAME/bsd_lab/refs/heads/master/5/attachments/readme.md'
        }
    ],
    members:[
        "0326605e51658dacbcae40879a3e999d81fe01c352948347205c7de5484f923426",
        "020340726a7434cb3cf0e4a32b546497079330145525d52c0fee38d48df384a282",
        "024e747154f1843e8e24b750e6ac3f96b9206ed98a7fa13585321031f1d8019fdb",
        "03b7e0e0383a0908ab0c33fb6b00519ad78312c8f2a15e8d6ea8671f500e47eddd",
        "021435d498cbe86ad67a8b62b768197543e88f3330c054f358ad153ec5fb898b70"
    ],
    options:[
        {
            name: "Jabłkowy",
            minimumValue: SerializeBigInt(0n),
            maximumValue: SerializeBigInt(0n)
        },{
            name: "Pomarańczowy",
            minimumValue: SerializeBigInt(1n),
            maximumValue: SerializeBigInt(1n)
        },{
            name: "Marchewkowy",
            minimumValue: SerializeBigInt(2n),
            maximumValue: SerializeBigInt(2n)
        },{
            name: "nie wiem, ale napewno dobry.",
            minimumValue: SerializeBigInt(3n),
            maximumValue: SerializeBigInt(3n)
        },{
            name: "nie głosuj na tą opcje bo będziesz miał koszmary.",
            minimumValue: SerializeBigInt(4n),
            maximumValue: SerializeBigInt(4n)
        },{
            name: "Waniliowy",
            minimumValue: SerializeBigInt(5n),
            maximumValue: SerializeBigInt(5n)
        },{
            name: "Tajemna Opcja - nie ufaj readme.md",
            minimumValue: SerializeBigInt(7n),
            maximumValue: SerializeBigInt(10n)
        }
    ]
};


//================================================================
//Signing


let message = poll;
console.log("message:", message);
message = Buffer.from(JSON.stringify(message));

//alice sign
const signature = await secp.sign(message, alice_privateKey);
console.log("signature:", Uint8ArrayToHex(signature));

//verify
const ok = secp.verify(signature, message, alice_publicKey);
console.log("Verification:", ok);

//generate poll hash
const hash = createHash('sha256').update(message).digest('hex');
console.log("hash:", hash);

```

### `/user/generate_entries.js`
```javascript
import * as secp from '@noble/secp256k1';
import { createHash, createHmac, randomBytes } from 'crypto';
import { buildPoseidon } from "circomlibjs";

// ---- REQUIRED SETUP ----
secp.hashes.sha256 = (msg) =>
    createHash('sha256').update(msg).digest();

secp.hashes.hmacSha256 = (key, msg) =>
    createHmac('sha256', key).update(msg).digest();

secp.utils.randomBytes = randomBytes;
// ------------------------

async function poseidonHash2(a, b) {
    const poseidon = await buildPoseidon();

    // Inputs must be BigInt
    const inputs = [BigInt(a), BigInt(b)];

    const hash = poseidon(inputs);

    // Convert result to BigInt
    const hashBigInt = poseidon.F.toObject(hash);

    return hashBigInt;
}

const Uint8ArrayToHex = v => Buffer.from(v).toString('hex');

const SerializeBigInt = v => v.toString();

//================================================================
//Users

const users = [
    {
        //Alicja
        privateKey: "8dfc2aab04a48914bee1fef90f5357f9120651f172d879ea29fd2222cf8b72dc",
        s: 123n,
        k: 456n
    },{
        //Adam
        privateKey: "91de483be3a69963953ff3c557feeda1a44cbec64b59b544cbc734ee992fe8f4",
        s: 321n,
        k: 654n
    },{
        //Ewa
        privateKey: "78fa750061d1dec95949ae3e64e36b2966f2bdbd0bfc55ad97536b6f7e32a813",
        s: 345n,
        k: 357n
    },{
        //Wiktor
        privateKey: "92a3d644990929657cd9514a444482b907d59b5425bf992c3e3154217605e5d5",
        s: 11,
        k: 11
    },{
        //Peggy
        privateKey: "665ff0478cf3190c22acff57c8ddfeb004891553c0028297467a9505e741f031",
        s: 13,
        k: 18
    }
]; 

const pollHash = "832f4e8e2ba8f691f1c48eee4d6fb502783d92b8a2a5a43efab5a7e4d40b07bb";

//================================================================
//Generating entries

let previousBlockHash = null;
let i = 0;
for (const user of users){
    console.log("==============================================");

    //reconstruct keys
    const privateKey = Buffer.from(user.privateKey, 'hex');
    const publicKey = secp.getPublicKey(privateKey);
    console.log("publicKey:", Uint8ArrayToHex(publicKey));

    //generate hash
    const hash = await poseidonHash2(user.s, user.k);

    //construct message
    let message = {
        index: i++,
        hash: SerializeBigInt(hash),
        previousEntry: previousBlockHash,
        pollHash: pollHash
    };
    console.log("message:", message);
    const messageToSign = Buffer.from(JSON.stringify(message));
    
    //hash for sql
    console.log("HEX(BIGNUMBER(message.hash)):", hash.toString(16).padStart(64, "0"));

    //sign
    const signature = await secp.sign(messageToSign, privateKey);
    console.log("signature:", Uint8ArrayToHex(signature));
    
    //verify
    const ok = secp.verify(signature, messageToSign, publicKey);
    console.log("Verification:", ok);

    //form block
    message = Buffer.from(JSON.stringify([message, Uint8ArrayToHex(signature)]));
    previousBlockHash = createHash('sha256').update(message).digest('hex');
    console.log("blockHash:", previousBlockHash);

}
```

# `/proof`

### `/proof/flake.nix`
```nix
{
    description = "Universal Node.js + npm development environment";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
        let
            pkgs = import nixpkgs { inherit system; };
            circomlib = pkgs.fetchFromGitHub {
                owner = "iden3";
                repo = "circomlib";
                rev = "master";
                sha256 = "sha256-TK/u5NY+ZTZRFWO1loMeYKbR5L6WHvpTgSZiiY8F3kE=";
            };
        in
        {
            devShells.default = pkgs.mkShell {
                buildInputs = [
                    pkgs.circom
                    pkgs.nodejs_22  # includes npm
                ];
                shellHook = ''
                    mkdir -p .nix-bin

######################################################
                    cat > .nix-bin/snarkjs << 'EOF'
#!/usr/bin/env bash
# Forward everything to npx snarkjs
npx snarkjs "$@"
EOF
                    chmod +x .nix-bin/snarkjs
######################################################
                    export PATH="$PWD/.nix-bin:$PATH"
                    export CIRCOMLIB_PATH="${circomlib}"
                    if [ ! -L circomlib ]; then
                        echo "Linking circomlib → ${circomlib}"
                        ln -sfn ${circomlib} circomlib
                    fi
######################################################
                    echo "Node $(node -v)"
                    echo "npm $(npm -v)"
                    echo "snarkjs $(which snarkjs)"
                    echo "CIRCOMLIB_PATH = $CIRCOMLIB_PATH"
                '';
            };
        }
    );
}

```

### `/proof/package.json`
```json
{
  "type": "module",
  "dependencies": {
    "@noble/secp256k1": "^3.0.0",
    "circomlibjs": "^0.1.7"
  }
}

```

### `/proof/circuit.circom`
```circom
//================================================================
//Circom

pragma circom 2.0.0;

//================================================================
//Requirements

//for example constraint: 69 is illegal
include "circomlib/circuits/comparators.circom";

//Merkle Tree
include "circomlib/circuits/bitify.circom";
include "circomlib/circuits/poseidon.circom";

//================================================================
//Operations

//...

//================================================================
//Main

template MainCircuit(merkle_level_count) {
    //input vote value (bind)
    signal input vote;
    
    //input entry
    signal input s;
    signal input k;

    //input DB (shortcut via Merkle Proof)
    signal input entry_index;
    signal input merkle_leafs[merkle_level_count];

    //input previous_vote (bind)
    signal input previous_vote;
    
    //================================================================
    //
    // Here constrains/zk-processing should be put 
    //
    //================================================================
    
    //================================================================
    //example constraint: 69 is illegal
    
    component c1 = IsEqual();               //circuit taken from circomlib
    c1.in[0] <== vote;
    c1.in[1] <== 69;
    c1.out === 0;       //this makes sure vote cannot be 69 (as an example)
    
    //circuits source code: https://github.com/iden3/circomlib/blob/master/circuits/comparators.circom
    //================================================================

    //================================================================
    //Merkle Proof
    
    //get element (end leaf) path
    component bits = Num2Bits(merkle_level_count);
    bits.in <== entry_index;

    //computation parts
    component ph_left[merkle_level_count];
    component ph_right[merkle_level_count];
    signal ph_add_left[merkle_level_count];
    signal ph_add_right[merkle_level_count];
    signal ph_next[merkle_level_count + 1];

    //define first root:    
    component entry = Poseidon(2);
    entry.inputs[0] <== s;
    entry.inputs[1] <== k;
    ph_next[0] <== entry.out;

    //blind computation of the merkle tree root
    for (var i = 0; i < merkle_level_count; i++){
        //left
        ph_left[i] = Poseidon(2);
        ph_left[i].inputs[0] <== merkle_leafs[i];
        ph_left[i].inputs[1] <== ph_next[i];
        
        //right
        ph_right[i] = Poseidon(2);
        ph_right[i].inputs[0] <== ph_next[i];
        ph_right[i].inputs[1] <== merkle_leafs[i];
        
        //next
        ph_add_left[i] <== ph_left[i].out * bits.out[i];
        ph_add_right[i] <== ph_right[i].out * (1 - bits.out[i]);
        ph_next[i + 1] <== ph_add_left[i] + ph_add_right[i];
    }

    //================================================================


    //output vote   (copy)
    signal output vote_value <== vote;

    //output the calculated merkle root
    signal output vote_entries_root <== ph_next[merkle_level_count];

    //output nullifier (copy)
    signal output vote_nullifier <== k;

    //output previous vote  (copy)
    signal output vote_previous_vote <== previous_vote;
}

//  P-Tau requirements for MainCircuit(10):
//      non-linear constraints: 5134
//      linear constraints: 5767
//      public inputs: 0
//      private inputs: 15 (12 belong to witness)
//      public outputs: 4
//      wires: 10916
//      labels: 16175

// Example used:
// Max number of voters: 2 ** 3 = 8
component main = MainCircuit(3);
```

### `/proof/generate_proof.js`
```javascript

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
```