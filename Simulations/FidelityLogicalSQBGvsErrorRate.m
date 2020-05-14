
% Plot the fidelity of logical single qubit gates of the steane code as a
% function of gate error rate;
ngates = 10;
rho = LogicalZeroSteane();
[~,~,xgate,ygate,zgate,hadgate] = MakeGates(2e-3,2e-3,3.36e-6*ones(6,1),0,2);
[~,~,xg,yg,zg,hg] = MakeGates(Inf,Inf,zeros(6,1),0,0); % Gates without errors for reference state;

error_rates = 0:1e-7:1e-4;
fid = zeros(1,length(error_rates));
for i = 1:length(error_rates)
    [xgate,ygate,zgate,hadgate] = SetErrRate(error_rates(i),xgate,ygate,zgate,hadgate);
    gates = randi(4,1,ngates);
    res = rho;
    targ = rho;
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
        res = SteaneLogicalGate(res,gate,1);
        targ = SteaneLogicalGate(targ,g,1);
    end
    fid(i) = Fidelity(res,targ);
end

DoneNotification()
%% Plotting
plot(error_rates,fid)
xlabel('Error rate')
ylabel('Fidelity')
title('Fidelity vs error rate for 30 logical single qubit gates for the Steane Code')