T1 = 2e-3;
T2 = 2e-3;

%% Physical SQBG
error_rate = logspace(-9,-1,30);
had = (1/sqrt(2)).*[1 1;1 -1];
x = [0 1;1 0];

[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,2);
rho1 = NbitState();
rho1.init_all_zeros(2,0);
psi1 = [1;0;0;0];
psi1 = xgate.apply(psi1,1);
fid1 = zeros(size(error_rate));
for i = 1:length(error_rate)
    xgate.set_err(error_rate(i),error_rate(i)); % Sets a uniform error rate
    tmprho = xgate.apply(rho1,1);
    fid1(i) = Fid2(psi1,tmprho);
end
%%
% figure(1)
% loglog(error_rate,1-fid1)
% title('Fidelity vs Error Rate log log scale')
% xlabel('Error rate')
% ylabel('Fidelity')
% hold on
% legend('Physical SQBG')
%% Logical SQBG
[psi3,rho3] = LogicalZeroSteane();
psi3 = SteaneLogicalGate(psi3,xgate,1);
fid3 = zeros(size(error_rate));
for i = 1:length(error_rate)
    xgate.set_err(error_rate(i),error_rate(i))
    rtmp = SteaneLogicalGate(rho3,xgate,1);
    fid3(i) = Fid2(psi3,rtmp);
end
%%
loglog(error_rate,1-fid3)

%% Logical SQBG with EC e_readout=1e-3, e_init=e_gate
rho4 = rho3;
psi4 = psi3;
fid4 = zeros(size(error_rate));
ppm = ParforProgressbar(length(error_rate),'showWorkerProgress',true); 
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 1 - p_succ;
    cnot.set_err(p_err2,p_err2); % set error rate
    cz.set_err(p_err2,p_err2);
    xgate.set_err(err,err);
    zgate.set_err(err,err);
    hadgate.set_err(err,err);
    rtmp = SteaneLogicalGate(rho4,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',err,1e-3,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,1e-3,hadgate,cnot,xgate,cz);
    fid4(i) = Fid2(psi4,rtmp);
    ppm.increment();
end
delete(ppm)
%%
loglog(error_rate,fid4);

%% Logical SQBG w/ EC e_readout=e_gate
rho5 = rho4;
psi5 = psi4;
fid5 = zeros(size(error_rate));
ppm = ParforProgressbar(length(error_rate),'showWorkerProgress',true); 
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,2);
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 1 - p_succ;
    cnot.set_err(p_err2,p_err2); % set error rate
    cz.set_err(p_err2,p_err2);
    xgate.set_err(err,err);
    zgate.set_err(err,err);
    hadgate.set_err(err,err);
    rtmp = SteaneLogicalGate(rho5,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',err,err,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,err,hadgate,cnot,xgate,cz);
    fid5(i) = Fid2(psi5,rtmp);
    ppm.increment()
end
delete(ppm);
loglog(error_rate,fid5);
legend('Physical Single Qubit Gate', 'Physical 2 Qubit Gate',...
    'Logical Single Qubit Gate, No EC', 'Logical Single Qubit Gate Full EC',...
    'Logical SQBG, EC, no idling')

%% Logical, no readout err
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,2);
rho6 = rho5;
psi6 = psi5;
fid6 = zeros(size(error_rate));
ppm = ParforProgressbar(length(error_rate),'showWorkerProgress',true); 
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 1 - p_succ;
    cnot.set_err(p_err2,p_err2); % set error rate
    cz.set_err(p_err2,p_err2);
    xgate.set_err(err,err);
    zgate.set_err(err,err);
    hadgate.set_err(err,err);
    rtmp = SteaneLogicalGate(rho6,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',err,0,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,0,hadgate,cnot,xgate,cz);
    fid6(i) = Fid2(psi6,rtmp);
    ppm.increment()
end
delete(ppm);
loglog(error_rate,fid6);
legend('Physical Single Qubit Gate', 'Physical 2 Qubit Gate',...
    'Logical Single Qubit Gate, No EC', 'Logical Single Qubit Gate Full EC',...
    'Logical SQBG, EC, no idling', 'Logical SQBG, EC, no readout error')
%% No Idle or readout
rho7 = rho4;
psi7 = psi4;
fid7 = zeros(size(error_rate));
ppm = ParforProgressbar(length(error_rate),'showWorkerProgress',true); 
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0);
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 1 - p_succ;
    cnot.set_err(p_err2,p_err2); % set error rate
    cz.set_err(p_err2,p_err2);
    xgate.set_err(err,err);
    zgate.set_err(err,err);
    hadgate.set_err(err,err);
    rtmp = SteaneLogicalGate(rho7,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',0,0,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,0,hadgate,cnot,xgate,cz);
    fid7(i) = Fid2(psi7,rtmp);
    ppm.increment();
end
delete(ppm);
%% No idle, readout or init
rho8 = rho4;
psi8 = psi4;
fid8 = zeros(size(error_rate));
ppm = ParforProgressbar(length(error_rate),'showWorkerProgress',true); 
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0);
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 1 - p_succ;
    cnot.set_err(p_err2,p_err2); % set error rate
    cz.set_err(p_err2,p_err2);
    xgate.set_err(err,err);
    zgate.set_err(err,err);
    hadgate.set_err(err,err);
    rtmp = SteaneLogicalGate(rho8,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',0,0,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',0,0,hadgate,cnot,xgate,cz);
    fid8(i) = Fid2(psi8,rtmp);
    ppm.increment();
