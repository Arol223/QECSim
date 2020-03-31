% Builds CZ matrix where the control qubits are specified by controls.
function kCZ = kCZ(controls,target,nbits)
nrows = 2^nbits;
kCZ = speye(nrows);
target_exp = nbits-target;
target_weight = 2^target_exp;
i=0;
while i <= nrows-1
    t_bit = bitand(i,target_weight);
    t_bit = bitshift(t_bit,-target_exp);
    if alltrue(i,controls,nbits) && t_bit
        kCZ(i+1,i+1) = -1;
    end
    i = i+1;
end
end