function [rho, p] = measurement_e( nbitstate, target, val, e_readout,...
    output_state, sym)
%MEASUREMENT_E Performs a projective measurement with readout error.
%Returns resulting state rho and corresponding probability p
%   Works the same way as function projective_measurement, but adds a
%   component of the wrong result to account for readout error so e.g.
%   rho_0 = (1-e_readout)*rho_0 + e_readout*rho_1.
%   Sym argument determines if the readout error is symmetric or not. 
%   sym = 0 gives the asymmetric case, where there's a chance a 0 will be
%   read as a 1 but not the other way around. If sym = 1 a 1 can be read as
%   0 and 0 can be read as 1.

if nargin < 6
    sym = 0;
end
[rho, p] = projective_measurement(nbitstate, target, val, 0);
if e_readout 
    [rho_e, ~] = projective_measurement(nbitstate, target, mod(val+1,2), 0);
    if sym
        rho = (1-e_readout)*rho + e_readout*rho_e;
    elseif val == 1
        rho = (1-e_readout)*rho + e_readout*rho_e;
    end
end
if output_state
    rho = NbitState(rho);
end

end

