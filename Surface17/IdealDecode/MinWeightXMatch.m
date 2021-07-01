function [cor] = MinWeightXMatch(Syn)
%MINWEIGHTXMATCH Match a surface17 X-syndrome to minimum weight correction
%   
syn = binvec2dec(Syn);
switch syn
    case 0
        cor = [];
    case 1
        cor = 6;
    case 2
        cor = 9;
    case 3
        cor = 8;
    case 4
        cor = 1;
    case 5
        cor = [1 7];
    case 6
        cor = 5;
    case 7
        cor = [5 7];
    case 8
        cor = 3;
    case 9
        cor = [3 7];
    case 10
        cor = [3 6];
    case 11
        cor = [3 8]; 
    case 12
        cor = 2;
    case 13
        cor = [2 7];
    case 14
        cor = [3 5];
    case 15
        cor = [2 8];
end

