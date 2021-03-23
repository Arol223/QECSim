function [rho_out,p_out] = FlagSyndromeMeasurement(rho_in,syndrome,...
    block, type, flag_crct, flag_loc, cnot, had)

%FLAGSYNDROMEMEASUREMENT Perform a Steane syndrome measurement using flag
%   circuit from [Chamberland 2018].
%   ----Inputs----
%   rho_in - Input state (class NbitState)
%   syndrome - The syndrome to measure, e.g 1 0 0
%   block - The code block to perform the measurement on, in case there are
%           more than 1 logical qubits
%   type - Z or X type stabiliser
%   flag_crct - Boolean, whether to use flag or non-flag circuit
%   flag_loc - Determines where the circuit flags, if at all. value between
%               0 and 3 because there are 3 stabilisers. 0 means no flag.
%   cnot, had - Gate objects used for the measurement.

%   ----Outputs----
%   rho_out - The output state after the syndrome measurement
%   p_out   - The probability of measureing the given syndrome.

rho_out = NbitState(rho_in.rho);
rho_out.copy_params(rho_in);
p_out = 1;
for i = 1:3
    [rho_out,p_tmp] = FlagStabMeasurement(rho_out, block, cnot, had, i,...
        type, flag_crct, syndrome(i), flag_loc == i);
    p_out = p_out*p_tmp;
    if flag_loc == i
        return
    end
end


end

