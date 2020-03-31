function p = measure_prob(rho, target, val, nbits)
% The probability to measure the target i.e. if psi = a|0>+b|1>, val = 0
% ->p=|a|^2.
 max = 2^nbits;
    bit_exp = nbits-target;
    bit_weight = 2^bit_exp;
    p = 0;
    for i = 0:max-1
       t_bit = bitand(i, bit_weight); % t_bit is the value of the selected bit
       t_bit = bitshift(t_bit, -bit_exp); % This and the previous line extracts the value of the bit in the given state.
       if t_bit == val
           p = p + rho(i+1,i+1);
       end
    end
end