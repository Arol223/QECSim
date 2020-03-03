%Constructs a controlled Z-/phase flip gate between control and target
function CZ_ij = CZ_ij(control, target, nbits) 
nrows=2^nbits;
CZ_ij = speye(nrows);
target_weight = 2^(nbits-target);
control_weight = 2^(nbits-control);
binrep = control_weight + target_weight; % In binary correspnds to c=t=1
for i = 0:nrows-1
    if bitand(binrep,i) == binrep % checks if c&t=1 
       CZ_ij(i+1,i+1) = -1;  
    end
end
spy(CZ_ij)
end