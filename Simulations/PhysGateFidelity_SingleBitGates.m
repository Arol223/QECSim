% Fidelity of gates on physical bits as function of T2. Uses T1 = 150e-6 s
% for Pr or T1 = 2 ms for Eu. 
clear variables
close all
T1 = 2e-3; %T1 for Eu
T2 = linspace(2e-6,2*T1,2000);
[~,~,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2(1),3.36e-6*ones(1,6),0,0);
[~,~,xg,yg,zg,hg] = MakeGates(Inf,Inf,zeros(1,6),0,0); %Gates without errors
%% XGate fidelity
rho = NbitState([1,0;0,0]); %Testing state starting in |0>
targ = NbitState([0,0;0,1]); %Target state for x acting on |0>
xfid = zeros(1,length(T2));
for i = 1:length(T2)
    xgate = ChangeT2(T2(i),xgate);
    res = xgate.apply(rho,1);
    xfid(i) = Fidelity(res,targ); 
end
    
%% YGate Fidelity
targ = yg.apply(rho,1);
yfid = zeros(1,length(T2));
for i = 1:length(T2)
    ygate = ChangeT2(T2(i),ygate);
    res = ygate.apply(rho,1);
    yfid(i) = Fidelity(res,targ);
end

%% ZGate Fidelity
targ = rho;
zfid = zeros(1,length(T2));
for i = 1:length(T2)
    zgate = ChangeT2(T2(i),zgate);
    res = zgate.apply(rho,1);
    zfid(i) = Fidelity(res,targ);
end

%% HGate Fidelity
targ = hg.apply(rho,1);
hfid = zeros(1,length(T2));
for i = 1:length(T2)
    hadgate = ChangeT2(T2(i),hadgate);
    res = hadgate.apply(rho,1);
    hfid(i) = Fidelity(res,targ);
end

%% Plotting
subplot(2,2,1)
plot(T2,xfid)
title('Fidelity of single physical X-Gate vs T2')
xlabel('T2 [s]')
ylabel('Fidelity')
subplot(2,2,2)
plot(T2,yfid);
title('Fidelity of single physical Y-Gate vs T2')
xlabel('T2 [s]')
ylabel('Fidelity')
subplot(2,2,3)
plot(T2,zfid)
title('Fidelity of single physical Z-Gate vs T2')
xlabel('T2 [s]')
ylabel('Fidelity')
subplot(2,2,4)

plot(T2,hfid)
title('Fidelity of single physical Hadamard-Gate vs T2')
xlabel('T2 [s]')
ylabel('Fidelity')
%plot(T2,xfid,'r--',T2,yfid,'g.-',T2,zfid,'b:',T2,hfid,'m-')
