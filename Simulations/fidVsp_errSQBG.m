clear variables
close all
% T1=T2 = 2ms. 
ngates = 30;
[~,~,xgate,ygate,zgate,hadgate] = MakeGates(Inf,Inf,3.36e-6*ones(1,6),0,1);
[~,~,xg,yg,zg,hg] = MakeGates(Inf,Inf,zeros(1,6),0,0);
rho = NbitState([0.5,0.5;0.5,0.5]); % STate to test on
rho = rho*rho;  % 2bit system
error_rates = 0:1e-6:1e-3;
fid = zeros(1,length(error_rates));
for i = 1:length(error_rates)
    res = rho;
    targ = rho;
    gates = randi(4,1,ngates);
    [xgate,ygate,zgate,hadgate] = SetErrRate(error_rates(i),xgate,ygate,zgate,hadgate);
    for j = 1:ngates
        switch gates(j)
            case 1
                gate = xgate;
                g = xg;
            case 2 
                gate = ygate;
                g = yg;
            case 3
                gate = zgate;
                g = zg;
            case 4
                gate = hadgate;
                g = hg;
        end
        target = randi(2,1,1);
        res = gate.apply(res,target);
        targ = g.apply(targ,target);
    end
    fid(i) = Fidelity(res,targ);
end

DoneNotification()
%% Plotting
plot(error_rates,fid)
xlabel('Error rate')
ylabel('Fidelity')
title('Fidelity of 30 random single qubit gates Vs gate error rate')