function [rho_out,p_out] = MajVoteMeasurement(rho_in,block,...
type, num,syn,cnot,cz,had)
%MAJVOTEMEASUREMENT Majority vote measurement of Steane stabiliser
%   ---Inputs---
%   rho_in  - input state
%   block   - qubit code block to measure
%   type    - 'X' for x stabilisers, 'Z' for z stabilisers
%   num     - the stabiliser number
%   syn     - the majority vote syndrome (e.g 00, 101 etc)
%   cnot,cz,had - gate objects
%   ---Outputs---
%   rho_out - output state
%   p_out   - Output probability

if isequal(syn(1:2), [0 0]) || isequal(syn(1:2), [1 1]) 
    % prevent a 3d measurement if end result already determined
    syn = syn(1:2);
end

[rho_out, p_out] = MeasureStabiliserSteane(rho_in,block,cnot,cz,had,num,type,syn(1));

for i = 2:length(syn)
   [rho_out, p_tmp] = MeasureStabiliserSteane(rho_out,block,cnot,cz,had,num,...
       type,syn(i)); 
   p_out = p_out*p_tmp;
end
end

