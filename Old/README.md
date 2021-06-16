# QECSim

This projects consists of two main parts, namely code for simulating quanutm circuits and simulation results and figures used for my thesis project "Density Matrix Simulation of Quantum Error Correction".

The project is arranged in a few different directories, and the functions and classes used for circuit simulations are found in the directories "States", "Operations" and "GeneralMaths". Creating a project like this is an iterative process, and becuase of this, all the folders contain objects that are half-finished or that I decided to give up on for various reasons. Below is a short description of the most important parts of each of these directories:

----------States-----------

_NbitState.m_

A quantum circuit consists of two main parts, namely qubits and gates acting on the qubits. 
To represent an a collection of qubits, I used an object of the class NbitState found in this folder. 
An NbitState object has a density matrix as an attribute, and can be added using the + operator. 
It can either be initialised using a predefined density matrix, or it can be initialised 'empty', and initialised to an all-zero state by using a method. Refer to the documentation in the code for specifics.

Example:

dens =  (1/sqrt(2))[1 0; 0 1];

rho_1 = NbitState(dens);

rho_2 = NbitState();

rho_2.init_all_zeros(1, 1e-3);

rho_tot = 0.5\*rho_1 + 0.5\*rho_2;

_CSSCode.m & SteaneCode.m_

The Steane Code is a type of error correcting code belonging to a larger class of codes known as CSS-codes. These are described in Nielsen & Huang.
CSSCode is an _abstract_ class which contains a few attributes and methods that are common for all CSS-codes, and could thus be subclassed to implement a specific example.
SteaneCode is a subclass of CSSCode, and describes the SteaneCode. It specifices the generators of the SteaneCode, as well as some logical operators. 


-----------Operations------------

This directory contains three main subfolders: GateFunctions, Gates, and Processes. From the Quantum Operations folder, only the PhaseDamping and AmplitudeDamping are used.

__GateFunctions__

As the name suggests, this folder contains functions used to build matrices for common gates. This includes the CNOT, CZ, and Hadamard gates, as well as rotation matrices 
and generalisations of the CNOT and CZ, with for example arbitrary numbers of control bits. 

__Gates__

This folder contains classes used to represent quantum gates. The SingleBitGate and TwoBitGate classes are abstract, and should be subclassed to create specific examples. 
There are also finished classes for the CNOT and CZ as well as the Hadamard and Pauli gates. 

These classes combine the gate operation with applying errors. Error rates can be set manually or by using any of a number of methods. The method I have used the most is called 
'set_err'. This takes a bitflip error rate ad phaseflip error rate as input, and sets cross term errors (such as X-error on control, Z-error on target) as p_bitflip\*p_phaseflip.

To use a gate-object, the an instance of the gate has to be created and the different parameters have to be set. To apply the gate to an array of qubits, the _apply_ method is used. 

_Example_: 

rho = NbitState();

rho.init_all_zeros(4,0);

cnot = CNOTGate();

cnot.set_err(1e-3,1e-3);

rho = cnot.apply(rho, 2, 3) % input is NbitState object, control bit, target bit
--------------------

The gates can also take regular matrices and state vectors as input, provided these have the right dimensions. If using a state vector as input, no errors will be applied. This is when simulating a circuit, as the fidelity can be caluclated afterwards by applying the same set of gates to the state vector as the density matrix.

--------------------
__Processes__

This folder contains functions used more specifically to simulate error correction, including measuring stabiliser operators of CSS-codes and simulating ancilla preparation and readout. 

Pretty much all of these functions take number of gate objects as inputs. This was done so that the same gates can be used for all operations, and to avoid having to use global parameters. 

The Correct_steane_error function is used to simulate error correction with the Steane Code. The input to this function is:

nbitstate - an NbitState object representing the qubits, 

block - a block parameter which determines which logical qubit to perform error correction on in the case of several logical qubits (e.g. block = 1 simulates error correction on the first logical qubit),

type - the type of stabiliser to use; if an X-error is to be corrected, the Z-type stabilisers should be used and type would then be specified as 'Z'.

e_init - initialisation error rate

e_readout - readout error rate

had_gate - a hadamard gate object

CNot - a CNOTGate object

corr_gate - the gate used for corrrecting the detected error. If a Z-type error is to be corrected, this should be a ZGate object.

CZ - a CZGate object.

_Example_: Simulate correcting a phase-flip error

rho = NbitState();

rho.init_all_zeros(7,0);

rho = Correct_steane_error(rho, 1, 'X', 1e-3, 1e-3, HadGate, CNotGate, ZGate, CZ)

------------------

_measure_syndrome_

Simulates measuring a specific error syndrome, such as [1 1 1] of the Steane code. Takes a CSScode object as input because it was initially meant 
to handle all CSSCodes, but this idea was abandoned due to time-constraints. See code for more detailed description. 



_FT_CSSgen_measurement_

Simulate measuring a CSS stabiliser operator fault tolerantly, with majority voting. 
This function is used by the measure_syndrome function. See code for more details.

_measure_css_gen_

Simulate a single parity measurement of a CSS code stabilser operator. Used by FT_CSSgen_measurement. See code for more details. 

_prep_cat_state & ancilla_extract_prep_

prep_cat_state is used to simulate fault tolerant ancilla preparation needed for parity measurements, and ancilla_extract_prep prepares the ancilla part of a
system for performing a parity measurement. Both of these are used by measure_css_gen, and a more detailed description can be found in the .m files.

_idle_bits_:

Simulate resting qubits by applying amplitude and phase damping. Used by gate-object methods. 

_SteaneLogicalGate_:

Helper function to perfom a logical single qubit gate for the Steane code. 

---------------

__GeneralMaths__

Contains general useful functions:

_Fid2_:

Used to calculate fidelity between an NbitState and a state vector.

_TraceOutLeft_:

Traces out the 'left' subsystem of a composite system, i.e. if rho = a\otimes b, a is traced out. This is pretty quick compared to more general 
functions used to calculate the partial trace, and is very simple to understand. Because of this, I recommend always adding ancilla qubits first to an NbitState, 
so that the qubit numbering allows for using this function to remove the ancilla when no longer needed. Tracing out ancilla qubits is also important for performance.

_projective_measurement_: 

Simulate performing a projective measurment on a qubit. Both the target bit and the target vslue are inputs, and the output is a state and corresponding probability. 
For example, setting target state to 1 returns the state of the system after measuring the target bit as |1>, and the probability for this measurement outcome.

_measurement_e_: 

Simulate performing a projective measurement with readout errors. See file for more details. 

_tensor_product_: 

Take the tensor product of a variable number of matrices. The matrices can be given either as a cell array or as a 3D matrix. 

------------------

__Setup__
This folder contains some useful helper functions to make scripts shorter. The names are fairly descriptive, but they are mostly used to change a single parameter for several gate objects at the same time, 
for example the error rates. This makes writing scripts less of a pain. 

----------------

__Simulations__

Contains scripts written to simulate various things. Probably won't be of any use to anyone but me, but the files can maybe be studied for examples to see how the other 
elements of the code are used. 
