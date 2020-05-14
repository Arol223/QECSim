% Simulate logical gates with error correction

% parameters
tdur2 = 7e-6*[1 1];% duration of 2 qubit gates
tdur1 = 3.36e-6*[1 1 1 1]; % duration of 1 qubit gates
T1 = 2e-3; % For Eu
T2 = 1e-3; % Depends on crystal, 
error_rates = linspace(0,1e-3,500); % error rates to test
e_init = error_rates;   % can choose frequency separation so this is reasonable
e_readout = 2e-3; % Symmetric IRL, this should give lower bound.
idle_state = 2; % 0 -> no idling, 1 -> non simultaneous gates, 2 -> simultaneous gates 
ngates = 1; % how many consecutive gates to test;
% setup
[cn,cz,xg,yg,zg,hg] = MakeGates(T1,T2,zeros(1,6),0,0); %Error free gates
rho = LogicalZeroSteane();


fid = zeros(1,length(error_rates));
parfor i = 1:length(error_rates)
    res = rho;
    targ = rho;
    gatenr = randi(4,1,ngates); % Randomise the gate to test
    [cnot,cze,xgate,ygate,zgate,hadgate] = MakeGates(T1,T2,[tdur2 tdur1],0,2); %gates with errors
    [cnot,cze,xgate,ygate,zgate,hadgate] = SetErrRate(error_rates(i),...
        cnot,cze,xgate,ygate,zgate,hadgate) % Set the error rate
                    
    for j = 1:ngates
        pick = gatenr(i);
        switch pick
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
                gate=hadgate;
                g = hg;
        end
        res = SteaneLogicalGate(res,gate,1);
        targ = SteaneLogicalGate(targ,g,1);
        [res,~] = Correct_steane_error(res,1,'X',e_init(i),e_readout,...
            hadgate,cnot,zgate,cze);
        [res,~] = Correct_steane_error(res,1,'Z',e_init(i),e_readout,...
            hadgate,cnot,xgate,cze);
        
    end
    fid(i) = Fidelity(res,targ);
end

DoneNotification()

%% plotting
plot(error_rate,fid)
xlabel('Error rate')
ylabel('Fidelity')
title('Fidelity vs error rate for one logical gate with error correction');
