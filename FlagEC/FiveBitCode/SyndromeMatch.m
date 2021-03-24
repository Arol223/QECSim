function [syndrome] = SyndromeMatch(flag_loc, error_n)
%SYNDROMEMATCH Match a flag error with corresponding syndrome
%   Detailed explanation goes here
errors = split(FiveQubitCode.flag_errors(flag_loc,:), ', ');
stabilisers = FiveQubitCode.stabilisers;
error = errors{error_n};
syndrome = zeros(1,4);
for i = 1:4
    stab = stabilisers(i,:);
    par = 0;
    for j = 1:5
        par = mod(par + StabiliserMatch(stab(j),error(j)),2);
    end
    syndrome(i) = par;
end

