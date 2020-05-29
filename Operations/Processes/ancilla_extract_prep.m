function [ rho ] = ancilla_extract_prep( rho, CNot, Had, ancilla_sz, idle)
%ANCILLA_EXTRACTION Prepares the ancilla part of system for measurement.
%   Applies a transversal CNOT from bottom to top, followed by a hadamard
%   gate on the top bit to prepare the state for e.g. syndrome extraction.
%   see https://arxiv.org/pdf/0905.2794.pdf?source=post_page---------------------------
%   figure 15 c) for details. Assumues that the ancilla is at the 'top' of
%   the circuit i.e. if the ancilla is 4 bits in a block of 11 bits, bits
%   1-4 would be the ancilla.  Takes a state, a CNot gate and a Hadamard
%   gate, and the size of the ancilla as input. The idle parameter is zero
%   per default, and determines whether the databits suffer from damping or
%   not. In a physical situation, if the ancilla can be measured
%   simultaneously as the next generator is measured the damping channels
%   should not be applied. 

if nargin < 5 
    idle = 0; % Determines whether to idle bits or not. 
end
if ~idle
    CNot.idle_state = 0;
    Had.idle_state = 0;
end
controls = ancilla_sz-1:-1:1;
targets = ancilla_sz:-1:2;
rho = CNot.apply(rho, targets, controls);
rho = Had.apply(rho,1);
end

