clear

[cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0); %Gate objects
p_err = logspace(-8,-2,6);
ngates = 0;
%% Physical gate
rho_p = NbitState([1 0;0 0]); %p for physical
psi_p = [1; 0]; %p for physical
fid_phys = zeros(1,length(p_err));
for i = 1:length(p_err)
    p = p_err(i);
    xgate.set_err(p,p);
    rtmp = xgate.apply(rho_p,1);
    psitmp = xgate.apply(psi_p,1);
    
    for j = 2:ngates
        rtmp = xgate.apply(rtmp,1);
        psitmp = xgate.apply(psitmp,1);
    end
    fid_phys(i) = 1-Fid2(psitmp,rtmp);
end

%% Flag extraction

[rho_l,psi_l] = Log0FlagSteane();
rho_l = NbitState(rho_l);
rho_l.set_t_ro(0); % Set readout time for state
rho_l.set_t_init(0) % Set initialisation time for ancillas
rho_l.set_e_ro(0);
rho_l.set_e_init(0);

fid_l = zeros(1,length(p_err));
fid_EC = fid_l;
parfor i = 1:length(p_err)
    [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0); %Gate objects
    p = p_err(i);
    xgate.set_err(p,p);
    cnot.set_err(4*p,4*p);
    zgate.set_err(p,p);
    had.set_err(p,p);
    rho_l.set_e_ro(p);
    rho_l.set_e_init(p);
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate,ygate, had] = SetDampCoeff(p,0, xgate, zgate,ygate, had);
    
    
    %rtmp = SteaneLogicalGate(rho_l,xgate,1);
    %psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    rtmp = rho_l;
    psi_tmp = psi_l;
    for j = 1:ngates
        rtmp = SteaneLogicalGate(rtmp,xgate,1);
        psi_tmp = SteaneLogicalGate(psi_tmp,xgate,1);
    end
    fid_l(i) =1- Fid2(psi_tmp,rtmp);
    [rtmp,ptmp1] = FullFlagCorrection(rtmp,1,'X',cnot,had,zgate,xgate);
    [rtmp,ptmp2] = FullFlagCorrection(rtmp,1,'Z',cnot,had,xgate,zgate);
    fid_EC(i) = 1-Fid2(psi_tmp,rtmp);
end

%% Shor extraction
[psi_l,rho_l] = LogicalZeroSteane();
rho_l.set_t_ro(0); % Set readout time for state
rho_l.set_t_init(0) % Set initialisation time for ancillas
rho_l.set_e_ro(0);
rho_l.set_e_init(0);

fid_l = zeros(1,length(p_err));
fid_EC_shor = fid_l;
parfor i = 1:length(p_err)
    [cnot,cz,xgate,~,zgate,had] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0); %Gate objects
    p = p_err(i);
    xgate.set_err(p,p);
    cnot.set_err(4*p,4*p);
    cz.set_err(4*p,4*p);
    zgate.set_err(p,p);
    had.set_err(p,p);
    rho_l.set_e_ro(p);
    rho_l.set_e_init(p);

    
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate, had] = SetDampCoeff(p,0, xgate, zgate, had);
    rtmp = rho_l;
    psi_tmp = psi_l;
    for j = 2:ngates
        rtmp = SteaneLogicalGate(rtmp,xgate,1);
        psi_tmp = SteaneLogicalGate(psi_tmp,xgate,1);
    end
    fid_l(i) =1- Fid2(psi_tmp,rtmp);
    rtmp = Correct_steane_error(rtmp,1,'X',p,p,had,cnot,zgate,cz);
    rtmp = Correct_steane_error(rtmp,1,'Z',p,p,had,cnot,xgate,cz);
    fid_EC_shor(i) = 1-Fid2(psi_tmp,rtmp);
end

%% Five Qubit
[rho_l,psi_l] = Log0FiveQubit();
rho_l = NbitState(rho_l);
rho_l.set_t_ro(0); % Set readout time for state
rho_l.set_t_init(0) % Set initialisation time for ancillas
rho_l.set_e_ro(0);
rho_l.set_e_init(0);

fid_l_fivebit = zeros(1,length(p_err));
fid_EC_fivebit = fid_l;
for i = 1:length(p_err)
    [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0); %Gate objects
    p = p_err(i);
    xgate.set_err(p,p);
    cnot.set_err(4*p,4*p);
    cz.set_err(4*p,4*p);
    zgate.set_err(p,p);
    had.set_err(p,p);
    rho_l.set_e_ro(p);
    rho_l.set_e_init(p);

    
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate, ygate,had] = SetDampCoeff(p,0, xgate, zgate,ygate, had);
    rtmp = rho_l;
    psi_tmp = psi_l;
    for j = 1:ngates
        rtmp = xgate.apply(rtmp,1:5);
        psi_tmp = xgate.apply(psi_tmp,1:5);
    end
    fid_l_fivebit(i) =1- Fid2(psi_tmp,rtmp);
    rtmp = CorrectError(rtmp,1,cnot,had,zgate,xgate,ygate);
    fid_EC_fivebit(i) = 1-Fid2(psi_tmp,rtmp);
end


%% Surface17



fid_l_surf = zeros(1,length(p_err));
fid_EC_surf = fid_l_surf;
parfor i = 1:length(p_err)
    [psi_l, rho_l] = Logical0Surf17();
    rho_l.set_t_ro(0); % Set readout time for state
    rho_l.set_t_init(0) % Set initialisation time for ancillas
    rho_l.set_e_ro(0);
    rho_l.set_e_init(0);
    
    [cnot,cz,xgate,ygate,zgate,had] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0); %Gate objects
    p = p_err(i);
    xgate.set_err(p,p);
    cnot.set_err(4*p,4*p);
    cz.set_err(4*p,4*p);
    zgate.set_err(p,p);
    had.set_err(p,p);
    rho_l.set_e_ro(p);
    rho_l.set_e_init(p);

    
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate, ygate,had] = SetDampCoeff(p,0, xgate, zgate,ygate, had);
    rtmp = rho_l;
    psi_tmp = psi_l;
    for j = 1:ngates
        rtmp = xgate.apply(rtmp,[3 5 7]);
        psi_tmp = xgate.apply(psi_tmp,[3 5 7]);
    end
    fid_l_surf(i) =1- Fid2(psi_tmp,rtmp);
    [rtmp,~] = CorrectionCycle(rtmp,'X',cnot,had,xgate,zgate);
    [rtmp,~] = CorrectionCycle(rtmp,'Z',cnot,had,xgate,zgate);
    fid_EC_surf(i) = 1-Fid2(psi_tmp,rtmp);
end


%% Plotting
%loglog(p_err,fid_phys)
hold on
%loglog(p_err,fid_l)
loglog(p_err,fid_EC)
loglog(p_err,fid_EC_shor)
loglog(p_err,fid_EC_fivebit)
loglog(p_err,fid_EC_surf)
xlabel('Error rate')
ylabel('\epsilon_{fid}')
title('\epsilon_{fid} vs p_{err}, cnot error = 4p_{err}')
legend('Steanecode, flag extraction', '-||-, Shor extraction', '5-qubit, flag extraction')