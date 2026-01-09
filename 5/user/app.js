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
