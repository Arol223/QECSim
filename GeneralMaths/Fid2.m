function fid = Fid2(psi,rho)
%FID2 Calculate fidelity between density matrix rho and pure state psi.

fid = (psi'*rho.rho)*psi;
fid = real(sqrt(fid));
end

