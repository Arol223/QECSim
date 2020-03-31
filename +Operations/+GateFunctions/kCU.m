% Construct a matrix for a controlled U operation on one qubit,
% where the control qubits are specified in controls and
% target is the target qubit.
function kCU = kCU(U, controls, target, nbits)
u_ixyz = pauli_decomposition(U);
X = kCNOT(controls,target,nbits);
Y = kCY(controls,target,nbits);
Z = kCZ(controls,target,nbits);
I = speye(2^nbits);
kCU = u_ixyz(1)*I + u_ixyz(2)*X + u_ixyz(3)*Y + u_ixyz(4)*Z;
end