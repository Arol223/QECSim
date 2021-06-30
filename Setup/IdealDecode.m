function [rho] = IdealDecode(code, rho_real)
%IDEALDECODE Ideally decode, amounting to ideal EC.
%   Detailed explanation goes here

cnot = CNOTGate(0,0);
had = HadamardGate(0,0);
x = XGate(0,0);
y = YGate(0,0);
z = ZGate(0,0);

switch code
    
    case 'Surf17'
        rho = CorrectionCycle(rho_real,'X',cnot,had,x,z,0);
        rho = CorrectionCycle(rho,'Z',cnot,had,x,z,0);
        rho = LogStateSurf17(rho);
        
    case 'Steane'
        rho = FullFlagCorrection(rho_real,1,'X',cnot,had,z,x);
        rho = FullFlagCorrection(rho,1,'Z',cnot,had,x,z);
        rho = LogStateSteane(rho);
    case '5Qubit'
        rho = CorrectError5qubit(rho_real,1,cnot,had,z,x,y);
        rho = LogState5Qubit(rho);
end

