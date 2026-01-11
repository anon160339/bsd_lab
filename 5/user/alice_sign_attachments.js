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

