%% With all errors, no tol.
[cnot,cz,~,~,~,~] = MakeGates(150e-6,150e-6,2e-6*ones(6,1),0,1);
cnot.set_err(1e-3,1e-3);
cz.set_err(1e-3,1e-3);
X = 1e2; %Max # gates to test
sample_sz = 25; % Number of samples to try;
rng('shuffle');
[~,r] = LogicalZeroSteane();
runtime_meanerr = zeros(1,X);
SEMerr = zeros(1,X);
for i = 1:X
    gates = randi(2,1,X);
    times = zeros(1,sample_sz);
    
    for j = 1:sample_sz
        rho=r;
        time = zeros(1,i);
        for k = 1:i
            pick = gates(k);
            switch pick
                case 1
                    gate = cnot;
                case 2
                    gate = cz;
            end
            target = randi(7,1);
            control = target;
            while control == target
                control = randi(7,1);
            end
            tic;
            rho = gate.apply(rho,target,control);
            time(k) = toc;
        end
        times(j) = sum(time);
    end
    runtime_meanerr(i) = mean(times);
    SEMerr(i) = std(times)/sqrt(sample_sz);
    
end
DoneNotification()
%% No errors
runtime_mean = zeros(1,X);
SEM = zeros(1,X);
cnot.inc_err = 0;
cz.inc_err = 0;
cnot.idle_state = 0;
cz.idle_state = 0;
for i = 1:X
    gates = randi(2,1,X);
    times = zeros(1,sample_sz);
    
    for j = 1:sample_sz
        rho=r;
        time = zeros(1,i);
        for k = 1:i
            pick = gates(k);
            switch pick
                case 1
                    gate = cnot;
                case 2
                    gate = cz;
            end
            target = randi(7,1);
            control = target;
            while control == target
                control = randi(7,1);
            end
            tic;
            rho = gate.apply(rho,target,control);
            time(k) = toc;
        end
        times(j) = sum(time);
    end
    runtime_mean(i) = mean(times);
    SEM(i) = std(times)/sqrt(sample_sz);
    
end
DoneNotification()
%% SamePlot

figure()
title('Mean Runtime & Standard Error of The Mean Vs Number of TQBG, With & Without Errors')
hold on
yyaxis left
ylabel('Time [s]')
plot(1:X,runtime_meanerr,'r')
plot(1:X,runtime_mean,'b--')
yyaxis right
plot(1:X,SEMerr,'r-.')
plot(1:X,SEM,'b-.')
legend('Runtime with Errors','Runtime without errors','SEM with errors', 'SEM without errors')
xlabel('Number of single qubit gates')
ylabel('Time [s]')