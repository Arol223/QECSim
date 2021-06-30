function [OpMat] = BuildOpMat(rep)
%BUILDOPMAT Build an operator matrix from a string representation e.g. IXY
%   Detailed explanation goes here
I = eye(2);
X = [0 1; 1 0];
Y = [0 -1i;1i 0];
Z = [1 0; 0 -1];

L = length(rep);
OpMat = zeros (2,2,L);

for i = 1:L
    op = rep(i);
    switch op
        case 'I'
            OpMat(:,:,i) = I;
        case 'X' 
            OpMat(:,:,i) = X;
        case 'Y'
            OpMat(:,:,i) = Y;
        case 'Z' 
            OpMat(:,:,i) = Z;
    end
end
OpMat = tensor_product(OpMat);
    
end

