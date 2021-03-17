function [rho_out, p_out] = FullFlagCorrection(rho_in, block, type, cnot, had, cor_s, cor_f)
%FULLFLAGCORRECTION Simulate the full flagged Steane EC-circuit 
%   Simulates the full flagged Steane Error Correction circuit.
%   -----Inputs-----
%   rho_in - The input state
%   block - The block to error correct if several blocks
%   type - 'Z' or 'X', the type of stabiliser to correct with
%   cnot,had - gate objects used in the circuit
%   cor_s - Gate object used for correcting regular error, i.e. X-gate for Z-type
%             stabiliser and Z-gate for X-type stabiliser
%   cor_f - Gate object used to correct flag error, i.e. Z for Z-stabiliser
%           and X for X-stabiliser
%
%   -----Outputs----
%   rho_out - The output state
%   p_out - Should equal 1

[tmp_1, p_1] = NoFlagCorrect(rho_in,block,type,cnot,had,cor_s);
[tmp_2, p_2] = FlagCorrect(rho_in, block, type, cnot, had,cor_s,cor_f);

r_out = tmp_1.rho*p_1 + tmp_2.rho*p_2;
rho_out = NbitState(r_out);
rho_out.copy_params(rho_in);
p_out = p_1+p_2;
end

