T1 = 2e-3;
T2 = 2e-3;

%% Physical SQBG
error_rate = linspace(-9,-2,70);
had = (1/sqrt(2)).*[1 1;1 -1];
x = [0 1;1 0];
error_rate = 10.^error_rate;
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,2);
rho1 = NbitState([1 0;0 0]);
psi1 = [1;0];
psi1 = x*psi1;
fid1 = zeros(size(error_rate));
for i = 1:length(error_rate)
    xgate.uni_err(error_rate(i)); % Sets a uniform error rate
    tmprho = xgate.apply(rho1,1);
    fid1(i) = Fid2(psi1,tmprho);
end
%%
loglog(error_rate,fid1)
title('Fidelity vs Error Rate log log scale')
xlabel('Error rate')
ylabel('Fidelity')

%% Physical 2QBG
rho2 = NbitState();
rho2.init_all_zeros(2,0)
psi2 = [1;0;0;0];
cnot = CNOTGate(0,0);
cnotmat = kCNOT(1,2,2); %Control bit1, target bit 2, 2bits
psi2 = cnotmat*psi2;
fid2 = zeros(size(error_rate));
for i = 1:length(error_rate)
    p_succ = 1-error_rate(i);
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err = 1 - p_succ;
    cnot.uni_err(p_err); % set error rate
    tmprho = cnot.apply(rho2,2,1); % bit 1 is control, bit 2 is target
    fid2(i) = Fid2(psi2,tmprho);
end
%%
hold on
loglog(error_rate,fid2)

%% Logical SQBG
[psi3,rho3] = LogicalZeroSteane();
psi3 = SteaneLogicalGate(psi3,xgate,1);
fid3 = zeros(size(error_rate));
for i = 1:length(error_rate)
    xgate.uni_err(error_rate(i))
    rtmp = SteaneLogicalGate(rho3,xgate,1);
    fid3(i) = Fid2(psi3,rtmp);
end
%%
loglog(error_rate,fid3)

%% Logical SQBG with EC e_readout=1e-3, e_init=e_gate
rho4 = rho3;
psi4 = psi3;
fid4 = zeros(size(error_rate));
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 1 - p_succ;
    cnot.uni_err(p_err2); % set error rate
    cz.uni_err(p_err2);
    xgate.uni_err(err);
    zgate.uni_err(err);
    hadgate.uni_err(err);
    rtmp = SteaneLogicalGate(rho4,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',err,1e-3,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,1e-3,hadgate,cnot,xgate,cz);
    fid4(i) = Fid2(psi4,rtmp);
end
%%
loglog(error_rate,fid4);

%% Logical SQBG w/ EC no idle
rho5 = rho4;
psi5 = psi4;
fid5 = zeros(size(error_rate));
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0);
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 1 - p_succ;
    cnot.uni_err(p_err2); % set error rate
    cz.uni_err(p_err2);
    xgate.uni_err(err);
    zgate.uni_err(err);
    hadgate.uni_err(err);
    rtmp = SteaneLogicalGate(rho5,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',err,1e-3,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,1e-3,hadgate,cnot,xgate,cz);
    fid5(i) = Fid2(psi5,rtmp);
end
loglog(error_rate,fid5);
legend('Physical Single Qubit Gate', 'Physical 2 Qubit Gate',...
    'Logical Single Qubit Gate, No EC', 'Logical Single Qubit Gate Full EC',...
    'Logical SQBG, EC, no idling')

%% Logical, no readout err
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,2);
rho6 = rho5;
psi6 = psi5;
fid6 = zeros(size(error_rate));
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 1 - p_succ;
    cnot.uni_err(p_err2); % set error rate
    cz.uni_err(p_err2);
    xgate.uni_err(err);
    zgate.uni_err(err);
    hadgate.uni_err(err);
    rtmp = SteaneLogicalGate(rho6,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',err,0,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,0,hadgate,cnot,xgate,cz);
    fid6(i) = Fid2(psi6,rtmp);
end
loglog(error_rate,fid6);
legend('Physical Single Qubit Gate', 'Physical 2 Qubit Gate',...
    'Logical Single Qubit Gate, No EC', 'Logical Single Qubit Gate Full EC',...
    'Logical SQBG, EC, no idling', 'Logical SQBG, EC, no readout error')
%% No Idle or readout
rho7 = rho4;
psi7 = psi4;
fid7 = zeros(size(error_rate));
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0);
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 1 - p_succ;
    cnot.uni_err(p_err2); % set error rate
    cz.uni_err(p_err2);
    xgate.uni_err(err);
    zgate.uni_err(err);
    hadgate.uni_err(err);
    rtmp = SteaneLogicalGate(rho7,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',0,0,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,0,hadgate,cnot,xgate,cz);
    fid7(i) = Fid2(psi7,rtmp);
end
%% No idle, readout or init
rho8 = rho4;
psi8 = psi4;
fid8 = zeros(size(error_rate));
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0);
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 1 - p_succ;
    cnot.uni_err(p_err2); % set error rate
    cz.uni_err(p_err2);
    xgate.uni_err(err);
    zgate.uni_err(err);
    hadgate.uni_err(err);
    rtmp = SteaneLogicalGate(rho8,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',0,0,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',0,0,hadgate,cnot,xgate,cz);
    fid8(i) = Fid2(psi8,rtmp);
end
%% No 2qbg errors
rho9 = rho4;
psi9 = psi4;
fid9 = zeros(size(error_rate));
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0);
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    %p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 0;
    cnot.uni_err(p_err2); % set error rate
    cz.uni_err(p_err2);
    xgate.uni_err(err);
    zgate.uni_err(err);
    hadgate.uni_err(err);
    rtmp = SteaneLogicalGate(rho9,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',err,err,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,err,hadgate,cnot,xgate,cz);
    fid9(i) = Fid2(psi9,rtmp);
end
%% Full ec, no 2qbg error, no readout, no init, no idle 
rho10 = rho4;
psi10 = psi4;
fid10 = zeros(size(error_rate));
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0);
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    %p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 0;
    cnot.uni_err(p_err2); % set error rate
    cz.uni_err(p_err2);
    xgate.uni_err(err);
    zgate.uni_err(err);
    hadgate.uni_err(err);
    rtmp = SteaneLogicalGate(rho10,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',0,0,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',0,0,hadgate,cnot,xgate,cz);
    fid10(i) = Fid2(psi10,rtmp);
end
%%
figure(2)
loglog(error_rate,fid1,'r')
hold on
%loglog(error_rate,fid2)
loglog(error_rate,fid3,'g')
loglog(error_rate,fid4,'b')
loglog(error_rate,fid5,'y')
loglog(error_rate,fid6,'r-.')
loglog(error_rate,fid7,'g-.');
loglog(error_rate,fid8,'b-.')
loglog(error_rate,fid9,'y-.')
loglog(error_rate,fid10,'r--')
title('Fidelity Vs Error Rate, log log scale')
xlabel('Error Rate')
ylabel('Fidelity')
legend('Physical Single Qubit Gate', ...
    'Logical Single Qubit Gate, No EC', 'Logical Single Qubit Gate Full EC',...
    'Logical SQBG, EC, no idling', 'Logical SQBG, EC, no readout error',...
    'Logical SQBG, EC, no idle or readout', 'Logical SQBG, no idle, readout or init error',...
    'Logical SQBG w/ EC no two bit errors', 'Logical SQBG, only SQBG errors')