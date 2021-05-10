function [corr_op] = MinimalCorrection(syn_vol,type)
%MINIMALCORRECTION Return a minimal correction following [Tomita2017]
%   Detailed explanation goes here
[flp1, corr1] = MatchSyndrome(syn_vol,1,type);
[flp2, corr2] = MatchSyndrome(syn_vol,2,type);

if OpWeight(corr1) <= OpWeight(corr2)
    corr_op = corr1;
else
    corr_op = corr2;
end
end

