% Matrix for Hadamard gate acting on bit i of an nbits register
function H_i = H_i(i, nbits)
    H = (1/sqrt(2))*[1 1;1 -1];
    H_i = extend_operator(H, i, nbits);
end