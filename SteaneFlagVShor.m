p_err = logspace(-5,-2,8);




fid_shor = zeros(1,8);
fid_flag = zeros(1,8);

parfor i = 1:8
    [rho,psi] = Log0FlagSteane();
    rho = NbitState(rho);
    
    p = p_err(i);
    p_cnot = 10*p;
    rho.e_init = p;
    rho.e_ro = p_cnot;
    rho.sym_ro = 1;
    [cnot,cz,xgate,~,zgate,had] = MakeGates(0,0,0,0,0,0);
    [xgate,zgate,had] = SetErrDiff(p/3,p/3,p/3, xgate, zgate, had); 
    [cnot,cz] = SetHomErr2QBG(p_cnot,cnot,cz);
    
    [r_shor,p_shor1] = CorrectSteaneShorError(rho,1,'X',cnot,cz,had,xgate,zgate);
    [r_shor,p_shor2] = CorrectSteaneShorError(r_shor,1,'Z',cnot,cz,had,xgate,zgate);
    
    [r_flag,p_flag1] = FullFlagCorrection(rho,1,'X',cnot,had,zgate,xgate);
    [r_flag,p_flag2] = FullFlagCorrection(r_flag,1,'Z',cnot,had,xgate,zgate);
    
    fid_shor(i) = 1 - Fid2(psi,r_shor);
    fid_flag(i) = 1 - Fid2(psi,r_flag);
end

figure()
plot(p_err,fid_shor);
hold on
plot(p_err,fid_flag);
set(gca,'xscale','log')
set(gca,'yscale','log')
legend('shor','flag')
xlabel('p_err')
ylabel('\epsilon')