end
delete(ppm);
%% No 2qbg errors
rho9 = rho4;
psi9 = psi4;
fid9 = zeros(size(error_rate));
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0);
ppm = ParforProgressbar(length(error_rate),'showWorkerProgress',true); 
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    %p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 0;
    cnot.set_err(0,0); % set error rate
    cz.set_err(0,0);
    xgate.set_err(err,err);
    zgate.set_err(err,err);
    hadgate.set_err(err,err);
    rtmp = SteaneLogicalGate(rho9,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',err,err,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,err,hadgate,cnot,xgate,cz);
    fid9(i) = Fid2(psi9,rtmp);
    ppm.increment();
end
delete(ppm);
%% Full ec, no 2qbg error, no readout, no init, no idle 
rho10 = rho4;
psi10 = psi4;
fid10 = zeros(size(error_rate));
ppm = ParforProgressbar(length(error_rate),'showWorkerProgress',true); 
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,0);
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    %p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 0;
    cnot.set_err(0,0); % set error rate
    cz.set_err(0,0);
    xgate.set_err(err,err);
    zgate.set_err(err,err);
    hadgate.set_err(err,err);
    rtmp = SteaneLogicalGate(rho10,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',0,0,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',0,0,hadgate,cnot,xgate,cz);
    fid10(i) = Fid2(psi10,rtmp);
    ppm.increment();
end
delete(ppm);
%% Only errors affecting 1 bit at a time. Idle bits but assume parallell operations.
rho11 = rho4;
psi11 = psi4;
fid11 = zeros(size(error_rate));
ppm = ParforProgressbar(length(error_rate),'showWorkerProgress',true); 
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(0,0,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,2);
tic;
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    %p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 0;
    cnot.single_bit_err(err,err); % set error rate
    cz.single_bit_err(err,err);
    xgate.set_err(err,err);
    zgate.set_err(err,err);
    hadgate.set_err(err,err);
    rtmp = SteaneLogicalGate(rho10,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',err,err,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,err,hadgate,cnot,xgate,cz);
    fid11(i) = Fid2(psi11,rtmp);
    ppm.increment();
end
toc
 delete(ppm);
%% Perfect 2qbg, with idle
rho12 = rho4;
psi12 = psi4;
fid12 = zeros(size(error_rate));
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7.7e-6*[1 1] 3.36e-6*[1 1 1 1]],0,2);
cnot.inc_err = 0; %Don't include gate errors but allow damping
cz.inc_err = 0; %-||-
xgate.inc_err = 0;
zgate.inc_err = 0;
hadgate.inc_err = 0;
%ppm = ParforProgressbar(length(error_rate),'showWorkerProgress',true); 
tic;
parfor i = 1:length(error_rate)
    err = error_rate(i);
    p_succ = 1-err;
    %p_succ = p_succ^4; % 2QBG consists of 4 SQBG so this should give appropriate error rate
    p_err2 = 0;
    cnot.set_err(err,err); % set error rate
    cz.set_err(err,err);
    xgate.set_err(err,err);
    zgate.set_err(err,err);
    hadgate.set_err(err,err);
    rtmp = SteaneLogicalGate(rho9,xgate,1);
    [rtmp,~] = Correct_steane_error(rtmp,1,'X',err,err,hadgate,cnot,zgate,cz);
    [rtmp,~] = Correct_steane_error(rtmp,1,'Z',err,err,hadgate,cnot,xgate,cz);
    fid12(i) = Fid2(psi12,rtmp);
   % ppm.increment();
end
toc
%delete(ppm);


%% plot
figure(2)
loglog(error_rate,1-fid1,'r')
hold on

loglog(error_rate,1-fid3,'g')
%loglog(error_rate,1-fid4,'b')
%loglog(error_rate,1-fid5,'y')
loglog(error_rate,1-fid6,'r-.')
loglog(error_rate,1-fid7,'g-.');
loglog(error_rate,1-fid8,'b-.')
loglog(error_rate,1-fid9,'y-.')
loglog(error_rate,1-fid10,'m--')
loglog(error_rate,1-fid11,'k--')
loglog(error_rate,1-fid12,'c--')

title('1-Fidelity Vs Error Rate')
xlabel('Error Rate')
ylabel('1-Fidelity')
legend('Physical Single Qubit Gate', ...
    'Logical Single Qubit Gate, No EC','Logical SQBG w/EC, e_{readout}=e_{gate}',...
    'Logical SQBG, no idle or readout errors',...
    'Logical SQBG, no idle, readout or init errors',...
    'SQBG errors, w/ readout and init error','Only SQBG errors',...
    'Only SQBG errors, w/ idle', 'No gate errors, with idling')