function [ rho ] = correct_css_error( nbitstate, CSSCode, type, block,CNot,...
    Had, CZ, e_readout, e_init)
%CORRECT_CSS_ERROR Corrects a bit- or phase-flip error in a CSS-code state.
%   Tries to correct a bit- or phaseflip error in nbitstate using the code
%   specified in CSSCode. The type of error is set in type, and the logical
%   bit to correct on is specified in block. Takes a CNot gate, a hadamard
%   gate, a controlled Z gate, a readout error and an initialisation error
%   as input. 
if strcmp(type, 'X')
    gen = CNot;
    ngens = size(CSSCode.XStabilisers,1);
elseif strcmp(type, 'Z')
    gen = CZ;
    ngens = size(CSSCode.ZStabilisers,1);
else
    error('Specify the type of error to correct. X corrects for phaseflip and Z corrects fr bitflip')
end

rho = zeros(size(nbitstate.rho));
for i = 1:ngens



end

