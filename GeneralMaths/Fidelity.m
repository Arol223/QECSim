function fid = Fidelity(rho, sigma)
%Calculates the fidelity between two matrices rho and sigma
rho_p = sqrtm(abs(rho));
fid = trace(sqrtm(rho_p*abs(sigma)*rho_p));
end

