function [corr] = MinWeightMatch(type,syn)
%MINWEIGHTMATCH Ideal error free MW syndrome matching for Surface17


if type == 'X'
    corr = MinWeightXMatch(syn);
else
    corr = XZMap(MinWeightXMatch(syn));
end
end

