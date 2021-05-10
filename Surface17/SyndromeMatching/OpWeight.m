function [wt] = OpWeight(op)
%OPWEIGHT Calculate the weight of a Pauli operator as numer of qubits with
%non trivial support
%   Detailed explanation goes here

wt = 0;
for i = 1:length(op)
    if op(i) ~= 'I'
        wt = wt + 1;
    end
end
end

