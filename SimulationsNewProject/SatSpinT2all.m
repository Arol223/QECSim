%% Saturation Spin T2, pseudo parallell
clear
clear GLOBAL
n_res = 3;% resolution, number of data points
ngates = 100; % From MSc thesis, 250 gives highest p_th with max gain
p_err = 1e-4; % Should be right above p_th for 250 gates

T_1_opt = 1.9e-3; % Optical T_1 for Eu
T_2_opt = 2.6e-3; % Optical T_2 for Eu at 10 mT
t_ro = 100e-6; % 100 us readout time for europium
t_init = 10e-6; % 10 us init time
e_ro = 1e-5; %  1e-5 Readout error
e_init = p_err; 
% cnot_tol = 1e-16;
% cnot.tol = cnot_tol;

%[t_dur_SQBG,p_err_tot] = GateTime(p_err, T_1_opt,T_2_opt); % SQBG gate duration needed to get right error rate (~0.2 ms)
t_dur_SQBG = 3.3e-6; % From adams paper (seems approx right)
t_dur_2QBG = 7.7e-6; % Should be reasonable, 2QBG uses 4 times as many pulses

p_b_SQBG = p_err/3;
p_p_SQBG = p_err/3;
%p_b_SQBG = DampCoeff(t_dur_SQBG, T_1_opt); % p of bitflip error for SQBG
%p_p_SQBG = DampCoeff(t_dur_SQBG, T_2_opt); % -||- phaseflip

p_tqbg = 1*p_err;

%p_b_2QBG = DampCoeff(t_dur_2QBG, T_1_opt);
%p_p_2QBG = DampCoeff(t_dur_2QBG, T_2_opt);

T_2_spin = logspace(-3, 3, n_res); % Logarithmically spaced values for spin T_2 between 1 ms and ~6 hours.


%% 
fid_l = zeros(1,length(T_2_spin)); % Fidelities for plotting
fid_ECShor = fid_l;
fid_ECFlag = fid_l;

fid_log_ShorSteane = fid_l;
fid_log_FlagSteane = fid_l;
fid_log_5qubit = fid_l;
fid_log_surf17 = fid_l;
%% Steane, both extractions
parfor i = 1:length(T_2_spin)
    [rho_l,psi_l] = Log0FlagSteane(); % Logical zero in matrix and vector form
    rho_l = NbitState(rho_l);
    rho_l.set_t_ro(t_ro); % Set readout time for state
    rho_l.set_t_init(t_init); % Set initialisation time for ancillas
    rho_l.set_e_ro(e_ro);
    rho_l.set_e_init(e_init);
    [cnot,cz,xgate,~,zgate,hadgate] = MakeGates(0,0,t_dur_2QBG,t_dur_SQBG,0,1); %Gate objects
    [xgate,zgate,hadgate] = SetT12Errs(t_dur_SQBG,T_1_opt,T_2_opt, xgate,zgate,hadgate);
    [cnot,cz] = SetT12Errs(t_dur_2QBG,T_1_opt,T_2_opt,cnot,cz);
    T_2_s = T_2_spin(i); % Use right value for spin T_2
    
    c_phase_SQBG = DampCoeff(t_dur_SQBG, T_2_s); % Phase damping coeff for SQBG
    c_phase_2QBG = DampCoeff(t_dur_2QBG, T_2_s); % -||- 2QBG
    rho_l.set_T2_hf(T_2_s); % Set spin T2 for rho_l
    
    
    [cnot,cz] = SetDampCoeff(c_phase_2QBG,0, cnot,cz); % Sets damping for 2QBG
    [xgate, zgate, hadgate] = SetDampCoeff(c_phase_SQBG,0, xgate, zgate, hadgate);
    
    rtmp = SteaneLogicalGate(rho_l,xgate,1);
    psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    for j = 2:ngates
        rtmp = SteaneLogicalGate(rtmp,xgate,1);
        psi_tmp = SteaneLogicalGate(psi_tmp,xgate,1);
    end
    fid_l(i) = 1 - Fid2(psi_tmp,rtmp);
    [rtmp1,~] = CorrectSteaneShorError(rtmp,1,'X',cnot,cz,hadgate,xgate,zgate);
    [rtmp1,~] = CorrectSteaneShorError(rtmp1,1,'Z',cnot,cz,hadgate,xgate,zgate);
    [rtmp2,ptmp1] = FullFlagCorrection(rtmp,1,'X',cnot,hadgate,zgate,xgate);
    [rtmp2,ptmp2] = FullFlagCorrection(rtmp2,1,'Z',cnot,hadgate,xgate,zgate);
    fid_ECFlag(i) = 1-Fid2(psi_tmp,rtmp2); % These were switched, kept like this for reference 
    fid_ECShor(i) = 1-Fid2(psi_tmp,rtmp1);
    
    r_shor = LogStateSteane(rtmp1);
    r_flag = LogStateSteane(rtmp2);
    
    if ~mod(ngates,2)
        p =[1 0]';
    else
        p = [0 1]';
    end
    fid_log_ShorSteane(i) = 1 - Fid2(p,r_shor);
    fid_log_FlagSteane(i) = 1 - Fid2(p,r_flag);
    
