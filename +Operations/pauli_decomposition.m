% Finds the deomposition of U in terms of the pauli matrices I, X, Y & Z.
function u_ixyz = pauli_decomposition(U)
X = [0 1; 1 0];
Y = [0 -1i; 1i 0];
Z = [1 0;0 -1];
I = eye(2);
u_ixyz = zeros(4,1);
u_ixyz(1) = (1/2) * trace(I*U);
u_ixyz(2) = (1/2) * trace(X*U);
u_ixyz(3) = (1/2) * trace(Y*U);
u_ixyz(4) = (1/2) * trace(Z*U);
test = u_ixyz(1)*I + u_ixyz(2)*X + u_ixyz(3)*Y + u_ixyz(4)*Z;
isequal(U,test)
end