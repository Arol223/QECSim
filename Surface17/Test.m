
clear 
%% Error free

[psi_l, rho_l] = Logical0();

cnot = CNOTGate(0,0);
had = HadamardGate(0,0);
x = XGate(0,0);
y = YGate(0,0);
z = ZGate(0,0);

[res, p_out1] = CorrectionCycle(rho_l,'X',cnot,had,x,z);
[res, p_out2] = CorrectionCycle(res,'Z',cnot,had,x,z);

succ1 = allclose(res.rho,rho_l.rho);
%% Correct one error

[psi_l, rho_l] = Logical0();

cnot = CNOTGate(0,0);
had = HadamardGate(0,0);
x = XGate(0,0);
y = YGate(0,0);
z = ZGate(0,0);
z_ind = randi(9);
x_ind = randi(9);
res = z.apply(rho_l,z_ind);
res = x.apply(res,x_ind);
[res, p_out1] = CorrectionCycle(res,'X',cnot,had,x,z);
[res, p_out2] = CorrectionCycle(res,'Z',cnot,had,x,z);

succ2 = allclose(res.rho,rho_l.rho);
fid2 = psi_l'*res.rho*psi_l;

%% Problem indices
% z error on bit 6 doesn't work
% x-error on 7 is ok
% x-error on 6 is ok
x_ind = 6;
z_ind = 6;

[psi_l, rho_l] = Logical0();

cnot = CNOTGate(0,0);
had = HadamardGate(0,0);
x = XGate(0,0);
y = YGate(0,0);
z = ZGate(0,0);

res = z.apply(rho_l,z_ind);
%res = x.apply(res,x_ind);
[res, p_out1] = CorrectionCycle(res,'X',cnot,had,x,z);
[res, p_out2] = CorrectionCycle(res,'Z',cnot,had,x,z);

succ3 = allclose(res.rho,rho_l.rho);
fid3 = psi_l'*res.rho*psi_l;

%% With Errors

[psi_l, rho_l] = Logical0Surf17();

cnot = CNOTGate(0,0);
had = HadamardGate(0,0);
x = XGate(0,0);
y = YGate(0,0);
z = ZGate(0,0);
p_err = 1e-5;
[cnot,had,x,y,z] = SetErrRate(p_err,cnot,had,x,y,z);
cnot.tol = p_err^2;
cnot.inc_err=1;
had.inc_err = 1;
x.inc_err = 1;
y.inc_err = 1;
z.inc_err = 1;
 [res, p_out1] = CorrectionCycle(rho_l,'X',cnot,had,x,z, (p_err^2)*1e-3*(1/4));
% [res, p_out2] = CorrectionCycle(res,'Z',cnot,had,x,z);
% 
% succ1 = allclose(res.rho,rho_l.rho);
