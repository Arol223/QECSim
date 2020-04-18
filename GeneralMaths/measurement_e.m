function [rho, p] = measurement_e( nbitstate, target, val, e_readout,...
    output_state)
%MEASUREMENT_E Performs a projective measurement with readout error.
%Returns resulting state rho and corresponding probability p
%   Works the same way as function projective_measurement, but adds a
%   component of the wrong result to account for readout error so e.g.
%   rho_0 = (1-e_readout)*rho_0 + e_readout*rho_1.


[rho, p] = projective_measurement(nbitstate, target, val, 0);
[rho_e, ~] = projective_measurement(nbitstate, target, mod(val+1,2), 0);

rho = (1-e_readout)*rho + e_readout*rho_e;

if output_state
    rho = NbitState(rho);
end

end

