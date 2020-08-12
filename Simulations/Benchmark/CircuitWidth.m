%% Test runtime as function of circuit width
width = 1:12;
p_err = 1e-4;
reps = 5;
[cnot, cz, xgate, ygate, zgate, hadgate] = MakeGates(Inf,Inf,zeros(6,1),0,0); %Gates without errors
[cnot,cz,xgate,ygate,zgate,hadgate] = SetErrRate(p_err,cnot,cz,xgate,ygate,zgate,hadgate);
[cnot,cz,xgate,ygate,zgate,hadgate] = ChangeTol(0,cnot,cz,xgate,ygate,zgate,hadgate);
tot_time_sparse = zeros(1,length(width));
tot_time_full = tot_time_sparse;
SEM_sparse = zeros(1,length(width));
SEM_full = SEM_sparse;

rho1 = NbitState();
for i = 1:length(width)
    w = width(i);
  
   rho1.init_all_zeros(w,1e-4)
   rho2 = rand(2^w);
   if w<8
       reps = 25;
   else
       reps = 5;
   end
   times_sparse = zeros(1,reps);
    times_full = times_sparse;
   for r = 1:reps
       tic;
       xgate.apply(rho1,1);
       times_sparse(r) = toc;
       tic;
       rho2^3+rho2^3+rho2^3+rho2^3;
       times_full(r) = toc;
   end
   tot_time_sparse(i) = mean(times_sparse);
   SEM_sparse(i) = std(times_sparse)/reps;
   tot_time_full(i) = mean(times_full);
   SEM_full(i) = std(times_full)/reps;
end
