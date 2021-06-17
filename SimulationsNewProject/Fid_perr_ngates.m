clear
clear GLOBAL
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,7.7e-6,3.36e-6,0,0); %Gate objects
p_err = logspace(-4.3,-2.22,18);
p_log_pos = @(E) (E+1)/2; % measurement result is in -1,1, so this gives probability of measuring 1
p_log_neg = @(E) (-E+1)/2;


ngates = round(logspace(0, 3.4, 18));
L = length(ngates);

%% Physical gate
fid_phys = zeros(length(ngates),length(p_err));
p_err_tot = zeros(length(p_err),1);
for n = 1:length(ngates)
    ng = ngates(n);
    rho_p = NbitState([1 0;0 0]); %p for physical
    psi_p = [1; 0]; %p for physical
    
    for i = 1:length(p_err)
        p = p_err(i)/3;
        xgate.set_err(p,p,p);
        p_err_tot(i) = 1 - xgate.p_success;
        rtmp = xgate.apply(rho_p,1);
        psitmp = xgate.apply(psi_p,1);
      
        for j = 2:ng
            rtmp = xgate.apply(rtmp,1);
            psitmp = xgate.apply(psitmp,1);
            
        end
        fid_phys(n,i) = 1-Fid2(psitmp,rtmp);
        
    end
end
p_errL_phys = fid_phys;
% figure(1)
% mesh(ngates,p_err,fid_phys)
% hold on
% xlabel('n_{gates}')
% ylabel('p_{err}')
% zlabel('\epsilon_{fid}')
% set(gca,'XScale','log')
% set(gca,'YScale','log')
% set(gca,'ZScale','log')
%% Flag Steane


ngates = [1 ngates];
fid_EC_flag_Steane = zeros(length(p_err));
p_errL_flagSteane = zeros(length(p_err));
parfor i = 1:length(p_err)
    
    [rho_l,psi_l] = Log0FlagSteane();
    rho_l = NbitState(rho_l);
    rho_l.set_t_ro(0); % Set readout time for state
    rho_l.set_t_init(0) % Set initialisation time for ancillas
    rho_l.set_e_ro(0);
    rho_l.set_e_init(0);
    
    ngates = round(logspace(0, 3.4, 18))+1;%+1 to get the correct ngates in the k-loop
    ngates = [1 ngates];
    [cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,7.7e-6,3.36e-6,0,0);
    p_sqbg = p_err(i)/3;
    p_tqbg = 10*p_err(i);
    xgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    cnot.set_err_hom(p_tqbg);
    cz.set_err_hom(p_tqbg);
    zgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    hadgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    rho_l.set_e_ro(1e-5);
    rho_l.set_e_init(1e-4);
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate,ygate, hadgate] = SetDampCoeff(p,0, xgate, zgate,ygate, hadgate);
    
    
    %rtmp = SteaneLogicalGate(rho_l,xgate,1);
    %psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    rtmp = rho_l;
    psi_tmp = psi_l;
    gt_counts = 0;
    L = length(ngates)-1;
    for j = 1:18
       
        for k = ngates(j):ngates(j+1)-1
             rtmp = SteaneLogicalGate(rtmp,xgate,1);
             psi_tmp = SteaneLogicalGate(psi_tmp,xgate,1);
             gt_counts = gt_counts + 1;
        end
        [rtmp1,ptmp1] = FullFlagCorrection(rtmp,1,'X',cnot,hadgate,zgate,xgate);
        [rtmp1,ptmp2] = FullFlagCorrection(rtmp1,1,'Z',cnot,hadgate,xgate,zgate);
        fid_EC_flag_Steane(j,i) = 1-Fid2(psi_tmp,rtmp1);
        
        if ~mod(gt_counts,2)
            psiL =[1 0]';
        else
            psiL = [0 1]';
        end
        r = LogStateSteane(rtmp1);
        p_errL_flagSteane(j,i) = 1 - Fid2(psiL,r); %Logical fidelity
    end
    
end

