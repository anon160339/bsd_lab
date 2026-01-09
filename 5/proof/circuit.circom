//================================================================
//Circom

pragma circom 2.0.0;

//================================================================
//Requirements

//include "circomlib/circuits/bitify.circom";
//include "circomlib/circuits/comparators.circom";

//================================================================
//Operations

//...

//================================================================
//Main

template MainCircuit() {
    //input
    signal input a;
    signal input b;
    signal output out;

    //Addition `a + b`;
    out <== a + b;

}

component main = MainCircuit();