function [ rho ] = ancilla_extract_prep( rho, CNot, Had, ancilla_sz )
%ANCILLA_EXTRACTION Prepares the ancilla part of system for measurement.
%   Applies a transversal CNOT from bottom to top, followed by a hadamard
%   gate on the top bit to prepare the state for e.g. syndrome extraction.
%   see https://arxiv.org/pdf/0905.2794.pdf?source=post_page---------------------------
%   figure 15 c) for details. Assumues that the ancilla is at the 'top' of
%   the circuit i.e. if the ancilla is 4 bits in a block of 11 bits, bits
%   1-4 would be the ancilla.  Takes a state, a CNot gate and a Hadamard
%   gate, and the size of the ancilla as input. 

controls = ancilla_sz-1:-1:1;
targets = ancilla_sz:-1:2;
rho = CNot.apply(rho, targets, controls);
rho = Had.apply(rho,1);
end

