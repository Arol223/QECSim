function [rho_out, p_out] = MeasureStabiliserSteane(rho_in, block, cnot, cz, had, num, type, val)
%MEASURESTABILISER Measure a Steane code stabiliser using the shor scheme
%   ---Inputs---
%   rho_in - input state
%   cnot   - cnot gate object
%   cz     - cz gate object
%   had    - hadamard gate object
%   num    - the number of the stabiliser
%   type   - 'X' or 'Z', the stabiliser type
%   val    - 0 or 1 corresponding to measuring in |0> or |1>
%
%   ---Outputs---
%   rho_out - output state
%   p_out   - output probability

t_ro = rho_in.t_ro;
t_init = rho_in.t_init;
e_ro = rho_in.e_ro;
e_init = rho_in.e_init;

[t_ancilla, ancilla] = BuildCatState(cnot,had,e_init,t_init,e_ro,t_ro);
if t_ancilla && rho_in.T_2_hf
    c_phase = DampCoeff(t_ancilla,rho_in.T_2_hf);
    rho_out = idle_bits(rho_in,1:rho_in.nbits,0,c_phase);
else
    rho_out = NbitState(rho_in.rho);
    rho_out.copy_params(rho_in);
end

rho_out.extend_state(ancilla,'start');

if type == 'X'
    gen = cnot;
else
    gen = cz;
end

targets = SteaneColorCode.stabilisers(num,:) + 7*(block-1) + 4;

rho_out = gen.apply(rho_out, targets, 1:4);

extract_targets = [4 3 2];
extract_controls = [3 2 1];

rho_out = cnot.apply(rho_out, extract_targets, extract_controls);
rho_out = had.apply(rho_out,1);
[rho_out,p_out] = measurement_e(rho_out,1,val,e_ro,1,0);
rho_out.trace_out_bits(1:4);
end

