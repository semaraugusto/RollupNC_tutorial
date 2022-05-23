import * as fs from "fs";
import { buildEddsa, buildPoseidon } from "circomlibjs";
import { BigNumber, utils } from "ethers";
// import { BigNumber } from "ethers";
// import { hex2ByteArray } from "../node_modules/snarkjs/src/misc";

const eddsa = await buildEddsa();
const poseidon = await buildPoseidon();

var poseidonHash = async function (items) {
    return BigNumber.from(await poseidon(items));
};
var hash3 = async function (a, b, c) {
    return BigNumber.from(poseidon.F.toString(poseidon([a, b, c])));
    // return BigNumber.from(await poseidon([a, b, c]));
};

const leaf = [123, 456, 789];
const M = await hash3(
    BigNumber.from(123),
    BigNumber.from(456),
    BigNumber.from(789)
);
console.log("leaf: ", leaf);
console.log("HASH: ", M.toBigInt());
const prvKey = Buffer.from("1".toString().padStart(64, "0"), "hex");
const pubKey = await eddsa.prv2pub(prvKey);

console.log("keys: ", prvKey.toString(), pubKey.toString());
console.log("pubkey: ", pubKey[0].toString());
console.log("m: ", typeof M);
const signature = eddsa.signPoseidon(prvKey, utils.arrayify(M.toHexString()));

utils.byte;
const inputs = {
    from_x: [utils.hexlify(pubKey[0])],
    from_y: [utils.hexlify(pubKey[1])],
    R8x: [utils.hexlify(signature["R8"][0])],
    R8y: [utils.hexlify(signature["R8"][1])],
    S: [utils.hexlify(signature["S"])],
    leaf: [leaf],
};

fs.writeFileSync("./input.json", JSON.stringify(inputs), "utf-8");
