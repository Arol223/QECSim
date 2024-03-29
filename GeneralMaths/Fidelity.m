function fid = Fidelity(rho, sigma)
%Calculates the fidelity between two matrices rho and sigma
if isa(rho,'NbitState')
    rho = full(rho.rho);
end
if isa(sigma,'NbitState')
    sigma = full(sigma.rho);
end
[rho_p,~] = sqrtm(rho);
[rs,~] = sqrtm(rho_p*sigma*rho_p);
fid = real(trace(rs));
end

