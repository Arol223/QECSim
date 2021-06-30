function [flag_pos] = FlagPos(syndrome)
%FLAGPOS returns a vector with the number of flag positions that have to be
%checked for given syndrome
%   Detailed explanation goes here

if syndrome(1)
    flag_pos = [1 0];
elseif syndrome(2)
    flag_pos = 2:-1:0;
elseif syndrome(3)
    flag_pos = 3:-1:0;
else
    flag_pos = 4:-1:0;
end
end

