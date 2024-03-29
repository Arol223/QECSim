function [rho, t_tot] = prep_cat_state( nbits, e_state_prep, e_readout, CNotGate,...
    HadGate, t_ro, t_init)
%PREP_CAT_STATE Prepares an NBitState in a cat state.
%   Prepares a cat state that can be used as an ancilla state to measure
%   generators of stabiliser codes etc. Accounts for readout errors in
%   measurements, faulty state preparation and gate errors.
%   Follows circuit from: https://arxiv.org/pdf/0905.2794.pdf?source=post_page---------------------------
%   Fig 16 p.29.
rho = NbitState();
% % Ths block is used to create perfect ancilla. Remove for using gate errors
% CNotGate.inc_err = 0;
% CNotGate.idle_state = 0;
% HadGate.inc_err = 0;
% HadGate.idle_state = 0;
% e_state_prep = 0;
% e_readout = 0;

rho.init_all_zeros(nbits+1, e_state_prep); %Initialise in |0000....0>
controls = [2,2,3:nbits, nbits+1];  %Control bits for Cnot
targets = [1,3,4:nbits+1, 1];   % Target bits for CNOt
rho = HadGate.apply(rho, 2);    % H-gate on bit 1
rho = CNotGate.apply(rho, targets, controls);   %CNot
rho = measurement_e(rho, 1, 0, e_readout, 'NbitState'); % Verification measurement
rho.trace_out_bits(1);  % Removing first bit. 

t_dur_cnot = CNotGate.operation_time;   % Operation time for cnot
t_dur_had = HadGate.operation_time; % Operation time for hadamard    
                                    % Readout time t_ro from input
n_cnot = length(controls); % # of cnot-gates

t_tot = t_dur_cnot*n_cnot + t_dur_had + t_ro +(nbits+1)*t_init;

end

