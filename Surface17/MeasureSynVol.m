function [rho_out, p_out] = MeasureSynVol(rho_in, syn_vol, type, cnot, had)
%MEASURESYNVOL Measure a surface17 syndrome volume
%   ---Inputs---
%   rho_in  - Input state
%   syn_vol - A syndrome volume in form of 2x2x3 array
%   type    - An 'X' or 'Z' type measurement
%   cnot    - CNot gate object
%   had     - Hadamard gate object


syn = reshape(syn_vol(:,:,1)',1,4);

[rho_out, p_out] = MeasureSyndrome(rho_in,syn,type,cnot,had);
for i = 2:size(syn_vol,3)
    if ~p_out
        return
    end
    syn = reshape(syn_vol(:,:,i)',1,4);
    [rho_out, ptmp] = MeasureSyndrome(rho_out,syn,type,cnot,had);
    p_out = p_out*ptmp;
end

