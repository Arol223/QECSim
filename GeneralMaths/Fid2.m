function fid = Fid2(psi,rho)
%FID2 Calculate fidelity between density matrix rho and pure state psi.

fid = real((psi'*rho.rho)*psi);
fid = sqrt(fid);
end

