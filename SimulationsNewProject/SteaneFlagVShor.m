clear
% For proportions from T2 c_phase_TQG = 0.5 p_TQG, c_phase_SQG = 2p_SQG
res = 18;
p_err = logspace(-6,-2,res);
inc_rest = 1;
id_0 = [1;0];
id_1 = [0;1];
id_plus = (1/sqrt(2))*(id_0 + id_1);
id_min = (1/sqrt(2))*(id_0 - id_1);
id_yplus = (1/sqrt(2))*(id_0 + 1i*id_1);
id_ymin = (1/sqrt(2))*(id_0 - 1i*id_1);

LogState = '0';


switch LogState  %Determine what the wrong state is
    case '0'
        n_psi = id_1;
    case '1'
        n_psi = id_0;
    case '+'
        n_psi = id_min;
    case '-'
        n_psi = id_plus;
    case 'y+'
        n_psi = id_ymin;
    case 'y-'
        n_psi = id_yplus;
end

%% Parameters
T_2_hf = 2.6e-3;%1e-3;   %Use these for memory errors (anonymous functions)
T2_opt = 2.6e-3;


t_init = @(p,T2) GateTime(p,0,T2);
t_ro = @(p,T2) GateTime(p,0,T2);%GateTime(p,0,1e-3);
% t_ro = 100e-6; % 100 us readout time for europium
% t_init = 10e-6; % 10 us init time

e_ro = 1e-5;
e_init = 1e-4;
t_dur_SQBG = 5e-6; % From adams paper (seems approx right)
t_dur_2QBG = 10e-6; % Should be reasonable, 2QBG uses 4 times as many pulses


%% Steane Code
%fid_shor = zeros(1,res);
fid_flag = zeros(1,res);

