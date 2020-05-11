clear variables
close all
%% State preparation without errors
[cnot, cz, xgate, ygate, zgate, hadgate] = MakeGates(Inf,Inf,zeros(6,1),0,0); %Gates without errors
rho = NbitState();
rho.init_all_zeros(7,0)
S = SteaneCode();


reps = 5;
times = zeros(1,reps);
for i = 1:reps
    tic;
    [r_corr, ~] = Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end

t_mean(1) = mean(times);
stdev(1)  = std(times);


%% State preparation with phaseflip
[cnot,cz,~,~,zgate,hadgate] = MakeGates(Inf,150e-6,1e-6*ones(6,1),0,0);
for i = 1:reps
    tic;
    Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_mean(2) = mean(times);
stdev(2) = std(times);

%% State preparation bitflip
[cnot,cz,zgate,hadgate] = ChangeT2(Inf,cnot,cz,zgate,hadgate);
[cnot,cz,zgate,hadgate] = ChangeT1(150e-6,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_mean(3) = mean(times);
stdev(3) = std(times);
%% State prep bit- & phaseflip
[cnot,cz,zgate,hadgate] = ChangeT2(150e-6,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [rtot,p]=Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_mean(4) = mean(times);
stdev(4) = std(times);

%% State prep bit & phase with tol
[cnot,cz,zgate,hadgate] = ChangeTol(1e-5,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    
    times(i) = toc;
end
t_tol(1) = mean(times);
stdev_tol(1) = std(times);
fid(1) = Fidelity(rtot,r);

[cnot,cz,zgate,hadgate] = ChangeTol(1e-6,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p] = Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol(2) = mean(times);
stdev_tol(2) = std(times);
fid(2) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-7,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
end
t_tol(3) = mean(times);
stdev_tol(3) = std(times);
fid(3) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-8,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol(4) = mean(times);
stdev_tol(4) = std(times);
fid(4) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-9,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol(5) = mean(times);
stdev_tol(5) = std(times);
fid(5) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-10,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol(6) = mean(times);
stdev_tol(6) = std(times);
fid(6) = Fidelity(rtot,r);

%% test x gates

