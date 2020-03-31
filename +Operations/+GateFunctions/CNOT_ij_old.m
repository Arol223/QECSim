%Constructs a CNOT gate between arbitrary qubits where control<target
function CNOT_ij = CNOT_ij_old(control, target, nbits) 
CNOT_ij = speye(2^nbits,2^nbits); % Sparse identity used to build permutation matrix
n_rows = 2^nbits;
p = 1:n_rows; % Permutation vector

control_weight = 2^(nbits-control); % Power of 2 corresponding to control bit, counting bit number from left to right. 
target_weight = 2^(nbits-target);
for i = control_weight+1:control_weight*2:n_rows +1 -control_weight 
    p(i:i+control_weight-1) = not_permutation_ij(target_weight, p(i:i+control_weight-1));
end
CNOT_ij = CNOT_ij(p,:);
spy(CNOT_ij)


end