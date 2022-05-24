import * as fs from "fs";
// import { buildEddsa, buildPoseidon } from "circomlibjs";
import {
    prv2pub,
    signPoseidon,
} from "../../node_modules/circomlibjs/src/eddsa.js";
import poseidon from "../../node_modules/circomlibjs/src/poseidon.js";
import { BigNumber, utils } from "ethers";

var poseidonHash = async function (items) {
    return BigNumber.from(await poseidon(items));
};
// var hash3 = async function (a, b, c) {
//     return BigNumber.from(poseidon.F.toString(poseidon([a, b, c])));
//     // return BigNumber.from(await poseidon([a, b, c]));
// };
var hash3 = async function (a, b, c) {
    return BigNumber.from(poseidon([a, b, c]));
    // return BigNumber.from(await poseidon([a, b, c]));
};

const leaf = [123, 456, 789];
const msg = await hash3(
    BigNumber.from(123),
    BigNumber.from(456),
    BigNumber.from(789)
);
console.log("leaf: ", leaf);
console.log("HASH: ", msg.toBigInt());
const prvKey = Buffer.from("1".toString().padStart(64, "0"), "hex");
const pubKey = prv2pub(prvKey);

const signature = signPoseidon(prvKey, msg.toBigInt());

const inputs = {
    from_x: pubKey[0].toString(),
    from_y: pubKey[1].toString(),
    R8x: signature.R8[0].toString(),
    R8y: signature.R8[1].toString(),
    S: signature.S.toString(),
    leaf: msg.toString(),
};

fs.writeFileSync("./input.json", JSON.stringify(inputs), "utf-8");
