function fid = Fid2(psi,rho)
%FID2 Calculate fidelity between density matrix rho and pure state psi.
if isa(rho,'NbitState')
    rho = rho.rho;
end

fid = (psi'*rho)*psi;
%fid = sqrt(fid);
end

