% Build a controlled Y gate with control as control and target as target
function CY_ij = CY_ij(control,target,nbits)
nrows=2^nbits;
target_weight = 2^(nbits-target);
control_weight = 2^(nbits-control);
binrep = control_weight + target_weight; % In binary correspnds to c=t=1
phase = speye(nrows);
for i = 0:nrows-1
    if bitand(binrep,i) == binrep % checks if c&t=1 
       phase(i+1-target_weight,i+1-target_weight) = 1i; 
       phase(i+1,i+1) = -1i;  
    end
end
flip = CNOT2_ij(control,target,nbits);
CY_ij = flip*phase;
spy(CY_ij)
end