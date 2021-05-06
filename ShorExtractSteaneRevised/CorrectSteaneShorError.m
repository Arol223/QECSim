function [rho_out,p_out] = CorrectSteaneShorError(rho_in, block, type, cnot,cz,...
    had,xgate,zgate)
%CORRECTERROR Correct an error with Steancode using Shor extraction
%   ---Inputs---
%   rho_in          - Input state
%   block           - the qubit block on which to correct errors
%   type            - the stabiliser type, 'X' or 'Z'
%   cnot,cz,had,xgate,zgate - gate objects
%   ---Outputs---
%   rho_out - output state
%   p_out   - output probability (can be used to check if everything is correct)

p_out = 0;
corrections = SteaneColorCode.minimal_corrections;
rout = cell(8);
for i = 0:7
    syn = dec2binvec(i,3);
    
    [rtmp,p] = MeasureSyndromeSteane(rho_in,block,syn,type,cnot,cz,had);
    corr = corrections(i+1);
    if corr
        if type == 'X'
            rtmp = zgate.apply(rtmp,corr);
        elseif type == 'Z'
            rtmp = xgate.apply(rtmp,corr);
        end
    end
    p_out = p_out + p;
    [I,J,V] = find(rtmp.rho);
    rout{i+1} = [I,J,p*V];
end
n = size(rho_in);
IJV = cell2mat(rout);
if ~isempty(IJV)
    rho_out = NbitState(sparse(IJV(:,1),IJV(:,2),IJV(:,3),n,n));
else
    rho_out = NbitState(rho_in.rho);
end
rho_out.copy_params(rho_in);

end

