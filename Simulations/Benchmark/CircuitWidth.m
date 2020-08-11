%% Test runtime as function of circuit width
width = 1:14;
p_err = 0;
reps = 5;
[cnot, cz, xgate, ygate, zgate, hadgate] = MakeGates(Inf,Inf,zeros(6,1),0,0); %Gates without errors
[cnot,cz,xgate,ygate,zgate,hadgate] = SetErrRate(p_err,cnot,cz,xgate,ygate,zgate,hadgate);
[cnot,cz,xgate,ygate,zgate,hadgate] = ChangeTol(0,cnot,cz,xgate,ygate,zgate,hadgate);
tot_time_sparse = zeros(1,length(width));
tot_time_full = tot_time_sparse;
SEM_sparse = zeros(1,length(width));
SEM_full = SEM_sparse;
times_sparse = zeros(1,reps);
times_full = times_sparse;
for i = 1:length(width)
    w = width(i);
   rho1 = rand(2^w);
   rho2 = rand(2^w);
   if w<8
       reps = 25;
   else
       reps = 5;
   end
   for r = 1:reps
       tic;
       xgate.apply(rho1,1);
       times_sparse(r) = toc;
       tic;
       rho2*rho2*rho2;
       times_full(r) = toc;
   end
   tot_time_sparse(i) = mean(times_sparse);
   SEM_sparse(i) = std(times_sparse)/reps;
   tot_time_full(i) = mean(times_full);
   SEM_full(i) = std(times_full)/reps;
end
