function fid = Fidelity(rho, sigma)
%Calculates the fidelity between two matrices rho and sigma
rho_p = sqrt(rho);
fid = trace(sqrt(rho_p*sigma*rho_p));
end

