% Builds a vector that can be used for projective mesurements or projecting
% density matrices given that the qubit specified by target is 0 or 1,
% as specified in val. As with all other functions in this suite, the
%  leftmost qubit, i.e. the msb, in a ket is taken to be bit number 1.
%  Qubits in circuits are counted from top to bottom, regardless if the top
%  block is an ancilla or data block. the top qubit is always counted as
%  bit number 1, and is also the msb. 
function p = proj_vector(nbits, target, val)
    max = 2^nbits;
    bit_exp = nbits-target;
    bit_weight = 2^bit_exp;
    p = zeros(max,1);
    for i = 0:max-1
       t_bit = bitand(i, bit_weight); % t_bit is the value of the selected bit
       t_bit = bitshift(t_bit, -bit_exp); % This and the previous line extracts the value of the bit in the given state.
       if t_bit == val
           p(i+1) = 1;
       end
    end
    p = sparse(p);
end