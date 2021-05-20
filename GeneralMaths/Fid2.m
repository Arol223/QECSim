function [fid, sqrt_fid] = Fid2(psi,rho)
%FID2 Calculate fidelity between density matrix rho and pure state psi.

fid = (psi'*rho.rho)*psi;
sqrt_fid = sqrt(fid);
end

