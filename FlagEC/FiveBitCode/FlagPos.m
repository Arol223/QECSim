function [flag_pos] = FlagPos(syndrome)
%FLAGPOS returns a vector with the number of flag positions that have to be
%checked for given syndrome
%   Detailed explanation goes here

if syndrome(1)
    flag_pos = [0 1];
elseif syndrome(2)
    flag_pos = [0 2];
elseif syndrome(3)
    flag_pos = [0 3];
elseif syndrome(4)
    flag_pos = [0 4];
else
    flag_pos = 4:-1:0;
end
end