parfor i = 1:res
    [psi,rho] = LogStatePrep('Steane',LogState);
    %rho = NbitState(rho);
    %X_L = BuildOpMat('XXXXXXX');
    %not_psi = X_L*psi;
    p = p_err(i);
    p_cnot = p;
    p_SQG = p/10;
    rho.e_init = p_SQG*(2/3);
    rho.e_ro = p_SQG*(2/3);
    rho.sym_ro = 0;
    if inc_rest
        rho.T_2_hf = T_2_hf;
        t_rest = t_init(p,T_2_hf);
        rho.t_init = t_init(2*p,T_2_hf); 
        rho.t_ro = t_ro(20*p,T_2_hf); 
        t_dur_2QBG = t_init(2*p_cnot,T_2_hf);
        t_dur_SQBG = t_init(10*p_SQG,T_2_hf);
        c_phase_SQBG = 10*p_SQG;%DampCoeff(t_dur_SQBG, T_2_hf); % Phase damping coeff for SQBG
        c_phase_2QBG = 2*p_cnot%DampCoeff(t_dur_2QBG, T_2_hf); % -||- 2QBG
        [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,t_dur_2QBG,t_dur_SQBG,0,1); %Gate objects
        [cnot,cz] = SetDampCoeff(c_phase_2QBG,0,cnot,cz);
        [xgate,zgate,had] = SetDampCoeff(c_phase_SQBG,0,xgate,zgate,had);
    else
        rho.T_2_hf = 0;
        rho.t_init = 0; %t_init(p,T_2_hf); 
        rho.t_ro = 0; %t_ro(p,T_2_hf); 
        [cnot,cz,xgate,~,zgate,had] = MakeGates(0,0,0,0,0,0);
        [cnot,cz] = SetDampCoeff(0,0,cnot,cz);
        [xgate,zgate,had] = SetDampCoeff(0,0,xgate,zgate,had);
    end 

    
    [xgate,zgate,had] = SetErrDiff(p_SQG/3,p_SQG/3,p_SQG/3, xgate, zgate, had); 
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
fid_0_ro = fid_5qubit;
for i = 1:res
    [psi,rho] = LogStatePrep('5Qubit',LogState);
    p = p_err(i);
    p_cnot = p;
    p_SQG = p/10;
    rho.e_init = p_SQG*(2/3);
    rho.e_ro = p_SQG*(2/3);
    rho.sym_ro = 0;
    if inc_rest
        rho.T_2_hf = T_2_hf;
        t_rest = t_init;%(p,T_2_hf);
        rho.t_init = t_init(2*p,T_2_hf); 
        rho.t_ro = t_ro(20*p,T_2_hf); 
        t_dur_2QBG = t_init(2*p_cnot,T_2_hf);
        t_dur_SQBG = t_init(10*p_SQG,T_2_hf);
        c_phase_SQBG = 10*p_SQG;%DampCoeff(t_dur_SQBG, T_2_hf); % Phase damping coeff for SQBG
        c_phase_2QBG = 2*p_cnot;%DampCoeff(t_dur_2QBG, T_2_hf); % -||- 2QBG
        [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,t_dur_2QBG,t_dur_SQBG,0,1); %Gate objects
        [cnot,cz] = SetDampCoeff(c_phase_2QBG,0,cnot,cz);
        [xgate,ygate,zgate,had] = SetDampCoeff(c_phase_SQBG,0,xgate,ygate,zgate,had);
    else
        rho.T_2_hf = 0;
        rho.t_init = 0; %t_init(p,T_2_hf); 
        rho.t_ro = 0; %t_ro(p,T_2_hf); 
        [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,0,0,0,0);
        [cnot,cz] = SetDampCoeff(0,0,cnot,cz);
        [xgate,ygate,zgate,had] = SetDampCoeff(0,0,xgate,ygate,zgate,had);
    end 

    
    [xgate,ygate,zgate,had] = SetErrDiff(p_SQG/3,p_SQG/3,p_SQG/3, xgate,ygate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    

    
    [r,p_out] = CorrectError5qubit(rho,1,cnot,had,zgate,xgate,ygate);
    r_l = IdealDecode('5Qubit',r);
    fid_5qubit(i) = Fid2(n_psi,r_l);
    
end

%% Surface-17
fid_surf = zeros(1,res);
fid_L_surf = fid_surf;

parfor i = 1:res
    [psi,rho] = LogStatePrep('Surf17',LogState);
    X_L = BuildOpMat('IIXIXIXII');
    p = p_err(i);
    p_cnot = p;
    p_SQG = p/10;
    rho.e_init = p_SQG*(2/3);
    rho.e_ro = p_SQG*(2/3);
    rho.sym_ro = 0;
    if inc_rest
        rho.T_2_hf = T_2_hf;
        t_rest = t_init%(p,T_2_hf);
        rho.t_init = t_init(2*p,T_2_hf); 
        rho.t_ro = t_ro(20*p,T_2_hf); 
        t_dur_2QBG = t_init(2*p_cnot,T_2_hf);
        t_dur_SQBG = t_init(10*p_SQG,T_2_hf);
        c_phase_SQBG = 10*p_SQG;%DampCoeff(t_dur_SQBG, T_2_hf); % Phase damping coeff for SQBG
        c_phase_2QBG = 2*p_cnot%DampCoeff(t_dur_2QBG, T_2_hf); % -||- 2QBG
        [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,t_dur_2QBG,t_dur_SQBG,0,1); %Gate objects
        [cnot,cz] = SetDampCoeff(c_phase_2QBG,0,cnot,cz);
        [xgate,zgate,had] = SetDampCoeff(c_phase_SQBG,0,xgate,zgate,had);
    else
        rho.T_2_hf = 0;
        rho.t_init = 0; %t_init(p,T_2_hf); 
        rho.t_ro = 0; %t_ro(p,T_2_hf); 
        [cnot,cz,xgate,~,zgate,had] = MakeGates(0,0,0,0,0,0);
        [cnot,cz] = SetDampCoeff(0,0,cnot,cz);
        [xgate,zgate,had] = SetDampCoeff(0,0,xgate,zgate,had);
    end 

    
    [xgate,zgate,had] = SetErrDiff(p_SQG/3,p_SQG/3,p_SQG/3, xgate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);

    
    [rho,~] = CorrectionCycle(rho,'X',cnot,had,xgate,zgate,0);
    [rho,~] = CorrectionCycle(rho,'Z',cnot,had,xgate,zgate,0);
    log_rho = LogStateSurf17(rho);
    r_l = IdealDecode('Surf17',rho);
    fid_surf(i) = Fid2(n_psi,r_l);
end
save('final_0_2_resterr')
%% Fidelity Plot
figure();
%plot(p_err,fid_shor./p_err.^2);
hold on

plot(p_err,fid_5qubit./p_err.^0)
plot(p_err,fid_flag./p_err.^0);
plot(p_err,fid_surf./p_err.^0);
plot(p_err,p_err.^(1));
plot(p_err,p_err.^(2));
set(gca,'xscale','log')
set(gca,'yscale','log')
legend('[[5,1,3]] - flag','[[7,1,3]] - flag','[[9,1,3]] (Surface-17)','p_{err}','p_{err}^2')
xlabel('$p_{err}$')
title('Failure Probability without Rest Error |+>')
h = gca;
set(h.XLabel,'Interpreter','latex')
ylabel('Failure Probability/Error Rate')
set(h.YLabel,'Interpreter','latex')

save('final_0_2_resterr')
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
 