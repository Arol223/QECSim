clear
clear GLOBAL
%% Set p_err, resolution and ngates
n_points_p = 24;
n_points_g = 18;
g_max = 500; % Max number of gates
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,7.7e-6,3.36e-6,0,0); %Gate objects
%p_err = [logspace(-5,-4,(16+2)/2) logspace(-2, -1,(16+2)/2)];
%p_err(9:10) = [];
%p_err = [p_err(1:8) logspace(-4,-2,18) p_err(9:end)];
p_err = logspace(-5,-1,n_points_p);
ngates = round(linspace(1,g_max,n_points_g));




%% Decide logical states

id_0 = [1;0];
id_1 = [0;1];
id_plus = (1/sqrt(2))*(id_0 + id_1);
id_min = (1/sqrt(2))*(id_0 - id_1);
LogState = '0';


switch LogState  %Determine what the wrong state is
    case '0'
        n_psi = id_1;
        psi_p = id_0;
    case '1'
        psi_p = id_1;
        n_psi = id_0;
    case '+'
        psi_p = id_plus;
        n_psi = id_min;
    case '-'
        psi_p = id_min;
        n_psi = id_plus;
end

%% Physical gate
fid_phys = zeros(length(ngates),length(p_err));
p_err_tot = zeros(length(p_err),1);
for n = 1:length(ngates)
    ng = ngates(n);
    rho_p = NbitState(psi_p*psi_p'); %p for physical
    
    for i = 1:length(p_err)
        p = p_err(i)/30; %10 times smaller than for 2qbg
        xgate.set_err(p,p,p);
        p_err_tot(i) = 10*(1 - xgate.p_success);
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
p_errL_flagSteane = zeros(n_points_g,n_points_p);
parfor i = 1:n_points_p
    
    [psi_l,rho_l] = LogStatePrep('Steane',LogState);
    rho_l.set_t_ro(0); % Set readout time for state
    rho_l.set_t_init(0) % Set initialisation time for ancillas
    
    %ngates = round(logspace(0, 2.5, 6))+1;%+1 to get the correct ngates in the k-loop
    %ngates = [1 ngates];
    [cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,7.7e-6,3.36e-6,0,0);
    p_sqbg = p_err(i)/30;
    p_tqbg = p_err(i);
    xgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    cnot.set_err_hom(p_tqbg);
    cz.set_err_hom(p_tqbg);
    zgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    hadgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    rho_l.set_e_ro(2*p_sqbg);
    rho_l.set_e_init(2*p_sqbg);
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate,ygate, hadgate] = SetDampCoeff(p,0, xgate, zgate,ygate, hadgate);
    
    
    %rtmp = SteaneLogicalGate(rho_l,xgate,1);
    %psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    rtmp = rho_l;
    psi_tmp = psi_l;
    gt_counts = 0;
    L = length(ngates)-1;
    for j = 1:n_points_g
       
        for k = ngates(j):ngates(j+1)-1
             rtmp = SteaneLogicalGate(rtmp,xgate,1);
             psi_tmp = SteaneLogicalGate(psi_tmp,xgate,1);
             gt_counts = gt_counts + 1;
        end
        [rtmp1,ptmp1] = FullFlagCorrection(rtmp,1,'X',cnot,hadgate,zgate,xgate);
        [rtmp1,ptmp2] = FullFlagCorrection(rtmp1,1,'Z',cnot,hadgate,xgate,zgate);
        
        
        if mod(gt_counts,2)
            psiL = psi_p;
        else
            psiL = n_psi;
        end
        r_l = IdealDecode('Steane',rtmp1);
        p_errL_flagSteane(j,i) = Fid2(psiL,r_l); %Logical fidelity
    end
    
end
%%
gain_log_flagSteane = p_errL_phys./p_errL_flagSteane;

%% 5-qubit
p_errL_5qubit = zeros(n_points_g,n_points_p);
%ngates = [1 ngates];
parfor i = 1:n_points_p
    
    [psi_l,rho_l] = LogStatePrep('5Qubit',LogState);
    rho_l.set_t_ro(0); % Set readout time for state
    rho_l.set_t_init(0) % Set initialisation time for ancillas


    
    
    
