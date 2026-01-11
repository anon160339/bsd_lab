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

