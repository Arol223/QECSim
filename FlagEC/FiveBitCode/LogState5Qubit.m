function [rho_out] = LogState5Qubit(rho_in)
%LOGSTATE5QUBIT Find Logical state of 5qubit code

I = eye(2);
X = [0 1; 1 0];
Y = [0 -1i;1i 0];
Z = [1 0; 0 -1];

X_L = FiveQubitCode.X_L;
Z_L = FiveQubitCode.Z_L;
X_L = BuildOpMat(X_L);
Z_L = BuildOpMat(Z_L);
Y_L = 1i*X_L*Z_L;

if isa(rho_in,'NbitState')
    r = rho_in.rho;
else
    r = rho_in;
end

rho_out = (trace(r)*I + trace(X_L*r)*X + trace(Y_L*r)*Y + trace(Z_L*r)*Z)/2;
end

