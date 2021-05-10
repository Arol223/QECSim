function [rho_out, p_out] = MeasureSyndrome(rho_in, syn, type, cnot, had)
%MEASURESYNDROME Measure a surface17 syndrome
%   ---Inputs---
%   rho_in - input state
%   syn    - syndrome to measure in the form of a 4 bit string
%   type   - 'X' or 'Z' for the type of stabiliser
%   cnot   - CNot gate object
%   had    - Hadamard gate object

[rho_out, p_out] = MeasureStabiliser(rho_in,type,1,syn(1),cnot,had);

for i = 2:4
    if ~p_out
        return
    end
    [rho_out, ptmp] = MeasureStabiliser(rho_out,type,i,syn(i),cnot,had);
    p_out = p_out*ptmp;
    
end

end

