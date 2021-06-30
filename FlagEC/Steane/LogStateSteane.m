function [rho_out] = LogStateSteane(rho_in)
%LOGSTATESTEANE Find logical state of Steane code
I = eye(2);
X = [0 1; 1 0];
Y = [0 -1i;1i 0];
Z = [1 0; 0 -1];

X_L = 'XXXXXXX';%SteaneColorCode.log_x;
Z_L = 'ZZZZZZZ';%SteaneColorCode.log_z;

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

