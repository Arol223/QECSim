T1 = 2e-3;
ngates = 10;
[cnot,cz,~,~,~,~] = MakeGates(T1,Inf,7.7e-6*ones(1,6),0,1);
[cnot2,cz2,~,~,~,h] = MakeGates(Inf,Inf,zeros(1,6),0,0);

rho = NbitState([1 0;0 0]);
rho = h.apply(rho,1);
rho = rho*rho; % Test state (|0>+|1>)x(|0>+|1>)
T2_range = linspace(2e-6,2*T1,2000);
fid = zeros(1,length(T2_range));
for i = 1:length(T2_range)
    [cnot,cz] = ChangeT2(T2_range(i),cnot,cz);
    res = rho;
    targ = rho;
    gates = randi(2,1,ngates);
    for j = 1:ngates
        pick = gates(j);
        switch pick
            case 1 
                gate = cnot;
                cg = cnot2;
            case 2
                gate = cz;
                cg = cz2;
        end
        res = gate.apply(rho,1,2);
        targ = cg.apply(rho,1,2);
    end
    fid(i) = Fidelity(res,targ);
end
DoneNotification()
%% Plotting
plot(T2_range,fid)
xlabel('T2 [s]')
ylabel('Fidelity')
title('Fidelity as function of T2 for 10 random 2-qubit gates')


%%
warning('off','MATLAB:sqrtm:SingularMatrix') %Matrices are singular but have roots..
T2 = T1;
[cnot,cz] = ChangeT2(T2,cnot,cz);
error_rate = 0:1e-5:1e-2;
fid = zeros(1,length(error_rate));
for i = 1:length(error_rate)
    cnot.random_err(error_rate(i));
    cz.random_err(error_rate(i));
    res = rho;
    targ = rho;
    gates = randi(2,1,ngates);
    for j = 1:ngates
        pick = gates(j);
        switch pick
            case 1 
                gate = cnot;
                cg = cnot2;
            case 2
                gate = cz;
                cg = cz2;
        end
        res = gate.apply(rho,1,2);
        targ = cg.apply(rho,1,2);
    end
    fid(i) = Fidelity(res,targ);
end
DoneNotification()
%% Plotting
plot(error_rate,fid)
xlabel('error rate')
ylabel('Fidelity')
title('Fidelity as function of error rate for 10 random 2-qubit gates')
