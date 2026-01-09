//================================================================
//Circom

pragma circom 2.0.0;

//================================================================
//Requirements

//include "circomlib/circuits/bitify.circom";
include "circomlib/circuits/comparators.circom";    //IsZero --> IsEqual

//Poseidon Hash recommended

//================================================================
//Operations

//...

//================================================================
//Main

template MainCircuit(merkle_levels_count) {
    //input vote value (bind)
    signal input vote;
    
    //input entry
    signal input s;
    signal input k;

    //input DB (shortcut via Merkle Proof)
    signal input entry_index;
    signal input merkle_leafs[merkle_levels_count - 1];
    signal input merkle_root;   //(optional but I will use it to know what to output on vote_entries_root)
    //constrain: merkle_root === MerkleProof(entry, leafs);

    //input previous_vote (bind)
    signal input previous_vote;
    
    //================================================================
    //
    // Here constrains/zk-processing should be put 
    //
    //================================================================
    //================================================================
    //example constrain (69 is illegal)
    component c1 = IsEqual();               //circuit taken from circomlib
    c1.in[0] <== vote;
    c1.in[1] <== 69;
    c1.out === 0;       //this makes sure vote cannot be 69 (as an example)
    //circuits source code: https://github.com/iden3/circomlib/blob/master/circuits/comparators.circom
    //================================================================

    //output vote   (copy)
    signal output vote_value <== vote;

    //output
    signal output vote_entries_root <== merkle_root;

    //output nullifier
    signal output vote_nullifier <== k;

    //output previous vote  (copy)
    signal output vote_previous_vote <== previous_vote;
}

// Max number of voters: 2 ** 10 = 1024
component main = MainCircuit(10);

