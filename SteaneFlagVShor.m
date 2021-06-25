clear

res = 16;
p_err = logspace(-4,-1,res);


%% Steane Code
%fid_shor = zeros(1,res);
fid_flag = zeros(1,res);

parfor i = 1:res
    
    [rho,psi] = Log0FlagSteane();
    rho = NbitState(rho);
    X_L = BuildOpMat('XXXXXXX');
    not_psi = X_L*psi;
    p = p_err(i);
    p_cnot = p;
    rho.e_init = p;
    rho.e_ro = p;
    rho.sym_ro = 1;
    [cnot,cz,xgate,~,zgate,had] = MakeGates(0,0,0,0,0,0);
    [xgate,zgate,had] = SetErrDiff(p/3,p/3,p/3, xgate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    
    %[r_shor,p_shor1] = CorrectSteaneShorError(rho,1,'X',cnot,cz,had,xgate,zgate);
    %[r_shor,p_shor2] = CorrectSteaneShorError(rho,1,'Z',cnot,cz,had,xgate,zgate);
    
    [r_flag,p_flag1] = FullFlagCorrection(rho,1,'X',cnot,had,zgate,xgate);
    [r_flag,p_flag2] = FullFlagCorrection(r_flag,1,'Z',cnot,had,xgate,zgate);
    
    %r_shor = r_shor.rho;
    r_flag = r_flag.rho;
    %fid_shor(i) = not_psi'*r_shor*not_psi;
    fid_flag(i) = not_psi'*r_flag*not_psi;
end

%% 5-qubit
fid_5qubit = zeros(1,res);
for i = 1:res
    [rho,psi] = Log0FiveQubit();
    rho = NbitState(rho);
    X_L = BuildOpMat('XXXXX');
    
    not_psi = X_L*psi;
    p = p_err(i);
    p_cnot = p;
    rho.e_init = p;
    rho.e_ro = p;
    rho.sym_ro = 1;
    [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,0,0,0,0);
    [xgate,ygate,zgate,had] = SetErrDiff(p/3,p/3,p/3, xgate,ygate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    
    [r,p] = CorrectError5qubit(rho,1,cnot,had,zgate,xgate,ygate);
    R_L = r.rho;
    fid_5qubit(i) = not_psi'*R_L*not_psi;
end

%% Surface-17
fid_surf = zeros(1,res);

parfor i = 1:res
    [psi,rho] = Logical0Surf17();
    X_L = BuildOpMat('IIXIXIXII');
    not_psi = X_L*psi;
    
    p = p_err(i);
    p_cnot = p;
    rho.e_init = p;
    rho.e_ro = p;
    rho.sym_ro = 1;
    [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,0,0,0,0);
    [xgate,ygate,zgate,had] = SetErrDiff(p/3,p/3,p/3, xgate,ygate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    [rho,~] = CorrectionCycle(rho,'X',cnot,had,xgate,zgate,0);
    [rho,~] = CorrectionCycle(rho,'Z',cnot,had,xgate,zgate,0);
    
    r_L = rho.rho;
    fid_surf(i) = not_psi'*r_L*not_psi;
end
%%
figure();
%plot(p_err,fid_shor./p_err.^2);
hold on

plot(p_err,fid_5qubit./p_err.^2)
plot(p_err,fid_flag./p_err.^2);
plot(p_err,fid_surf./p_err.^2);
plot(p_err,p_err.^(-1));
set(gca,'xscale','log')
set(gca,'yscale','log')
legend('[[5,13]] - flag','[[7,1,3]] - flag','[[9,1,3]] (Surface-17)','p_{err}')
xlabel('$p_{err}$')
h = gca;
set(h.XLabel,'Interpreter','latex')
ylabel('$\frac{1}{p^2}\cdot$ Logical Error Rate')
set(h.YLabel,'Interpreter','latex')
