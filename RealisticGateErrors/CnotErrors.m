function [p_err] = CnotErrors(t_dur,T1,T2)
%CNOTERRORS Build Error matrix for cnot/cz gates based on ref in other

[p_X, p_Z] = CoeffsFromT12(t_dur,T1,T2);

p_IX = p_X*(1 - 2*p_X - p_Z);
p_XX = p_X^2;
p_XZ = p_X*P_Z;
p_IZ = p_Z*(1 - 2*p_X - p_Z);
p_ZZ = p_Z^2;

p_err = [0 p_IX p_IX p_IZ;
    p_IX p_XX p_XX p_XZ;
    p_IX p_XX p_XX p_XZ;
    p_IZ p_XZ p_XZ p_ZZ];
end

