%% Short T2, T1 for Eu
T1 = 2e-3;
T2 = logspace(-5.3979,-4,20);
e_readout = 1e-3;
t_durs = 400e-9; % SQBG duration
t_dur_tot = [2*t_durs*[1 1] t_durs*[1 1 1 1]]; % 4 times longer for 2QBG
[cnot,cz,xg,yg,zg,hg] = MakeGates(T1,Inf,t_dur_tot,0,2);
fid_long = zeros(7,length(T2));


%% Physical SQBG
rho1 = NbitState([1 0; 0 0]); %|0><0|
psi1 = [1;0]; %|0>
psi1 = xg.apply(psi1,1); % Reference pure state

for i = 1:length(T2)
    xg.T2 = T2(i);
    xg.err_from_T(); % Set error rate according to T1,T2 and t_dur
    rtmp = xg.apply(rho1,1);
    fid_long(1,i) = Fid2(psi1,rtmp);
end

%% Physical 2QBG
rho2 = NbitState();
rho2.init_all_zeros(2,0); %Starting state all zero
psi2 = [1;0;0;0]; 
psi2 = cnot.apply(psi2,2,1); %Reference state without errors
for i = 1:length(T2)
    cnot.T2 = T2(i);
    cnot.err_from_T();
    rtmp = cnot.apply(rho2,2,1);
    fid_long(2,i) = Fid2(psi2,rtmp);
end

%% Logical SQBG
[psi3,rho3] = LogicalZeroSteane();
psi3 = SteaneLogicalGate(psi3,xg,1); %Reference
for i = 1:length(T2)
    xg.T2 = T2(i);
    xg.err_from_T();
    rtmp = SteaneLogicalGate(rho3,xg,1);
    fid_long(3,i) = Fid2(psi3,rtmp);
end

%% Logical SQBG w/ EC 

psi4 = psi3;
rho4 = rho3;
parfor i = 1:length(T2)   
[cnot,cz,xg,~,zg,hg] = MakeGates(T1,Inf,t_dur_tot,0,2);
[cnot,cz,xg,zg,hg] = ChangeT2(T2(i),cnot,cz,xg,zg,hg);
e_init = 1-xg.p_success;
rtmp = SteaneLogicalGate(rho4,xg,1);
rtmp = Correct_steane_error(rtmp,1,'X',e_init,e_readout,hg,cnot,zg,cz);
rtmp = Correct_steane_error(rtmp,1,'Z',e_init,e_readout,hg,cnot,xg,cz);
fid_long(4,i) = Fid2(psi4,rtmp);
end
%% Logical SQBG with EC, no idle
psi5 = psi3;
rho5 = rho3;
parfor i = 1:length(T2)   
[cnot,cz,xg,~,zg,hg] = MakeGates(T1,Inf,t_dur_tot,0,0);
[cnot,cz,xg,zg,hg] = ChangeT2(T2(i),cnot,cz,xg,zg,hg);
e_init = 1-xg.p_success;
rtmp = SteaneLogicalGate(rho5,xg,1);
rtmp = Correct_steane_error(rtmp,1,'X',e_init,e_readout,hg,cnot,zg,cz);
rtmp = Correct_steane_error(rtmp,1,'Z',e_init,e_readout,hg,cnot,xg,cz);
fid_long(5,i) = Fid2(psi5,rtmp);
end

%% Logical SQBG with EC, e_readout = e_gate
psi6 = psi3;
rho6 = rho3;
parfor i = 1:length(T2)   
[cnot,cz,xg,~,zg,hg] = MakeGates(T1,Inf,t_dur_tot,0,2);
[cnot,cz,xg,zg,hg] = ChangeT2(T2(i),cnot,cz,xg,zg,hg);
e_init = 1-xg.p_success;
e_readout = e_init;
rtmp = SteaneLogicalGate(rho6,xg,1);
rtmp = Correct_steane_error(rtmp,1,'X',e_init,e_readout,hg,cnot,zg,cz);
rtmp = Correct_steane_error(rtmp,1,'Z',e_init,e_readout,hg,cnot,xg,cz);
fid_long(6,i) = Fid2(psi6,rtmp);
end

%% Logical SQBG with EC, e_readout = e_gate, no idle
psi7 = psi3;
rho7 = rho3;
parfor i = 1:length(T2)   
[cnot,cz,xg,~,zg,hg] = MakeGates(T1,Inf,t_dur_tot,0,0);
[cnot,cz,xg,zg,hg] = ChangeT2(T2(i),cnot,cz,xg,zg,hg);
e_init = 1-xg.p_success;
e_readout = e_init;
rtmp = SteaneLogicalGate(rho7,xg,1);
rtmp = Correct_steane_error(rtmp,1,'X',e_init,e_readout,hg,cnot,zg,cz);
rtmp = Correct_steane_error(rtmp,1,'Z',e_init,e_readout,hg,cnot,xg,cz);
fid_long(7,i) = Fid2(psi7,rtmp);
end


%% Plotting
figure(1)
loglog(T2,fid_long)
xlabel('log(T2)')
ylabel('Fidelity')
title('Fidelity as a function of T2 for different scenarios')
legend('Physical SQBG','Physical 2QBG', 'Logical SQBG','Logical SQBG w/ EC',...
    'Logical SQBG w/ EC, no idle', 'Logical SQBG w/ EC low readout err',...
    'Logical SQBG w/ EC, low readout err, no idle')