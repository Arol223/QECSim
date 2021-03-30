%% Saturation Spin T2, pseudo parallell
clear
clear GLOBAL
ngates = 1000; % From MSc thesis, 250 gives highest p_th with max gain
p_err = 0.25e-4; % Should be right above p_th for 250 gates
[cnot,cz,xgate,~,zgate,hadgate] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,1); %Gate objects
T_1_opt = 1.9e-3; % Optical T_1 for Eu
T_2_opt = 2.6e-3; % Optical T_2 for Eu at 10 mT
t_ro = 100e-6; % 100 us readout time for europium
t_init = 10e-6;
e_ro = 1e-5; % Readout error
e_init = p_err;

t_dur_SQBG = Gate_time(p_err, T_1_opt); % SQBG gate duration needed to get right error rate (~0.2 ms)
t_dur_2QBG = 4*t_dur_SQBG; % Should be reasonable, 2QBG uses 4 times as many pulses

p_b_SQBG = DampCoeff(t_dur_SQBG, T_1_opt); % p of bitflip error for SQBG
p_p_SQBG = DampCoeff(t_dur_SQBG, T_2_opt); % -||- phaseflip

p_b_2QBG = DampCoeff(t_dur_2QBG, T_1_opt);
p_p_2QBG = DampCoeff(t_dur_2QBG, T_2_opt);

[xgate,zgate,hadgate] = SetErrDiff(p_b_SQBG, p_p_SQBG, xgate, zgate, hadgate);
[cnot,cz] = SetErrDiff(p_b_2QBG, p_p_2QBG, cnot,cz);

T_2_spin = logspace(-3, 3, 4); % Logarithmically spaced values for spin T_2 between 1 ms and ~6 hours.

[psi_l,rho_l] = LogicalZeroSteane(); % Logical zero in matrix and vector form
rho_l.set_t_ro(t_ro); % Set readout time for state
rho_l.set_t_init(t_init) % Set initialisation time for ancillas

fid_l = zeros(1,length(T_2_spin)); % Fidelities for plotting
fid_EC = fid_l;

[xgate,zgate,hadgate] = SetErrDiff(p_b_SQBG, p_p_SQBG, xgate, zgate, hadgate);
[cnot, cz] = SetErrDiff(p_b_2QBG, p_p_2QBG, cnot, cz);

parfor i = 1:length(T_2_spin)
    
    [cnot,cz,xgate,~,zgate,hadgate] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,1); %Gate objects
    
    [xgate,zgate,hadgate] = SetErrDiff(p_b_SQBG, p_p_SQBG, xgate, zgate, hadgate);
    [cnot,cz] = SetErrDiff(p_b_2QBG, p_p_2QBG, cnot,cz);
    T_2_s = T_2_spin(i); % Use right value for spin T_2
    
    c_phase_SQBG = DampCoeff(t_dur_SQBG, T_2_s); % Phase damping coeff for SQBG
    c_phase_2QBG = DampCoeff(t_dur_2QBG, T_2_s); % -||- 2QBG
    
    
    
    [cnot,cz] = SetDampCoeff(c_phase_2QBG,0, cnot,cz); % Sets damping for 2QBG
    [xgate, zgate, hadgate] = SetDampCoeff(c_phase_SQBG,0, xgate, zgate, hadgate);
    rho_l.set_T2_hf(T_2_s); % Set spin T2 for rho_l
    
    rtmp = SteaneLogicalGate(rho_l,xgate,1);
    psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    for j = 2:ngates
        rtmp = SteaneLogicalGate(rtmp,xgate,1);
        psi_tmp = SteaneLogicalGate(psi_tmp,xgate,1);
    end
    fid_l(i) = 1 - Fid2(psi_tmp,rtmp);
    rtmp = Correct_steane_error(rtmp,1,'X',e_init,e_ro,hadgate,cnot,zgate,cz);
    rtmp = Correct_steane_error(rtmp,1,'Z',e_init,e_ro,hadgate,cnot,xgate,cz);
    fid_EC(i) = 1-Fid2(psi_tmp,rtmp);
end

% %% Physical gate GHZ-state
% [psi_p, rho_p] = GHZState(2);
% fid_phys_ghz = zeros(1,length(T_2_spin));
% for i = 1:length(T_2_spin)
%     T_2_s = T_2_spin(i); % Use right value for spin T_2
%
%     c_phase_SQBG = DampCoeff(t_dur_SQBG, T_2_s); % Phase damping coeff for SQBG
%     [xgate, zgate, hadgate] = SetDampCoeff(c_phase_SQBG,0, xgate, zgate, hadgate);
%     rtmp = xgate.apply(rho_p,1);
%     psitmp = xgate.apply(psi_p,1);
%
%     for j = 2:ngates
%         rtmp = xgate.apply(rtmp,1);
%         psitmp = xgate.apply(psitmp,1);
%     end
%     fid_phys_ghz(i) = 1-Fid2(psitmp,rtmp);
% end

%% Physical gate Single Qubit
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
