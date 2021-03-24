clear

[cnot,cz,xgate,~,zgate,hadgate] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0); %Gate objects
p_err = logspace(-9,-3,5);
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
for i = 1:length(p_err)
    [cnot,cz,xgate,~,zgate,hadgate] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0); %Gate objects
    p = p_err(i);
    xgate.set_err(p,p);
    cnot.set_err(p,p);
    zgate.set_err(p,p);
    hadgate.set_err(p,p);
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate, hadgate] = SetDampCoeff(p,0, xgate, zgate, hadgate);
    
    
    %rtmp = SteaneLogicalGate(rho_l,xgate,1);
    %psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    rtmp = rho_l;
    psi_tmp = psi_l;
    for j = 2:ngates
        rtmp = SteaneLogicalGate(rtmp,xgate,1);
        psi_tmp = SteaneLogicalGate(psi_tmp,xgate,1);
    end
    fid_l(i) =1- Fid2(psi_tmp,rtmp);
    [rtmp,ptmp1] = FullFlagCorrection(rtmp,1,'X',cnot,hadgate,zgate,xgate);
    [rtmp,ptmp2] = FullFlagCorrection(rtmp,1,'Z',cnot,hadgate,xgate,zgate);
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
for i = 1:length(p_err)
    p = p_err(i);
    xgate.set_err(p,p);
    cnot.set_err(p,p);
    cz.set_err(p,p);
    zgate.set_err(p,p);
    hadgate.set_err(p,p);
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate, hadgate] = SetDampCoeff(p,0, xgate, zgate, hadgate);
    rtmp = rho_l;
    psi_tmp = psi_l;
    for j = 2:ngates
        rtmp = SteaneLogicalGate(rtmp,xgate,1);
        psi_tmp = SteaneLogicalGate(psi_tmp,xgate,1);
    end
    fid_l(i) =1- Fid2(psi_tmp,rtmp);
    rtmp = Correct_steane_error(rtmp,1,'X',p,p,hadgate,cnot,zgate,cz);
    rtmp = Correct_steane_error(rtmp,1,'Z',p,p,hadgate,cnot,xgate,cz);
    fid_EC_shor(i) = 1-Fid2(psi_tmp,rtmp);
end


%% Plotting
%loglog(p_err,fid_phys)
hold on
%loglog(p_err,fid_l)
loglog(p_err,fid_EC)
xlabel('Error rate')
ylabel('\epsilon_{fid}')
title('\epsilon_{fid} vs p_{err} for 6 SQBG, physical, logical and logical with EC')
legend('Logical SQBG','Logical SQBG w/ EC')