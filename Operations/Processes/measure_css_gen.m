function [ rho, p_rho ] = measure_css_gen(nbitstate, block, CSSCode, type, gen_nbr, val,...
    e_init, e_readout, had_gate, CNot, CZ)
%MEASUREGENERATOR Parity measurement of a generator of a CSS code.
%   Measures the generator of CSSCode specified by type and number and
%   returns the state after measuring val, the desired outcome (either |0> or
%   |1>) as well as the probability of measuring the state. Requires a
%   readout error, hadamard gate, CNot gate and code block on which to
%   measure as input. Additionally requires a Controlled Z-gate if the
%   generator is a Z-type generator. 
if (nargin < 11 && strcmp(type,'Z')) 
    error('Provide a CZ-gate to measure a Z-type generator')
end

t_ro = nbitstate.t_ro;
t_init = nbitstate.t_init;
%prep_cat_state = memoize(@prep_cat_state);
ancilla_sz = CSSCode.get_stabweight(type, gen_nbr); % Ancilla size, determined by stabiliser weight.
[ancilla, t_ancilla_prep] = prep_cat_state(ancilla_sz, e_init, e_readout, CNot, had_gate,...
    t_ro, t_init); % prepare ancilla in cat state

if t_ancilla_prep && nbitstate.T_2_hf
    ancilla_phase_damp = DampCoeff(t_ancilla_prep,nbitstate.T_2_hf);
    rho = idle_bits(nbitstate, 1:nbitstate.nbits, 0, ancilla_phase_damp);
else
    rho = NbitState(nbitstate.rho);
    rho.copy_params(nbitstate);
end

rho.extend_state(ancilla, 'start');    % Tensor product of data block and ancilla

if strcmp(type, 'Z')
    gen = CZ;
else
    gen = CNot;
end
[controls, targets] = CSSCode.get_gen_indices(type, gen_nbr, block); % Get indices for targets and controls
rho = gen.apply(rho, targets, controls);    % Applying the controlled generator operation
rho = ancilla_extract_prep(rho, CNot, had_gate, ancilla_sz,1); % Prepare ancilla for syndrome extraction
[rho, p_rho] = measurement_e(rho, 1, val, e_readout, 'NbitState'); % Measure first ancilla bit
rho.trace_out_bits(1:ancilla_sz); % Tracing out ancilla
end

