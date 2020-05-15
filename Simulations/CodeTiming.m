%% Setup
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
    [r_corr, ~] = Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end

t_mean(1) = mean(times);
stdev(1)  = std(times);


%% State preparation with phaseflip
[cnot,cz,~,~,zgate,hadgate] = MakeGates(Inf,150e-6,1e-6*ones(6,1),0,0);
for i = 1:reps
    tic;
    Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_mean(2) = mean(times);
stdev(2) = std(times);

%% State preparation bitflip
[cnot,cz,zgate,hadgate] = ChangeT2(Inf,cnot,cz,zgate,hadgate);
[cnot,cz,zgate,hadgate] = ChangeT1(150e-6,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_mean(3) = mean(times);
stdev(3) = std(times);
DoneNotification()
%% State prep bit- & phaseflip
[cnot,cz,zgate,hadgate] = ChangeT2(150e-6,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [rtot,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_mean(4) = mean(times);
stdev(4) = std(times);
DoneNotification()
%% State prep bit & phase with tol
[cnot,cz,zgate,hadgate] = ChangeTol(1e-5,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    
    times(i) = toc;
end
t_tol(1) = mean(times);
stdev_tol(1) = std(times);
fid(1) = Fidelity(rtot,r);

[cnot,cz,zgate,hadgate] = ChangeTol(1e-6,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p] = Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol(2) = mean(times);
stdev_tol(2) = std(times);
fid(2) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-7,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
end
t_tol(3) = mean(times);
stdev_tol(3) = std(times);
fid(3) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-8,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol(4) = mean(times);
stdev_tol(4) = std(times);
fid(4) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-9,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol(5) = mean(times);
stdev_tol(5) = std(times);
fid(5) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-10,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol(6) = mean(times);
stdev_tol(6) = std(times);
fid(6) = Fidelity(rtot,r);

DoneNotification();
%% State prep bit and phaseflip with idling 1&2
[cnot,cz,zgate,hadgate] = ChangeTol(0,cnot,cz,zgate,hadgate);
[cnot,cz,zgate,hadgate] = SetIdleState(1,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [rtot,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_idle(1) = mean(times);
stdevidle(1) = std(times);

[cnot,cz,zgate,hadgate] = SetIdleState(2,cnot,cz,zgate,hadgate);

for i = 1:reps
    tic;
    [rtot,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_idle(2) = mean(times);
stdevidle(2) = std(times);



DoneNotification();
%% State prep bit & phase with idle1 & tol
[cnot,cz,zgate,hadgate] = SetIdleState(1,cnot,cz,zgate,hadgate);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-5,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    
    times(i) = toc;
end
t_tol_idle1(1) = mean(times);
stdev_tol_idle1(1) = std(times);
fid_idle1(1) = Fidelity(rtot,r);

[cnot,cz,zgate,hadgate] = ChangeTol(1e-6,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p] = Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol_idle1(2) = mean(times);
stdev_tol_idle1(2) = std(times);
fid_idle1(2) = Fidelity(rtot,r);

[cnot,cz,zgate,hadgate] = ChangeTol(1e-7,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
end
t_tol_idle1(3) = mean(times);
stdev_tol_idle1(3) = std(times);
fid_idle1(3) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-8,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol_idle1(4) = mean(times);
stdev_tol_idle1(4) = std(times);
fid_idle1(4) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-9,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol_idle1(5) = mean(times);
stdev_tol_idle1(5) = std(times);
fid_idle1(5) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-10,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol_idle1(6) = mean(times);
stdev_tol_idle1(6) = std(times);
fid_idle1(6) = Fidelity(rtot,r);

DoneNotification();
%% State prep bit & phase with idle2 & tol
[cnot,cz,zgate,hadgate] = SetIdleState(2,cnot,cz,zgate,hadgate);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-5,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    
    times(i) = toc;
end
t_tol_idle2(1) = mean(times);
stdev_tol_idle2(1) = std(times);
fid_idle2(1) = Fidelity(rtot,r);

[cnot,cz,zgate,hadgate] = ChangeTol(1e-6,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p] = Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol_idle2(2) = mean(times);
stdev_tol_idle2(2) = std(times);
fid_idle2(2) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-7,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
end
t_tol_idle2(3) = mean(times);
stdev_tol_idle2(3) = std(times);
fid_idle2(3) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-8,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol_idle2(4) = mean(times);
stdev_tol_idle2(4) = std(times);
fid_idle2(4) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-9,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol_idle2(5) = mean(times);
stdev_tol_idle2(5) = std(times);
fid_idle2(5) = Fidelity(rtot,r);
[cnot,cz,zgate,hadgate] = ChangeTol(1e-10,cnot,cz,zgate,hadgate);
for i = 1:reps
    tic;
    [r,p]=Correct_steane_error(rho,1,'X',0,0,hadgate,cnot,zgate,cz);
    times(i) = toc;
end
t_tol_idle2(6) = mean(times);
stdev_tol_idle2(6) = std(times);
fid_idle2(6) = Fidelity(rtot,r);

DoneNotification();