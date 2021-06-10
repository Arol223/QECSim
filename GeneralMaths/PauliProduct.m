function [res] = PauliProduct(g1,g2)
%PAULIPRODUCT Multiply 2 Pauli Group operators. Does not take global phase
%in account.
%
lg1 = length(g1);
lg2 = length(g2);
if lg1>lg2
    g = g2;
    res = g1;
    n = lg2;
elseif lg2 > lg1
    g = g1;
    res = g2;
    n = lg1;
else
    g = g1;
    res = g2;
    n = lg1;
end

for i = 1:n
    res(i) = PauliSProd(res(i),g(i));
end
end

