% Traces out qubits of rho specified in bit_positions following the 
% algorithm in https://arxiv.org/pdf/1709.06346.pdf
function rho_prime = qubit_partial_trace(rho, bit_positions)
nbits = log2(size(rho,1));
nbits_reduced = nbits - length(bit_positions);
bit_exp = nbits-bit_positions;
weights = 2.^(bit_exp);
P = PowerSet(weights);  % Power set P of S is the set of all subsets of S. |P|=2^|S| 
rho_prime = zeros(2^nbits_reduced);

for n = 1:2^nbits_reduced
    for m = 1:2^nbits_reduced
        for k = P
            delta = sum(cell2mat(k));
            rho_prime(n,m) = rho_prime(n,m) + rho(n+delta,m+delta); 
        end
    end
end
end