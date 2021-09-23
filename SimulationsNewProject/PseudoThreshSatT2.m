%% Saturation Spin T2, pseudo parallell
clear
n_res = 18;% resolution, number of data points


T_1_opt = 1.9e-3; % Optical T_1 for Eu
T_2_opt = 2.6e-3; % Optical T_2 for Eu at 10 mT
t_ro = 100e-6; % 100 us readout time for europium
t_init = 10e-6; % 10 us init time

 
% cnot_tol = 1e-16;
% cnot.tol = cnot_tol;

%[t_dur_SQBG,p_err_tot] = GateTime(p_err, T_1_opt,T_2_opt); % SQBG gate duration needed to get right error rate (~0.2 ms)
t_dur_SQBG = 5e-6; % From adams paper (seems approx right)
t_dur_2QBG = 10e-6; % Should be reasonable, 2QBG uses 4 times as many pulses

p_SQBG = 3.4e-4*1.5; %From Adams paper, 1.5 is to compensate for fid<perr 
e_init = p_SQBG*(2./3);
%p_b_SQBG = DampCoeff(t_dur_SQBG, T_1_opt); % p of bitflip error for SQBG
%p_p_SQBG = DampCoeff(t_dur_SQBG, T_2_opt); % -||- phaseflip

p_tqbg = 1.25*3e-3; %From Adams paper, 1.25 is to account for fidelity <p_err
e_ro = e_init; %  1e-5 Readout error
%p_b_2QBG = DampCoeff(t_dur_2QBG, T_1_opt);
%p_p_2QBG = DampCoeff(t_dur_2QBG, T_2_opt);

T_2_spin = logspace(-3, 3, n_res); % Logarithmically spaced values for spin T_2 between 1 ms and ~6 hours.
%% Determine ideal state
id_0 = [1;0];
id_1 = [0;1];
id_plus = (1/sqrt(2))*(id_0 + id_1);
id_min = (1/sqrt(2))*(id_0 - id_1);
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
end


%% 
fid_l = zeros(1,length(T_2_spin)); % Fidelities for plotting
fid_flag_steane = fid_l;
fid_5qubit = fid_l;
fid_surf17 = fid_l;

fid_log_FlagSteane = fid_l;
fid_log_5qubit = fid_l;
fid_log_surf17 = fid_l;
%% Steane, both extractions
parfor i = 1:length(T_2_spin)
    [psi_l,rho_l] = LogStatePrep('Steane',LogState); % Logical zero in matrix and vector form
    X_L = BuildOpMat('XXXXXXX');
    not_psi = X_L*psi_l;
    

    rho_l.set_t_ro(t_ro); % Set readout time for state
    rho_l.set_t_init(t_init); % Set initialisation time for ancillas
    rho_l.set_e_ro(e_ro);
    rho_l.set_e_init(e_init);
    [cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,t_dur_2QBG,t_dur_SQBG,0,1); %Gate objects
    [xgate,ygate,zgate,hadgate] = SetErrDiff(p_SQBG/3,p_SQBG/3,p_SQBG/3,xgate,ygate,zgate,hadgate);
    cnot = SetHomErr2QBG(p_tqbg,cnot);
    T_2_s = T_2_spin(i); % Use right value for spin T_2
    
    c_phase_SQBG = DampCoeff(t_dur_SQBG, T_2_s); % Phase damping coeff for SQBG
    c_phase_2QBG = DampCoeff(t_dur_2QBG, T_2_s); % -||- 2QBG
    rho_l.set_T2_hf(T_2_s); % Set spin T2 for rho_l
    
    
    [cnot] = SetDampCoeff(c_phase_2QBG,0, cnot); % Sets damping for 2QBG
    [xgate, zgate, hadgate] = SetDampCoeff(c_phase_SQBG,0, xgate, zgate, hadgate);
    
    [rtmp2,ptmp1] = FullFlagCorrection(rho_l,1,'X',cnot,hadgate,zgate,xgate);
    [rtmp2,ptmp2] = FullFlagCorrection(rtmp2,1,'Z',cnot,hadgate,xgate,zgate);
    

    %fid_flag_steane(i) = 1 - Fid2(psi_l,rtmp2);
    r_l = IdealDecode('Steane',rtmp2);
    fid_log_FlagSteane(i) = Fid2(n_psi,r_l);
    
    
    
end

%% 5 qubit
[psi_l,rho_l] = LogStatePrep('5Qubit',LogState); % Logical zero in matrix and vector form
%X_L = BuildOpMat('XXXXX');
%not_psi = X_L*psi_l;
%rho_l = NbitState(rho_l);
rho_l.set_t_ro(t_ro); % Set readout time for state
rho_l.set_t_init(t_init) % Set initialisation time for ancillas
rho_l.set_e_ro(e_ro);
rho_l.set_e_init(e_init);






