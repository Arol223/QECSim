%% Test qubit/T2 dependence of resting errors
n_res = 15;
t_dur = 1e-5; %TQG duration
T_2_spin = logspace(-3, 3, n_res); % Logarithmically spaced values for spin T_2 between 1 ms and ~6 hours.
T_2_opt = 2.6e-3; % Optical T_2 for Eu at 10 mT
psi = [1/sqrt(2);1/sqrt(2)];
r1 = psi*psi';
r = r1;
p = psi;
fid = zeros(n_res);
for i = 1:n_res
    for j = 1:n_res
        c_phase = DampCoeff(t_dur,T_2_spin(j));
        res = idle_bits(r,1:i,0,c_phase);
        fid(i,j) = 1 - Fid2(p,res);
    end
    r = kron(r,r1);
    p = kron(p,psi);
end

%%
figure()
pcolor(T_2_spin/T_2_opt,1:n_res,fid)
xlabel('T2spin/T2opt')
ylabel('n qubits')