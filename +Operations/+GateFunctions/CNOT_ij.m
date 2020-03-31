% Builds a CNOT operation matrix with control as control and target as
% target for a system of size nbits.
function CNOT = CNOT_ij(control,target,nbits)
nrows=2^nbits;
CNOT = speye(nrows);
target_weight = 2^(nbits-target);
control_weight = 2^(nbits-control);
c_exp = nbits-control; % Control bit exponent
t_exp = nbits-target;   % Target bit exponent
i = 0;
p = 1:nrows;
while i <= nrows - target_weight - 1
    cont_bit = bitand(i,control_weight);
    cont_bit = bitshift(cont_bit,-(c_exp)); % Value of the control bit
    targ_bit = bitand(i,target_weight);
    targ_bit = bitshift(targ_bit, -(t_exp)); % Value of target bit
    if cont_bit && ~targ_bit % Want to permute so e.g. |10> -> |11>, but only need to permute rows once.
       temp = p(i+1);
       p(i+1) = p(i+1+target_weight);
       p(i+1+target_weight) = temp;
    end
    i=i+1;
end
CNOT=CNOT(p,:);
%spy(CNOT)
end