for i = 1:length(T_2_spin)
    
    [cnot,~,xgate,ygate,zgate,hadgate] = MakeGates(0,0,t_dur_2QBG,t_dur_SQBG,0,1);
    [xgate,ygate,zgate,hadgate] = SetErrDiff(p_SQBG/3,p_SQBG/3,p_SQBG/3,xgate,ygate,zgate,hadgate);
    cnot = SetHomErr2QBG(p_tqbg,cnot);
    T_2_s = T_2_spin(i); % Use right value for spin T_2
    
    c_phase_SQBG = DampCoeff(t_dur_SQBG, T_2_s); % Phase damping coeff for SQBG
    c_phase_2QBG = DampCoeff(t_dur_2QBG, T_2_s); % -||- 2QBG
    rho_l.set_T2_hf(T_2_s); % Set spin T2 for rho_l
    
    
    [cnot] = SetDampCoeff(c_phase_2QBG,0, cnot); % Sets damping for 2QBG
    [xgate, zgate, hadgate,ygate] = SetDampCoeff(c_phase_SQBG,0, xgate, zgate, hadgate,ygate);
    

    [rtmp, ptmp] = CorrectError5qubit(rho_l,1,cnot,hadgate,zgate,xgate,ygate);
    
    r_l = IdealDecode('5Qubit',rtmp);
    fid_log_5qubit(i) = Fid2(n_psi,r_l);
    
end

%% Surface 17


parfor i = 1:length(T_2_spin)
    
    [psi_l, rho_l] = LogStatePrep('Surf17',LogState); % Logical zero in matrix and vector form
    X_L = BuildOpMat('IIXIXIXII');
    not_psi = X_L*psi_l;
    
    rho_l.set_t_ro(t_ro); % Set readout time for state
    rho_l.set_t_init(t_init) % Set initialisation time for ancillas
    rho_l.set_e_ro(e_ro);
    rho_l.set_e_init(e_init);
    
    [cnot,~,xgate,~,zgate,hadgate] = MakeGates(0,0,t_dur_2QBG,t_dur_SQBG,0,1); %Gate objects
    [xgate,zgate,hadgate] = SetErrDiff(p_SQBG/3,p_SQBG/3,p_SQBG/3,xgate,zgate,hadgate);
    cnot = SetHomErr2QBG(p_tqbg,cnot);
    T_2_s = T_2_spin(i); % Use right value for spin T_2
    
    c_phase_SQBG = DampCoeff(t_dur_SQBG, T_2_s); % Phase damping coeff for SQBG
    c_phase_2QBG = DampCoeff(t_dur_2QBG, T_2_s); % -||- 2QBG
    rho_l.set_T2_hf(T_2_s); % Set spin T2 for rho_l
    
    
    [cnot] = SetDampCoeff(c_phase_2QBG,0, cnot); % Sets damping for 2QBG
    [xgate, zgate, hadgate] = SetDampCoeff(c_phase_SQBG,0, xgate, zgate, hadgate);
    
    [rtmp, ~] = CorrectionCycle(rho_l,'X',cnot,hadgate,xgate,zgate,0);%1e-3*p_tqbg^2);
    [rtmp, ~] = CorrectionCycle(rtmp,'Z',cnot,hadgate,xgate,zgate,0);%1e-3*p_tqbg^2);

    r_l = IdealDecode('Surf17',rtmp);
    
    fid_log_surf17(i) = Fid2(n_psi,r_l);
end


%% plotting


figure()
hold on
T2rat = T_2_spin./T_2_opt;
plot(T2rat,fid_log_FlagSteane)
%plot(T2rat,fid_flag_steane,'--b')

plot(T2rat,(fid_log_5qubit))
%plot(T2rat,fid_5qubit,'--r')

plot(T2rat,(fid_log_surf17))
%plot(T2rat,fid_surf17,'--m')

plot(T2rat,p_tqbg*ones(1,n_res));
%semilogx(T2rat,fid_l)
%semilogx(T2rat,fid_phys_ghz)

set(gca,'xscale','log')
set(gca,'yscale','log')
legend('[7,1,3], flag extraction',...
    '[5,1,3], flag extraction','Surface17','CNot Error Rate')
ylabel('Logical Error Fidelity')
xlabel('T_{2, spin}/T_{2, optical}')
title('Error Fidelity and Fidelity Error')

save('final_0')