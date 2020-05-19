T1 = 2e-3;
T2 = 2e-3;

%% Physical SQBG
error_rate = linspace(-9,-2,70);
had = (1/sqrt(2)).*[1 1;1 -1];
x = [0 1;1 0];
error_rate = 10.^error_rate;
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7e-6*[1 1] 3e-6*[1 1 1 1]],0,2);
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
    cnot.uni_err(4*error_rate(i)); % set error rate
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

%% Logical SQBG with EC
rho4 = rho3;
psi4 = psi3;
fid4 = zeros(size(error_rate));
parfor i = 1:length(error_rate)
   err = error_rate(i);
   cnot.uni_err(4*err); % 3 times error rate for 2 qubit gates
   cz.uni_err(4*err);
   xgate.uni_err(err);
   zgate.uni_err(err);
   hadgate.uni_err(err);
   rtmp = SteaneLogicalGate(rho4,xgate,1);
   [rtmp,~] = Correct_steane_error(rtmp,1,'X',3e-6,2e-3,hadgate,cnot,zgate,cz);
   [rtmp,~] = Correct_steane_error(rtmp,1,'Z',3e-6,2e-3,hadgate,cnot,xgate,cz);
   fid4(i) = Fid2(psi4,rtmp);
end
%%
loglog(error_rate,fid4);

%% Logical SQBG w/ EC no idle
rho5 = rho4;
psi5 = psi4;
fid5 = zeros(size(error_rate));
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7e-6*[1 1] 3e-6*[1 1 1 1]],0,0);
parfor i = 1:length(error_rate)
   err = error_rate(i);
   cnot.uni_err(4*err); % 3 times error rate for 2 qubit gates
   cz.uni_err(4*err);
   xgate.uni_err(err);
   zgate.uni_err(err);
   hadgate.uni_err(err);
   rtmp = SteaneLogicalGate(rho5,xgate,1);
   [rtmp,~] = Correct_steane_error(rtmp,1,'X',3e-6,2e-3,hadgate,cnot,zgate,cz);
   [rtmp,~] = Correct_steane_error(rtmp,1,'Z',3e-6,2e-3,hadgate,cnot,xgate,cz);
   fid5(i) = Fid2(psi5,rtmp);
end
loglog(error_rate,fid5);
legend('Physical Single Qubit Gate', 'Physical 2 Qubit Gate',...
    'Logical Single Qubit Gate, No EC', 'Logical Single Qubit Gate Full EC',...
    'Logical SQBG, EC, no idling')

%% Logical, no readout err
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7e-6*[1 1] 3e-6*[1 1 1 1]],0,2);
rho6 = rho5;
psi6 = psi5;
fid6 = zeros(size(error_rate));
parfor i = 1:length(error_rate)
   err = error_rate(i);
   cnot.uni_err(4*err); % 3 times error rate for 2 qubit gates
   cz.uni_err(4*err);
   xgate.uni_err(err);
   zgate.uni_err(err);
   hadgate.uni_err(err);
   rtmp = SteaneLogicalGate(rho6,xgate,1);
   [rtmp,~] = Correct_steane_error(rtmp,1,'X',3e-6,0,hadgate,cnot,zgate,cz);
   [rtmp,~] = Correct_steane_error(rtmp,1,'Z',3e-6,0,hadgate,cnot,xgate,cz);
   fid6(i) = Fid2(psi6,rtmp);
end
loglog(error_rate,fid6);
legend('Physical Single Qubit Gate', 'Physical 2 Qubit Gate',...
    'Logical Single Qubit Gate, No EC', 'Logical Single Qubit Gate Full EC',...
    'Logical SQBG, EC, no idling', 'Logical SQBG, EC, no readout error')
%%
rho7 = rho4;
psi7 = psi4;
fid7 = zeros(size(error_rate));
[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[7e-6*[1 1] 3e-6*[1 1 1 1]],0,0);
parfor i = 1:length(error_rate)
   err = error_rate(i);
   cnot.uni_err(4*err); % 3 times error rate for 2 qubit gates
   cz.uni_err(4*err);
   xgate.uni_err(err);
   zgate.uni_err(err);
   hadgate.uni_err(err);
   rtmp = SteaneLogicalGate(rho7,xgate,1);
   [rtmp,~] = Correct_steane_error(rtmp,1,'X',3e-6,0,hadgate,cnot,zgate,cz);
   [rtmp,~] = Correct_steane_error(rtmp,1,'Z',3e-6,0,hadgate,cnot,xgate,cz);
   fid7(i) = Fid2(psi7,rtmp);
end
loglog(error_rate,fid7);
legend('Physical Single Qubit Gate', 'Physical 2 Qubit Gate',...
    'Logical Single Qubit Gate, No EC', 'Logical Single Qubit Gate Full EC',...
    'Logical SQBG, EC, no idling', 'Logical SQBG, EC, no readout error',...
    'Logical SQBG, EC, no idle or readout')