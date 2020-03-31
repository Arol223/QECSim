% Controlled theta-phase gate. Like phase gate but |1> can be rotated
% custom angle theta.
function kCS = kCSTheta(theta, controls, target, nbits)
nrows = 2^nbits;
kCS = speye(nrows);
target_exp = nbits-target;
target_weight = 2^target_exp;
i=0;
while i <= nrows-1
    t_bit = bitand(i,target_weight);
    t_bit = bitshift(t_bit,-target_exp);
    if alltrue(i,controls,nbits) && t_bit
        kCS(i+1,i+1) = exp(1i*theta);
    end
    i = i+1;
end
end