[cnot,cz,xgate,~,zgate,hadgate] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,2);

p_err = logspace(-9,-3,17);
ngates = 120;
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

%% Logical gate w/ and without EC

[psi_l,rho_l] = LogicalZeroSteane();
fid_l = zeros(1,length(p_err));
fid_EC = fid_l;
parfor i = 1:length(p_err)
    p = p_err(i);
    xgate.set_err(p,p);
    cnot.set_err(p,p);
    cz.set_err(p,p);
    zgate.set_err(p,p);
    hadgate.set_err(p,p);
    rtmp = SteaneLogicalGate(rho_l,xgate,1);
    psi_tmp = SteaneLogicalGate(psi_l,xgate,1);
    for j = 2:ngates
        rtmp = SteaneLogicalGate(rtmp,xgate,1);
        psi_tmp = SteaneLogicalGate(psi_tmp,xgate,1);
    end
    fid_l(i) =1- Fid2(psi_tmp,rtmp);
    rtmp = Correct_steane_error(rtmp,1,'X',p,p,hadgate,cnot,zgate,cz);
    rtmp = Correct_steane_error(rtmp,1,'Z',p,p,hadgate,cnot,xgate,cz);
    fid_EC(i) = 1-Fid2(psi_tmp,rtmp);
end

%% Plotting
loglog(p_err,fid_phys)
hold on
loglog(p_err,fid_l)
loglog(p_err,fid_EC)
xlabel('Error rate')
ylabel('1-Fidelity')
title('1-Fidelity vs error rate for 6 SQBG, physical, logical and logical with EC')
legend('Physical SQBG','Logical SQBG','Logical SQBG w/ EC')