gain_fid_flagSteane = fid_phys./fid_EC_flag_Steane;
gain_log_flagSteane = p_errL_phys./p_errL_flagSteane;
%% Steane, Shor extraction
fid_EC_shor_Steane = zeros(length(p_err));
p_errL_SteaneShor = zeros(length(p_err));
parfor i = 1:length(p_err)
    
    [rho_l,psi_l] = Log0FlagSteane();
    rho_l = NbitState(rho_l);
    rho_l.set_t_ro(0); % Set readout time for state
    rho_l.set_t_init(0) % Set initialisation time for ancillas
    rho_l.set_e_ro(0);
    rho_l.set_e_init(0);
    
   ngates = round(logspace(0, 3.4, 18))+1;
    ngates = [1 ngates];
    [cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,7.7e-6,3.36e-6,0,0);
    p_sqbg = p_err(i)/3;
    p_tqbg = 10*p_err(i);
    xgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    cnot.set_err_hom(p_tqbg);
    cz.set_err_hom(p_tqbg);
    zgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    hadgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    rho_l.set_e_ro(1e-5);
    rho_l.set_e_init(1e-4);
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate,ygate, hadgate] = SetDampCoeff(p,0, xgate, zgate,ygate, hadgate);
    
    
    %rtmp = SteaneLogicalGate(rho_l,xgate,1);
    %psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    rtmp = rho_l;
    psi_tmp = psi_l;
    gt_counts = 0;
    L = length(ngates) - 1;
    for j = 1:18
       
        for k = ngates(j):ngates(j+1)-1
             rtmp = SteaneLogicalGate(rtmp,xgate,1);
             psi_tmp = SteaneLogicalGate(psi_tmp,xgate,1);
             gt_counts = gt_counts + 1;
        end
       [rtmp1,ptmp1] = CorrectSteaneShorError(rtmp,1,'X',cnot,cz,hadgate,xgate,zgate);
       [rtmp1,ptmp2] = CorrectSteaneShorError(rtmp1,1,'Z',cnot,cz,hadgate,xgate,zgate);
       fid_EC_shor_Steane(j,i) = 1-Fid2(psi_tmp,rtmp1);
       
       if ~mod(gt_counts,2)
            psiL =[1 0]';
        else
            psiL = [0 1]';
        end
        r = LogStateSteane(rtmp1);
        p_errL_SteaneShor(j,i) = 1 - Fid2(psiL,r); %Logical fidelity
    end
    
end

gainfid_Shor = fid_phys./fid_EC_shor_Steane;
gainlog_SteaneShor = p_errL_phys./p_errL_SteaneShor;
%% 5-qubit

fid_EC_5qubit1 = zeros(length(p_err));
p_errL_5qubit = zeros(length(p_err));
parfor i = 1:length(p_err)
    
    [rho_l,psi_l] = Log0FiveQubit();
    rho_l = NbitState(rho_l);
    rho_l.set_t_ro(0); % Set readout time for state
    rho_l.set_t_init(0) % Set initialisation time for ancillas
    rho_l.set_e_ro(0);
    rho_l.set_e_init(0);

    
    
    
    ngates = round(logspace(0, 3.4, 18))+1;
    ngates = [1 ngates];
    [cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,7.7e-6, 3.36e-6,0,0); %Gate objects
    p_sqbg = p_err(i)/3;
    p_tqbg = 10*p_err(i);
    xgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    ygate.set_err(p_sqbg,p_sqbg,p_sqbg);
    cnot.set_err_hom(p_tqbg);
    cz.set_err_hom(p_tqbg);
    zgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    hadgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    rho_l.set_e_ro(1e-5);
    rho_l.set_e_init(1e-4);
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate,ygate, hadgate] = SetDampCoeff(p,0, xgate, zgate,ygate, hadgate);
    
    
    %rtmp = SteaneLogicalGate(rho_l,xgate,1);
    %psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    rtmp = rho_l;
    psi_tmp = psi_l;
    gt_counts = 0;
    L = length(ngates) - 1;
    for j = 1:18
       
        for k = ngates(j):ngates(j+1)-1
             rtmp = LogGate5Qubit(rtmp,'X',1,xgate,ygate,zgate);
             psi_tmp = xgate.apply(psi_tmp,1:5);
             gt_counts = gt_counts + 1;
        end
        [rtmp1,pout] = CorrectError5qubit(rtmp,1,cnot,hadgate,zgate,xgate,ygate);
        %rtmp2 = CorrectError(rtmp1,1,cnot,hadgate,zgate,xgate,ygate);
        fid_EC_5qubit1(j,i) = 1-Fid2(psi_tmp,rtmp1);
        %fid_EC_5qubit2(j,i) = 1-Fid2(psi_tmp,rtmp2);
        if ~mod(gt_counts,2)
            psiL =[1 0]';
        else
            psiL = [0 1]';
        end
        r = LogState5Qubit(rtmp1);
        p_errL_5qubit(j,i) = 1 - Fid2(psiL,r); %Logical fidelity
    end
    
