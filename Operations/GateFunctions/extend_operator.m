% Builds the matrix for an operator acting on bit index of an nbits qubit
% system.
function A = extend_operator(operator, index, nbits)
I = speye(2);
if index==1
    A = operator;
else
    A = I;
end

for i = 2:nbits
    if i == index
        A = kron(A,operator);
    else
        A = kron(A,I);
    end
end

end