# QECSim

This will be a brief description of how to use the basic elements of this project. 
The main building blocks are the NbitState class in QECSim/States together with gate classes, e.g. CNOTGate, XGate etc.
NbitState objects represent qubit arrays and can be created empty, but has attributes determining e.g. magnitude of readout errors, ground state T2 (determining resting error magnitude) etc. 
Gate objects are also typically created empty, and then various error parameters can be set. There are some quality of life functions in QECSim/Setup to create gate
objects and set parameters collectively.

The reason for using objects for qubit arrays and gates rather than functions is that various parameters can be propagated easily in this way, which makes 
function calls less cumbersome to write out. 

The way I have used these building blocks to simulate QEC is to write functions simulating the various subprocesses of QEC, e.g. stabiliser measurements and so on. 
I have implemented three main QEC protocols, these being Surface-17, [[5,1,3]] flag error correction and Flag EC with the Steane code. The Surface-17 implementation
is found in QECSim/Surface17, and the other two are found in QECSim/FlagEC. These examples can be studied to see how to implement QEC protocols. Note that 
everything is organised into regular folders, so function naming conflicts can arise if special care is not taken. 

Examples of simulations can be found in e.g. QECSim/SimulationsNewProject/SteaneFlagVShor (my scripts don't have the most logical names). I used this to calculate
pseudothresholds, and it has examples of how to use all of the components. 
