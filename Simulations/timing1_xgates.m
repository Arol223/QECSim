clear variables
%% With all errors, no tol.
[~,~,xgate,ygate,zgate,hadgate] = MakeGates(150e-6,150e-6,2e-6*ones(6,1),0,1);
X = 5e2; %Max # gates to test
sample_sz = 100; % Number of samples to try;
rng('shuffle');
r = LogicalZeroSteane();
runtime_meanerr = zeros(1,X);
SEMerr = zeros(1,X);
for i = 1:X
    gates = randi(4,1,X);
    times = zeros(1,100);
    
    for j = 1:100
        rho=r;
        time = zeros(1,i);
        for k = 1:i
            pick = gates(k);
            switch pick
                case 1
                    gate = xgate;
                case 2
                    gate = ygate;
                case 3
                    gate = zgate;
                case 4
                    gate = hadgate;
            end
            target = randi(7,1);
            tic;
            rho = gate.apply(rho,target);
            time(k) = toc;
        end
        times(j) = sum(time);
    end
    runtime_meanerr(i) = mean(times);
    SEMerr(i) = std(times)/sqrt(sample_sz);
    
end
DoneNotification()

%% plotting
figure(1)
title('Mean runtime and SEM as function of number of gates performed on |0>_L including errors')
subplot(1,2,1)
plot(1:length(runtime_meanerr),runtime_meanerr)
xlabel('No. of gates')
ylabel('Average time [s]')
title('Mean runtime for 100 samples as function of number of single bit gates on |0>_L')
subplot(1,2,2)
plot(1:length(SEMerr),SEMerr)

xlabel('No. of gates')
ylabel('SEM of runtime [s]')
title('SEM of runtime for 100 samples as function of number of gates on |0>_L')

%% No errors, no tol
[~,~,xgate,ygate,zgate,hadgate] = MakeGates(Inf,Inf,zeros(6,1),0,0);
xgate.inc_err=0;
ygate.inc_err=0;
zgate.inc_err=0;
hadgate.inc_err=0;
X = 5e2;
runtime_mean = zeros(1,X);
SEM = runtime_mean;
for i = 1:X % Get time for 1-X gates 
    gates = randi(4,1,X);
    times = zeros(1,100);
    for j = 1:100 % Sample size of 100
        time = zeros(1,i);
        rho = r;
        for k = 1:i % apply i gates
            pick = gates(k);
            switch pick
                case 1
                    gate = xgate;
                case 2
                    gate = ygate;
                case 3
                    gate = zgate;
                case 4
                    gate = hadgate;
            end
            target = randi(7,1);
            tic;
            rho = gate.apply(rho,target);
            time(k) = toc;
        end
        times(j) = sum(time);
    end
    runtime_mean(i) = mean(times);
    SEM(i) = std(times)/sqrt(sample_sz);
    
end
DoneNotification()

%% plotting
figure(2)
title('Mean runtime and SEM as function of number of gates performed on |0>_L, no errors')
subplot(1,2,1)
plot(1:X,runtime_mean)
xlabel('No. of gates')
ylabel('Average time [s]')
title('Mean runtime for 100 samples as function of number of single bit gates on |0>_L')
subplot(1,2,2)
plot(1:X,SEM)

xlabel('No. of gates')
ylabel('SEM of runtime [s]')
title('SEM of runtime for 100 samples as function of number of gates on |0>_L')

%% SamePlot

figure(3)
title('Mean Runtime & Standard Error of The Mean Vs Number of Gates, With & Without Errors')
hold on
yyaxis left
plot(1:X,runtime_meanerr,'r')
plot(1:X,runtime_mean,'b')
yyaxis right
plot(1:X,SEMerr,'r-.')
plot(1:X,SEM,'b-.')
legend('Runtime with Errors','Runtime without errors','SEM with errors', 'SEM without errors')
xlabel('Number of single qubit gates')
ylabel('Time [s]')