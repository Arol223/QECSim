% Constructs a Tofolli gate with c_1 and c_2 as control bits, and t as
% target bit
function Tof = Tof_ijk(c_1, c_2, t, nbits)
nrows=2^nbits;
Tof = speye(nrows);
target_weight = 2^(nbits-t);
c_1_weight = 2^(nbits-c_1);
c_2_weight = 2^(nbits-c_2);
c_1_exp = nbits-c_1; % Control bit exponent
c_2_exp = nbits-c_2;
t_exp = nbits-t;   % Target bit exponent
i = 0;
p = 1:nrows;

while i <= nrows-target_weight-1
    c_1_bit = bitand(i, c_1_weight);
    c_1_bit = bitshift(c_1_bit, -c_1_exp);
    c_2_bit = bitand(i, c_2_weight);
    c_2_bit = bitshift(c_2_bit, -c_2_exp);
    t_bit = bitand(i, target_weight);
    t_bit = bitshift(t_bit, -t_exp);
    if c_1_bit && c_2_bit && ~t_bit
        temp = p(i+1);
        p(i+1) = p(i+1+target_weight);
        p(i+1+target_weight) = temp;
    end
    i=i+1;
end
Tof = Tof(p,:);
spy(Tof)
end