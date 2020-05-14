function rho = LogicalZeroSteane()
%LOGICALZEROSTEANE returns an NbitState in the logical zero state of the
%Steane Code
%   
[cnot,cz,~,~,z,had] = MakeGates(Inf,Inf,zeros(1,6),0,0);
Steane  = SteaneCode();
rho = NbitState();
rho.init_all_zeros(7,0);
[rho,~] = Correct_steane_error(rho,1,Steane,'X',0,0,had,cnot,z,cz);
end

