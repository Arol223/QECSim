clear

res = 18;
p_err = logspace(-4,-1,res);

id_0 = [1;0];
id_1 = [0;1];
id_plus = (1/sqrt(2))*(id_0 + id_1);
id_min = (1/sqrt(2))*(id_0 - id_1);
LogState = '0';
T2Hf = 1e-3;

switch LogState  %Determine what the wrong state is
    case '0'
        n_psi = id_1;
    case '1'
        n_psi = id_0;
    case '+'
        n_psi = id_min;
    case '-'
        n_psi = id_plus;
end
%% Steane Code
%fid_shor = zeros(1,res);
fid_flag = zeros(1,res);

parfor i = 1:res
    [rho,psi] = LogStatePrep('Steane',LogState);
    rho = NbitState(rho);
    %X_L = BuildOpMat('XXXXXXX');
    %not_psi = X_L*psi;
    p = p_err(i);
    p_cnot = p;
    rho.e_init = p;
    rho.e_ro = p;
    rho.sym_ro = 1;
    rho.T_2_hf = 1e-3;
    rho.t_init = GateTime(p,0,1e-3);
    rho.t_ro = GateTime(p,0,1e-3);
    [cnot,cz,xgate,~,zgate,had] = MakeGates(0,0,0,0,0,1);
    [cnot,cz] = SetDampCoeff(p,0,cnot,cz);
    [xgate,zgate,had] = SetDampCoeff(p,0,xgate,zgate,had);
    [xgate,zgate,had] = SetErrDiff(p/3,p/3,p/3, xgate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    
    %[r_shor,p_shor1] = CorrectSteaneShorError(rho,1,'X',cnot,cz,had,xgate,zgate);
    %[r_shor,p_shor2] = CorrectSteaneShorError(rho,1,'Z',cnot,cz,had,xgate,zgate);
    
    [r_flag,p_flag1] = FullFlagCorrection(rho,1,'X',cnot,had,zgate,xgate);
    [r_flag,p_flag2] = FullFlagCorrection(r_flag,1,'Z',cnot,had,xgate,zgate);

    %r_shor = r_shor.rho;
    
    %fid_shor(i) = not_psi'*r_shor*not_psi;
    r_l = IdealDecode('Steane',r_flag);
    fid_flag(i) = Fid2(n_psi,r_l);
    
end

%% 5-qubit
fid_5qubit = zeros(1,res);
fid_L_5qubit = fid_5qubit;
for i = 1:res
    [psi,rho] = LogStatePrep('5Qubit',LogState);
    X_L = BuildOpMat('XXXXX');
    
    not_psi = X_L*psi;
    not_psi_L = [0 ;1];
    p = p_err(i);
    p_cnot = p;
    rho.e_init = p;
    rho.e_ro = p;
    rho.sym_ro = 1;
    rho.T_2_hf = 1e-3;
    rho.t_init = GateTime(p,0,1e-3);
    rho.t_ro = GateTime(p,0,1e-3);
    [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,0,0,0,1);
    [xgate,ygate,zgate,had] = SetErrDiff(p/3,p/3,p/3, xgate,ygate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    
    [cnot,cz] = SetDampCoeff(p,0,cnot,cz);
    [xgate,ygate,zgate,had] = SetDampCoeff(p,0,xgate,ygate,zgate,had);
    
    [r,~] = CorrectError5qubit(rho,1,cnot,had,zgate,xgate,ygate);
    r_l = IdealDecode('5Qubit',r);
    fid_5qubit(i) = Fid2(n_psi,r_l);
    
end

%% Surface-17
fid_surf = zeros(1,res);
fid_L_surf = fid_surf;
parfor i = 1:res
    [psi,rho] = LogStatePrep('Surf17',LogState);
    X_L = BuildOpMat('IIXIXIXII');
    not_psi = X_L*psi;
    not_psi_L = [0;1];
    p = p_err(i);
    p_cnot = p;
    rho.e_init = p;
    rho.e_ro = p;
    rho.sym_ro = 1;
    rho.T_2_hf = 1e-3;
    rho.t_init = GateTime(p,0,1e-3);
    rho.t_ro = GateTime(p,0,1e-3);
    [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,0,0,0,1);
    [xgate,ygate,zgate,had] = SetErrDiff(p/3,p/3,p/3, xgate,ygate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    [cnot,cz] = SetDampCoeff(p,0,cnot,cz);
    [xgate,zgate,had] = SetDampCoeff(p,0,xgate,zgate,had);
    
    [rho,~] = CorrectionCycle(rho,'X',cnot,had,xgate,zgate,0);
    [rho,~] = CorrectionCycle(rho,'Z',cnot,had,xgate,zgate,0);
    log_rho = LogStateSurf17(rho);
    r_l = IdealDecode('Surf17',rho);
    fid_surf(i) = Fid2(n_psi,r_l);
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
title('Failure Probability with Rest Error |+>')
h = gca;
set(h.XLabel,'Interpreter','latex')
ylabel('Failure Probability/Error Rate')
set(h.YLabel,'Interpreter','latex')

%% Logical Fidelity Plot
% figure();
% %plot(p_err,fid_shor./p_err.^2);
% hold on
% 
% plot(p_err,fid_L_5qubit./p_err.^0)
% plot(p_err,fidL_flag./p_err.^0);
% plot(p_err,fid_L_surf./p_err.^0);
% plot(p_err,p_err.^(1));
% set(gca,'xscale','log')
% set(gca,'yscale','log')
% legend('[[5,1,3]] - flag','[[7,1,3]] - flag','[[9,1,3]] (Surface-17)','p_{err}')
% xlabel('$p_{err}$')
% title('Logical Error Fidelity')
% h = gca;
% set(h.XLabel,'Interpreter','latex')
% ylabel('$\frac{1}{p^2}\cdot$ Logical Error Rate')
% set(h.YLabel,'Interpreter','latex')