%    ngates = round(logspace(0, 2.5, 6))+1;
%     ngates = [1 ngates];
    [cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,7.7e-6, 3.36e-6,0,0); %Gate objects
    p_sqbg = p_err(i)/30;
    p_tqbg = p_err(i);
    xgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    ygate.set_err(p_sqbg,p_sqbg,p_sqbg);
    cnot.set_err_hom(p_tqbg);
    cz.set_err_hom(p_tqbg);
    zgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    hadgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    rho_l.set_e_ro(2*p_sqbg);
    rho_l.set_e_init(2*p_sqbg);
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate,ygate, hadgate] = SetDampCoeff(p,0, xgate, zgate,ygate, hadgate);
    
    
    %rtmp = SteaneLogicalGate(rho_l,xgate,1);
    %psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    rtmp = rho_l;
    psi_tmp = psi_l;
    gt_counts = 0;
    L = length(ngates) - 1;
    for j = 1:n_points_g
       
        for k = ngates(j):ngates(j+1)-1
             rtmp = LogGate5Qubit(rtmp,'X',1,xgate,ygate,zgate);
             psi_tmp = xgate.apply(psi_tmp,1:5);
             gt_counts = gt_counts + 1;
        end
        [rtmp1,pout] = CorrectError5qubit(rtmp,1,cnot,hadgate,zgate,xgate,ygate);

        if mod(gt_counts,2)
            psiL = psi_p;
        else
            psiL = n_psi;
        end
        r_l = IdealDecode('5Qubit',rtmp1);
        p_errL_5qubit(j,i) = Fid2(psiL,r_l); %Logical fidelity
    end
    
end
%%
gain_log5qubit2 = p_errL_phys./p_errL_5qubit;
%% Surf17
p_errL_surf17 = zeros(n_points_g,n_points_p);
parfor i = 1:n_points_p
    
    [psi_l,rho_l] = LogStatePrep('Surf17',LogState);
    rho_l.set_t_ro(0); % Set readout time for state
    rho_l.set_t_init(0) % Set initialisation time for ancillas

    
    
    
%     ngates = round(logspace(0, 2.5, 6))+1;
%     ngates = [1 ngates];
    [cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,7.7e-6,3.36e-6,0,0); %Gate objects
    p = p_err(i);
    p_sqbg = p_err(i)/30;
    p_tqbg = p_err(i);
    xgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    cnot.set_err_hom(p_tqbg);
    cz.set_err_hom(p_tqbg);
    zgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    hadgate.set_err(p_sqbg,p_sqbg,p_sqbg);
    rho_l.set_e_ro(2*p_sqbg);
    rho_l.set_e_init(2*p_sqbg);
    [cnot,cz] = SetDampCoeff(p,0, cnot, cz); % Sets damping for 2QBG
    [xgate, zgate,ygate, hadgate] = SetDampCoeff(p,0, xgate, zgate,ygate, hadgate);
    
    
    %rtmp = SteaneLogicalGate(rho_l,xgate,1);
    %psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    rtmp = rho_l;
    psi_tmp = psi_l;
    gt_counts = 0;
    L = length(ngates) - 1;
    for j = 1:n_points_g
       
        for k = ngates(j):ngates(j+1)-1
             rtmp = xgate.apply(rtmp,[3 5 7]);
             psi_tmp = xgate.apply(psi_tmp,[3 5 7]);
             gt_counts = gt_counts + 1;
        end
        rtmp1 = CorrectionCycle(rtmp,'X',cnot,hadgate,xgate,zgate,p^2*1e-3);
        rtmp1 = CorrectionCycle(rtmp1,'Z',cnot,hadgate,xgate,zgate,p^2*1e-3);
        
        if mod(gt_counts,2)
            psiL = psi_p;
        else
            psiL = n_psi;
        end
        r_l = IdealDecode('Surf17',rtmp1);
        p_errL_surf17(j,i) = Fid2(psiL,r_l); %Logical fidelity
    end
    
end

gain_logerr_surf17 = p_errL_phys./p_errL_surf17;

save('new_zero_24x18_2')
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

