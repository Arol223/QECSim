clear

res = 18;
p_err = logspace(-4,-1,res);


%% Steane Code
%fid_shor = zeros(1,res);
fid_flag = zeros(1,res);

for i = 1:res
    [rho,psi] = Log0FlagSteane();
    rho = NbitState(rho);
    %X_L = BuildOpMat('XXXXXXX');
    %not_psi = X_L*psi;
    p = p_err(i);
    p_cnot = p;
    rho.e_init = p;
    rho.e_ro = p;
    rho.sym_ro = 1;
    [cnot,cz,xgate,~,zgate,had] = MakeGates(0,0,0,0,0,1);
    [cnot,cz] = SetDampCoeff(p,0,cnot,cz);
    [xgate,zgate,had] = SetDampCoeff(p,0,xgate,zgate,had);
    [xgate,zgate,had] = SetErrDiff(p/3,p/3,p/3, xgate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    
    %[r_shor,p_shor1] = CorrectSteaneShorError(rho,1,'X',cnot,cz,had,xgate,zgate);
    %[r_shor,p_shor2] = CorrectSteaneShorError(rho,1,'Z',cnot,cz,had,xgate,zgate);
    
    [r_flag,p_flag1] = FullFlagCorrection(rho,1,'X',cnot,had,zgate,xgate);
    [r_flag,p_flag2] = FullFlagCorrection(r_flag,1,'Z',cnot,had,xgate,zgate);
    
    rl_flag = LogStateSteane(r_flag);
    %r_shor = r_shor.rho;
    r_flag = r_flag.rho;
    
    %fid_shor(i) = not_psi'*r_shor*not_psi;
    fid_flag(i) = not_psi'*r_flag*not_psi;
    fidL_flag(i) = Fid2(not_psi_L,rl_flag);
end

%% 5-qubit
fid_5qubit = zeros(1,res);
fid_L_5qubit = fid_5qubit;
for i = 1:res
    [rho,psi] = Log0FiveQubit();
    rho = NbitState(rho);
    X_L = BuildOpMat('XXXXX');
    
    not_psi = X_L*psi;
    not_psi_L = [0 ;1];
    p = p_err(i);
    p_cnot = p;
    rho.e_init = p;
    rho.e_ro = p;
    rho.sym_ro = 1;
    [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,0,0,0,1);
    [xgate,ygate,zgate,had] = SetErrDiff(p/3,p/3,p/3, xgate,ygate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    
    [cnot,cz] = SetDampCoeff(p,0,cnot,cz);
    [xgate,ygate,zgate,had] = SetDampCoeff(p,0,xgate,ygate,zgate,had);
    
    [r,p] = CorrectError5qubit(rho,1,cnot,had,zgate,xgate,ygate);
    log_rho = LogState5Qubit(r);
    R_L = r.rho;
    fid_5qubit(i) = not_psi'*R_L*not_psi;
    fid_L_5qubit(i) = Fid2(not_psi_L,log_rho);
end

%% Surface-17
fid_surf = zeros(1,res);
fid_L_surf = fid_surf;
parfor i = 1:res
    [psi,rho] = Logical0Surf17();
    X_L = BuildOpMat('IIXIXIXII');
    not_psi = X_L*psi;
    not_psi_L = [0;1];
    p = p_err(i);
    p_cnot = p;
    rho.e_init = p;
    rho.e_ro = p;
    rho.sym_ro = 1;
    [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,0,0,0,1);
    [xgate,ygate,zgate,had] = SetErrDiff(p/3,p/3,p/3, xgate,ygate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    [cnot,cz] = SetDampCoeff(p,0,cnot,cz);
    [xgate,zgate,had] = SetDampCoeff(p,0,xgate,zgate,had);
    
    [rho,~] = CorrectionCycle(rho,'X',cnot,had,xgate,zgate,0);
    [rho,~] = CorrectionCycle(rho,'Z',cnot,had,xgate,zgate,0);
    log_rho = LogStateSurf17(rho);
    r_L = rho.rho;
    fid_surf(i) = not_psi'*r_L*not_psi;
    fid_L_surf(i) = Fid2(not_psi_L,log_rho);
end
%% Fidelity Plot
figure();
%plot(p_err,fid_shor./p_err.^2);
hold on

plot(p_err,fid_5qubit./p_err.^0)
plot(p_err,fid_flag./p_err.^0);
plot(p_err,fid_surf./p_err.^0);
plot(p_err,p_err.^(1));
set(gca,'xscale','log')
set(gca,'yscale','log')
legend('[[5,1,3]] - flag','[[7,1,3]] - flag','[[9,1,3]] (Surface-17)','p_{err}')
xlabel('$p_{err}$')
title('Error Fidelity')
h = gca;
set(h.XLabel,'Interpreter','latex')
ylabel('$\frac{1}{p^2}\cdot$ Logical Error Rate')
set(h.YLabel,'Interpreter','latex')

%% Logical Fidelity Plot
figure();
%plot(p_err,fid_shor./p_err.^2);
hold on

plot(p_err,fid_L_5qubit./p_err.^0)
plot(p_err,fidL_flag./p_err.^0);
plot(p_err,fid_L_surf./p_err.^0);
plot(p_err,p_err.^(1));
set(gca,'xscale','log')
set(gca,'yscale','log')
legend('[[5,1,3]] - flag','[[7,1,3]] - flag','[[9,1,3]] (Surface-17)','p_{err}')
xlabel('$p_{err}$')
title('Logical Error Fidelity')
h = gca;
set(h.XLabel,'Interpreter','latex')
ylabel('$\frac{1}{p^2}\cdot$ Logical Error Rate')
set(h.YLabel,'Interpreter','latex')
