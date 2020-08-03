%% Tolerance tests
p_err = 1e-8;

[cnot, cz, xgate, ygate, zgate, hadgate] = MakeGates(Inf,Inf,zeros(6,1),0,0); %Gates without errors
[cnot,cz,xgate,ygate,zgate,hadgate] = SetErrRate(p_err,cnot,cz,xgate,ygate,zgate,hadgate);
rho = NbitState();
rho.init_all_zeros(7,0)

tols = logspace(-8,-16,10);
tols = [tols,0];
reps = 5;
tot_times = zeros(1,length(tols));
stdevs = tot_times;
times = zeros(1,reps);
[psi_l,rho_l] = LogicalZeroSteane();
fids = zeros(1,length(tols));
for j = 1:length(tols)
    tol = tols(j);
    [cnot,cz,xgate,ygate,zgate,hadgate] = ChangeTol(tol,cnot,cz,xgate,ygate,zgate,hadgate);
   for i = 1:reps
       tic;
       rtmp = Correct_steane_error(rho,1,'X',p_err,p_err,hadgate,cnot,zgate,cz);
       rtmp = Correct_steane_error(rtmp,1,'Z',p_err,p_err,hadgate,cnot,xgate,cz);
       times(i)=toc;
   end
   tot_times(j) = mean(times);
   stdevs(j) = std(times);
   fids(j) = 1-Fid2(psi_l,rtmp);
end
DoneNotification()