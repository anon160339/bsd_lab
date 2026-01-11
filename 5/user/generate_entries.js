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
        privateKey: "8dfc2aab04a48914bee1fef90f5357f9120651f172d879ea29fd2222cf8b72dc",
        s: 123n,
        k: 456n
    },{
        privateKey: "91de483be3a69963953ff3c557feeda1a44cbec64b59b544cbc734ee992fe8f4",
        s: 321n,
        k: 654n
    },{
        privateKey: "78fa750061d1dec95949ae3e64e36b2966f2bdbd0bfc55ad97536b6f7e32a813",
        s: 345n,
        k: 357n
    },{
        privateKey: "92a3d644990929657cd9514a444482b907d59b5425bf992c3e3154217605e5d5",
        s: 11,
        k: 11
    },{
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

    //construct message
    let message = {
        index: i++,
        hash: SerializeBigInt(await poseidonHash2(user.s, user.k)),
        previousEntry: previousBlockHash,
        pollHash: pollHash
    };
    console.log("message:", message);
    const messageToSign = Buffer.from(JSON.stringify(message));
    
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