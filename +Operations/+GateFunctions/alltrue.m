% Returns 1 if the bits of bin at positions specified in control are all 1,
% else returns 0
function bool = alltrue(bin, control_bits, nbits)
bool = 1;
for i=control_bits
    exp = nbits - i;
    val = bitand(bin, 2^exp);
    val = bitshift(val, -exp);
    bool = bool&&val;
end
end