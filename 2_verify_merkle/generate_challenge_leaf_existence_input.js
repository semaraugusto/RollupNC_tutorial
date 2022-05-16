import * as fs from "fs";
import buildMimc7 from "../node_modules/circomlibjs/src/mimc7.js"

let mimcjs = await buildMimc7();
// import mimcMerkle from "MiMCMerkle.js";
// const mimcMerkle = require('./MiMCMerkle.js')

const leaf1 = mimcjs.multiHash([1,2,3])
const leaf2 = mimcjs.multiHash([4,5,6])
const leaf3 = mimcjs.multiHash([7,8,9])
const leaf4 = mimcjs.multiHash([9,8,7])
const leafArray = [leaf1,leaf2,leaf3,leaf4]

function getBase2Log(y) {
    return Math.log(y) / Math.log(2);
}

function pairwiseHash(array) {
    if (array.length % 2 == 0){
        let arrayHash = []
        for (var i = 0; i < array.length; i = i + 2){
            arrayHash.push(mimcjs.multiHash(
                [array[i],array[i+1]]
            ))
        }
        return arrayHash
    } else {
        console.log('array must have even number of elements')
    }
}
function treeFromLeafArray(leafArray) {
    let depth = getBase2Log(leafArray.length);
    let tree = Array(depth);

    tree[depth - 1] = pairwiseHash(leafArray)

    for (var j = depth - 2; j >= 0; j--){
        tree[j] = pairwiseHash(tree[j+1])
    }

    // return treeRoot[depth-1]
    return tree
}
function idxToBinaryPos(idx, binLength) {
    binString = idx.toString(2);
    binPos = Array(binLength).fill(0)
    for (var j = 0; j < binString.length; j++){
        binPos[j] = Number(binString.charAt(binString.length - j - 1));
    }
    return binPos;
}

function proofIdx(leafIdx, treeDepth) {
    let proofIdxArray = new Array(treeDepth);
    let proofPos = idxToBinaryPos(leafIdx, treeDepth);
    // console.log('proofPos', proofPos)

    if (leafIdx % 2 == 0){
        proofIdxArray[0] = leafIdx + 1;
    } else {
        proofIdxArray[0] = leafIdx - 1;
    }

    for (var i = 1; i < treeDepth; i++){
        if (proofPos[i] == 1){
            proofIdxArray[i] = Math.floor(proofIdxArray[i - 1] / 2) - 1;
        } else {
            proofIdxArray[i] = Math.floor(proofIdxArray[i - 1] / 2) + 1;
        }
    }

    return(proofIdxArray)
}

function getProof(leafIdx, tree, leaves) {
    let depth = tree.length;
    let proofIdx = proofIdx(leafIdx, depth);
    let proof = new Array(depth);
    proof[0] = leaves[proofIdx[0]]
    for (var i = 1; i < depth; i++){
        proof[i] = tree[depth - i][proofIdx[i]]
    }
    return proof;
}

const tree = treeFromLeafArray(leafArray)
const root = tree[0][0];
const leaf1Proof = getProof(0, tree, leafArray)
const leaf1Pos = [1,1]

const inputs = {
    "in": [1,2,3],
    "merkle_root": root.toString(),
    "path_elements": [leaf1Proof[0].toString(),leaf1Proof[1].toString()],
    "path_indices": leaf1Pos
}

fs.writeFileSync(
    "./input.json",
    JSON.stringify(inputs),
    "utf-8"
);
