% Builds CY matrix where control bits are specified in control.
function kCY = kCY(controls,target,nbits)
nrows = 2^nbits;
phase = speye(nrows);
target_exp = nbits-target;
target_weight = 2^target_exp;
i=0;
while i <= nrows-1
    t_bit = bitand(i,target_weight);
    t_bit = bitshift(t_bit,-target_exp);
    if alltrue(i,controls,nbits) && t_bit
        phase(i+1-target_weight,i+1-target_weight) = 1i;
        phase(i+1,i+1) = -1i;
    end
    i = i+1;
end
flip = kCNOT(controls,target,nbits);
kCY = flip*phase;
%spy(kCY)
end