end
%%
gain_5qubit1 = fid_phys./fid_EC_5qubit1;
gain_log5qubit2 = p_errL_phys./p_errL_5qubit;
%% Surf17
fid_EC_surf17 = zeros(length(p_err));
p_errL_surf17 = zeros(length(p_err));
parfor i = 1:length(p_err)
    
    [psi_l, rho_l] = Logical0Surf17();
    rho_l.set_t_ro(0); % Set readout time for state
    rho_l.set_t_init(0) % Set initialisation time for ancillas
    rho_l.set_e_ro(0);
    rho_l.set_e_init(0);

    
    
    
    ngates = round(logspace(0, 3.4, 18))+1;
    ngates = [1 ngates];
    [cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,7.7e-6,3.36e-6,0,0); %Gate objects
    p = p_err(i);
    p_sqbg = p_err(i)/3;
    p_tqbg = 10*p_err(i);
    xgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    cnot.set_err_hom(p_tqbg);
    cz.set_err_hom(p_tqbg);
    zgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    hadgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    rho_l.set_e_ro(1e-5);
    rho_l.set_e_init(1e-4);
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate,ygate, hadgate] = SetDampCoeff(p,0, xgate, zgate,ygate, hadgate);
    
    
    %rtmp = SteaneLogicalGate(rho_l,xgate,1);
    %psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    rtmp = rho_l;
    psi_tmp = psi_l;
    gt_counts = 0;
    L = length(ngates) - 1;
    for j = 1:18
       
        for k = ngates(j):ngates(j+1)-1
             rtmp = xgate.apply(rtmp,[3 5 7]);
             psi_tmp = xgate.apply(psi_tmp,[3 5 7]);
             gt_counts = gt_counts + 1;
        end
        rtmp1 = CorrectionCycle(rtmp,'X',cnot,hadgate,xgate,zgate,p^2*1e-3);
        rtmp1 = CorrectionCycle(rtmp1,'Z',cnot,hadgate,xgate,zgate,p^2*1e-3);
        %rtmp2 = CorrectError(rtmp1,1,cnot,hadgate,zgate,xgate,ygate);
        fid_EC_surf17(j,i) = 1-Fid2(psi_tmp,rtmp1);
        
        if ~mod(gt_counts,2)
            psiL =[1 0]';
        else
            psiL = [0 1]';
        end
        r = LogStateSurf17(rtmp1);
        p_errL_surf17(j,i) = 1 - Fid2(psiL,r); %Logical fidelity
    end
    
end

gain_fid_surf17 = fid_phys./fid_EC_surf17;
gain_logerr_surf17 = p_errL_phys./p_errL_surf17;

save('GainHomErr18x18')
%%
% p_err_tot = 2*p_err;
% bottom = min(min(min(gain_5qubit1)),min(min(gain_flag)));
% top = max(max(max(gain_5qubit1)),max(max(gain_flag)));
% subplot(1,2,1);
% h1 = pcolor(p_err_tot,logspace(0, 3.6, 12),gain_5qubit1);
% shading interp;
% caxis manual;
% caxis([bottom top]);
% 
% subplot(1,2,2);
% h2 = pcolor(p_err_tot,logspace(0, 3.6, 12),gain_flag);
% shading interp;
% caxis manual;
% caxis([bottom top]);