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


