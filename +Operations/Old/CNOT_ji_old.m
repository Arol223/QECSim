% Constructs a matrix for a CNOT operation where target<control. Target and
% control refers to bit number.
function CNOT_ji = CNOT_ji_old(control, target, nbits)
nrows=2^nbits;
CNOT_ji = speye(nrows);
p=1:nrows;
target_weight = 2^(nbits-target);
control_weight = 2^(nbits-control);
block_size = target_weight*2;   %Block refers to an ordered set where the target bit is |1>. Size is cardinality
perms_per_block = target_weight/2; %Permutations to be performed in each block
n_blocks = length(p)/block_size;
perms_pre_jump = control_weight; % 
jump_delta = control_weight*2;

for i = 0:block_size:(n_blocks-1)*block_size
    for j = control_weight:jump_delta:perms_per_block*jump_delta/perms_pre_jump
        for k=1:perms_pre_jump
            temp= p(i+j+k);
            p(i+j+k)=p(i+j+k+target_weight);
            p(i+j+k+target_weight)=temp;
        end
    end
end

CNOT_ji = CNOT_ji(p,:);
spy(CNOT_ji)
end