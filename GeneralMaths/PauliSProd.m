function [res] = PauliSProd(g1,g2)
%PAULISPROD Multiply Pauli sigma matrices
%   Detailed explanation goes here

if g1 == 'I'
    res = g2;
elseif g2 == 'I'
    res  = g1;
elseif g1 == g2
    res = 'I';
elseif g1 == 'X'
    switch g2
        case 'Y'
            res = 'Z';
        case 'Z'
            res = 'Y';
    end
elseif g1 == 'Y'
    switch g2
        case 'X'
            res = 'Z';
        case 'Z'
            res = 'X';
    end
elseif g1 == 'Z'
    switch g2
        case 'X'
            res = 'Y';
        case 'Y'
            res = 'X';
    end
end

end

