%% Test state preparation
import States.*
import Operations.*
import GeneralMaths.*
cat = zeros(2^4,1);
cat(1) = 1;
cat(end) = 1;
cat=cat/norm(cat);
cat = sparse(cat*cat'); % Density matrix of 4 ancilla cat state
rho = zeros(2^7,2^7);
rho(1,1) = 1; % Density matrix for 7 qubits prepared in |0000000>
ex_rho = kron(cat,rho);
K_1 = speye(2^11);
cont = 4;
for i = 8:11    % Building the generator matrix
    K_1 = K_1*kCNOT(cont,i,11); 
    cont = cont-1;
end

cnot = knCNOT([3,2,1],[4,3,2],11);
%cnot = cnot'; % Need to reverse order to go bottom to top
Had = extend_operator((1/sqrt(2))*[1 1;1 -1],1,11);
proj = eye(2^11);
proj(2^10+1:end,2^10+1:end) = 0; 
ex_rho = K_1*ex_rho*K_1'; % Applying K_1
%ex_rho = cnot*ex_rho*cnot';
c1 = kCNOT(3,4,11);
c2 = kCNOT(2,3,11);
c3 = kCNOT(1,2,11);
ex_rho = c1*ex_rho*c1';
ex_rho = c2*ex_rho*c2';
ex_rho = c3*ex_rho*c3';
ex_rho = Had*ex_rho*Had';



ex_rho = proj*ex_rho*proj'; % Projecting onto |0xxxxxxxxxx>
ex_rho = ex_rho/trace(ex_rho); % Normalise
post = TrX(ex_rho,1,[16,2^7]);
spy(post)