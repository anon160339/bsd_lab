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

// Max number of voters: 2 ** 10 = 1024
component main = MainCircuit(10);



