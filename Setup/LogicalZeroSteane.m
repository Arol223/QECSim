function [psi,rho] = LogicalZeroSteane()
%LOGICALZEROSTEANE returns an NbitState in the logical zero state of the
%Steane Code as well as a state vector in |0>_L
%   

[cnot,cz,~,~,z,had] = MakeGates(Inf,Inf,zeros(1,6),0,0);
rho = NbitState();
rho.init_all_zeros(7,0);
[rho,~] = Correct_steane_error(rho,1,'X',0,0,had,cnot,z,cz);
psi = diag(rho.rho);
psi = sqrt(psi);
end

