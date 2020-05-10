%% State preparation without errors
[cnot, cz, xgate, ygate, zgate, hadgate] = MakeGates(Inf,Inf,zeros(6,1),0,0); %Gates without errors
rho = NbitState();
rho.init_all_zeros(7,0)
S = SteaneCode();


reps = 100;
times = zeros(1,reps);
for i = 1:reps
    tic;
    Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end

t_mean(1) = mean(times);
stdev(1)  = std(times);


%% State preparation with bitflip
[cnot,cz,~,~,zgate,hadgate] = ChangeT2(150e-6,cnot,cz,xgate,ygate,zgate,hadgate);
for i = 1:reps
    tic;
    Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_mean(2) = mean(times);
stdev(2) = std(times);

%% State preparation phaseflip
[cnot,cz,~,~,zgate,hadgate] = MakeGates(150e-6,Inf,1e-6,0,0);
for i = 1:reps
    tic;
    Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_mean(3) = mean(times);
stdev(3) = std(times);
%% State prep bit- & phaseflip
[cnot,cz,~,~,zgate,hadgate] = MakeGates(150e-6,1e-3,1e-6,0,0);
for i = 1:reps
    tic;
    Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_mean(4) = mean(times);
stdev(4) = std(times);

%% State prep bit & phase with tol
[cnot,cz,~,~,zgate,hadgate] = MakeGates(150e-6,150e-6,5e-6,1e-5,0);
for i = 1:reps
    tic;
    Correct_steane_error(rho,1,S,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol(1) = mean(times);
stdev_tol(1) = std(times);

[cnot,cz,xgate,ygate,zgate,hadgate] = MakeGates(150e-6,150e-6,5e-6,1e-6,0);
for i = 1:reps
    tic;
    f();
    times(i) = toc;
end
t_tol(1) = mean(times);
stdev_tol(1) = std(times);