function [rho_out] = LogStateSurf17(rho_in)
%LOGSTATESURF17 Build Logical density matrix from full density matrix

I = eye(2);
X = [0 1; 1 0];
Y = [0 -1i;1i 0];
Z = [1 0; 0 -1];


X_L = BuildOpMat(OpFromCheck([Surface17.LogX zeros(1,9)],1));
Z_L = BuildOpMat(OpFromCheck([zeros(1,9) Surface17.LogZ],1));
Y_L = 1i*X_L*Z_L;
if isa(rho_in,'NbitState')
    r = rho_in.rho;
else
    r = rho_in;
end

rho_out = (trace(r)*I + trace(X_L*r)*X + trace(Y_L*r)*Y + trace(Z_L*r)*Z)/2;

end

