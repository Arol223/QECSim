clear 
cnot = CNOTGate(0,0);
had = HadamardGate(0,0);
x = XGate(0,0);
z = ZGate(0,0);
[rho_l,psi] = Log0FlagSteane();
rho = NbitState();
rho.init_all_zeros(7,0);



rprime = x.apply(rho,1);
[rho_n,p_out2] = FullFlagCorrection(rho,1,'Z',cnot,had,x,z);
[rho_nn,p_out1] = FullFlagCorrection(rho_n,1,'X',cnot,had,z,x);

figure(1)
spy(rho)
figure(2)
spy(rho_n)
figure(3)
spy(rho_nn)
