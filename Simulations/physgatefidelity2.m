% Fidelity for 30 random SQG as function of T2
T1 = 2e-3;
ngates = 30;
[~,~,xgate,ygate,zgate,hadgate] = MakeGates(T1,Inf,3.36e-6*ones(1,6),0,0);
[~,~,xg,yg,zg,hg] = MakeGates(Inf,Inf,zeros(1,6),0,0);
rho = NbitState([1 0;0 0]);
T2_range = linspace(2e-6,2*T1,2e3);
Fid = zeros(1,length(T2_range));
for i = 1:length(T2_range)
    [xgate,ygate,zgate,hadgate] = ChangeT2(T2_range(i),xgate,ygate,zgate,hadgate);
    gates = randi(4,1,ngates);
    res = rho;
    targ = rho;
    for j = 1:ngates
        pick = gates(j);
            switch pick
                case 1
                    gate = xgate;
                    cg = xg;
                case 2
                    gate = ygate;
                    cg = yg;
                case 3
                    gate = zgate;
                    cg = zg;
                case 4
                    gate = hadgate;
                    cg = hg;
            end
            res=gate.apply(res,1);
            targ = cg.apply(targ,1);    
    end
    Fid(i) = Fidelity(targ,res);
    
end
DoneNotification()
plot(T2_range,Fid)
xlabel('T2 [s]')
ylabel('Fidelity')
title('Fidelity as function of T2 for 30 random physical gates')