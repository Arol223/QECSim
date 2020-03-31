% Creates operation matrix for a CNOT-gate with k control bits specified in
% controls. Returns both the operator in matrix form and the permutation
% vector. 
function [kCNOT, p] = kCNOT(controls, target, nbits)
import Operations.GateFunctions.alltrue
nrows = 2^nbits;
kCNOT = speye(nrows);
target_exp = nbits-target;
target_weight = 2^target_exp;
p=1:nrows;
i=0;
while i<=nrows-target_weight-1
    t_bit = bitand(i,target_weight);
    t_bit = bitshift(t_bit,-target_exp);
    if alltrue(i,controls,nbits) && ~t_bit
        temp = p(i+1);
        p(i+1) = p(i+1+target_weight);
        p(i+1+target_weight) = temp;
    end
    i = i+1;
end
kCNOT = kCNOT(p,:);
%spy(kCNOT)
end