end

%% 5 qubit
[rho_l,psi_l] = Log0FiveQubit(); % Logical zero in matrix and vector form
rho_l = NbitState(rho_l);
rho_l.set_t_ro(t_ro); % Set readout time for state
rho_l.set_t_init(t_init) % Set initialisation time for ancillas
rho_l.set_e_ro(e_ro);
rho_l.set_e_init(e_init);

fid_l = zeros(1,length(T_2_spin)); % Fidelities for plotting
fid_EC5qubit = fid_l;



for i = 1:length(T_2_spin)
    
    [cnot,~,xgate,ygate,zgate,hadgate] = MakeGates(0,0,t_dur_2QBG,t_dur_SQBG,0,1);
    [xgate,ygate,zgate,hadgate] = SetT12Errs(t_dur_SQBG,T_1_opt,T_2_opt, xgate,ygate,zgate,hadgate);
    [cnot] = SetT12Errs(t_dur_2QBG,T_1_opt,T_2_opt,cnot);
    T_2_s = T_2_spin(i); % Use right value for spin T_2
    
    c_phase_SQBG = DampCoeff(t_dur_SQBG, T_2_s); % Phase damping coeff for SQBG
    c_phase_2QBG = DampCoeff(t_dur_2QBG, T_2_s); % -||- 2QBG
    rho_l.set_T2_hf(T_2_s); % Set spin T2 for rho_l
    
    
    [cnot] = SetDampCoeff(c_phase_2QBG,0, cnot); % Sets damping for 2QBG
    [xgate, zgate, hadgate,ygate] = SetDampCoeff(c_phase_SQBG,0, xgate, zgate, hadgate,ygate);
    
    rtmp = LogGate5Qubit(rho_l,'X',1,xgate,ygate,zgate);
    psi_tmp = xgate.apply(psi_l,1:5);
    for j = 2:ngates
        rtmp = LogGate5Qubit(rtmp,'X',1,xgate,ygate,zgate);
        psi_tmp = xgate.apply(psi_tmp,1:5);
    end
    fid_l(i) = 1 - Fid2(psi_tmp,rtmp);
    [rtmp, ptmp] = CorrectError5qubit(rtmp,1,cnot,hadgate,zgate,xgate,ygate);
    fid_EC5qubit(i) = 1-Fid2(psi_tmp,rtmp);
    
    r = LogState5Qubit(rtmp);
    
    if ~mod(ngates,2)
        p =[1 0]';
    else
        p = [0 1]';
    end
    fid_log_5qubit(i) = 1 - Fid2(p,r);
end

