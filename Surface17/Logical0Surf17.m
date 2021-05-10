function [psi_l, rho_l] = Logical0Surf17()
%LOGICAL0 Summary of this function goes here
%   Detailed explanation goes here
rho_l = NbitState();
rho_l.init_all_zeros(9,0);
cnot = CNOTGate();
had = HadamardGate();
rho_l = MeasureSyndrome(rho_l, [0 0 0 0],'X',cnot,had);
rho_l = MeasureSyndrome(rho_l,[0 0 0 0], 'Z',cnot,had);
a = NbitState();
a.init_all_zeros(1,0);
rho_l.extend_state(a,'start');

rho_l = cnot.apply(rho_l,[1 5 9] + 1, [1 1 1]);
[rho_l,~] = measurement_e(rho_l,1,0,0,1,0);
rho_l.trace_out_bits(1);

% Z = [1 0; 0 -1];
% 
% Z_L = zeros(2,2,9);
% Z_L(:,:,3) = eye(2);
% Z_L(:,:,2) = eye(2);
% Z_L(:,:,1) = Z;
% Z_L(:,:,4) = eye(2);
% Z_L(:,:,5) = Z;
% Z_L(:,:,6) = eye(2);
% Z_L(:,:,9) = Z;
% Z_L(:,:,8) = eye(2);
% Z_L(:,:,7) = eye(2);
% Z_L = tensor_product(Z_L);
% trace(Z_L*rho_l.rho)

[V,~] = eig(full(rho_l.rho));
psi_l = V(:,end);

psi_l(find(abs(psi_l)<0.2)) = 0;
psi_l = sparse(psi_l);
end