%% Surface 17
fid_l = zeros(1,length(T_2_spin)); % Fidelities for plotting
fid_ECSurf17 = fid_l;
parfor i = 1:length(T_2_spin)
    ngates = 100;
    
    [psi_l, rho_l] = Logical0Surf17(); % Logical zero in matrix and vector form
    rho_l.set_t_ro(t_ro); % Set readout time for state
    rho_l.set_t_init(t_init) % Set initialisation time for ancillas
    rho_l.set_e_ro(e_ro);
    rho_l.set_e_init(e_init);
    
    [cnot,~,xgate,~,zgate,hadgate] = MakeGates(0,0,t_dur_2QBG,t_dur_SQBG,0,1); %Gate objects
    [xgate,zgate,hadgate] = SetT12Errs(t_dur_SQBG,T_1_opt,T_2_opt, xgate,zgate,hadgate);
    [cnot] = SetT12Errs(t_dur_2QBG,T_1_opt,T_2_opt,cnot);
    T_2_s = T_2_spin(i); % Use right value for spin T_2
    
    c_phase_SQBG = DampCoeff(t_dur_SQBG, T_2_s); % Phase damping coeff for SQBG
    c_phase_2QBG = DampCoeff(t_dur_2QBG, T_2_s); % -||- 2QBG
    rho_l.set_T2_hf(T_2_s); % Set spin T2 for rho_l
    
    
    [cnot] = SetDampCoeff(c_phase_2QBG,0, cnot); % Sets damping for 2QBG
    [xgate, zgate, hadgate] = SetDampCoeff(c_phase_SQBG,0, xgate, zgate, hadgate);
    
    rtmp = xgate.apply(rho_l,[3 5 7]);
    psi_tmp = xgate.apply(psi_l,[3 5 7]);
    for j = 2:ngates
        rtmp = xgate.apply(rtmp,[3 5 7]);
        psi_tmp = xgate.apply(psi_tmp,[3 5 7]);
    end
    
    [rtmp, ~] = CorrectionCycle(rtmp,'X',cnot,hadgate,xgate,zgate,1e-3*p_err^2);
    [rtmp, ~] = CorrectionCycle(rtmp,'Z',cnot,hadgate,xgate,zgate,1e-3*p_err^2);
    fid_ECSurf17(i) = 1-Fid2(psi_tmp,rtmp);
    
    r = LogStateSurf17(rtmp);
    
    if ~mod(ngates,2)
        p =[1 0]';
    else
        p = [0 1]';
    end
    fid_log_surf17(i) = 1 - Fid2(p,r);
end
%% Physical gate Single Qubit
[cnot,cz,xgate,~,zgate,hadgate] = MakeGates(0,0,t_dur_2QBG,t_dur_SQBG,0,0); %Gate objects
[xgate,zgate,hadgate] = SetT12Errs(t_dur_SQBG,T_1_opt,T_2_opt, xgate,zgate,hadgate);
% [cnot,cz] = SetHomErr2QBG(p_tqbg, cnot,cz);



psi_p = [1;0];
rho_p = NbitState(psi_p*psi_p');
fid_phys_single = zeros(1,length(T_2_spin));
for i = 1:length(T_2_spin)
    T_2_s = T_2_spin(i); % Use right value for spin T_2
    
    c_phase_SQBG = DampCoeff(t_dur_SQBG, T_2_s); % Phase damping coeff for SQBG
    [xgate, zgate, hadgate] = SetDampCoeff(c_phase_SQBG,0, xgate, zgate, hadgate);
    rtmp = xgate.apply(rho_p,1);
    psitmp = xgate.apply(psi_p,1);
    
    for j = 2:ngates
        rtmp = xgate.apply(rtmp,1);
        psitmp = xgate.apply(psitmp,1);
    end
    fid_phys_single(i) = 1-Fid2(psitmp,rtmp);
end


%% plotting

figure()
hold on
T2rat = T_2_spin./T_2_opt;
plot(T2rat,fid_ECFlag./ngates)
plot(T2rat,fid_ECShor./ngates)
plot(T2rat,fid_EC5qubit./ngates)
plot(T2rat,fid_ECSurf17./ngates)
%semilogx(T2rat,fid_l)
%semilogx(T2rat,fid_phys_ghz)
plot(T2rat,fid_phys_single./ngates)
set(gca,'xscale','log')
set(gca,'yscale','log')
legend('[7,1,3], flag extraction','[7,1,3], Shor extraction',...
    '[5,1,3], flag extraction','Surface17','Physical, 1bit')
ylabel('\epsilon_{Fid}')
xlabel('T_{2, spin}/T_{2, optical}')
title('Physical fidelity error') 
figure()
hold on
T2rat = T_2_spin./T_2_opt;
plot(T2rat,(fid_log_FlagSteane)./ngates)
plot(T2rat,(fid_log_ShorSteane)./ngates)
plot(T2rat,(fid_log_5qubit)./ngates)
plot(T2rat,(fid_log_surf17)./ngates)
%semilogx(T2rat,fid_l)
%semilogx(T2rat,fid_phys_ghz)
plot(T2rat,fid_phys_single./ngates)
set(gca,'xscale','log')
set(gca,'yscale','log')
legend('[7,1,3], flag extraction','[7,1,3], Shor extraction',...
    '[5,1,3], flag extraction','Surface17','Physical, 1bit')
ylabel('\epsilon_{Fid}')
xlabel('T_{2, spin}/T_{2, optical}')
title('Logical fidelity error')