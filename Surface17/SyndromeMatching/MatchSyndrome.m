function [flp_vol, corr_op] = MatchSyndrome(syn_vol, order, type)
%MATCHSYNDROME Match a syndrome with a correction operator by [Tomita2017]
%       ---Input---
%   syn_vol - the syndrome volum considered 
%   order - The order the rules are checked (1 for default, 2 for switched)
%   type - If it's a syndrome from 'X' or 'Z' type stabilisers
%      ---Output---
%   flp_vol - the volume of syndrome flips, scrubbed
%   corr_op - A minimal correction operator by [Tomita2017]


flp_vol = SyndromeFlips(syn_vol);   % Describes where syndrome flips happened
flp_vol = FilterMeasurement(flp_vol);   % Rule 1 from [Tomita2017]
corr_op = repelem('I',9);
if order == 1
    for i = 1:3
        % Rule 2 [Tomita2017]
        [flp_vol, corr_op,~] = SpatialSyndromeMatch(flp_vol,i, type,corr_op);
    end
    % Rule 3 [Tomita2017]
    [flp_vol,corr_op] = TemporalSyndromeMatch(flp_vol,[1 2], type, corr_op);
    [flp_vol, corr_op] = TemporalSyndromeMatch(flp_vol,[2 3], type, corr_op);
elseif order == 2
    % Rule 3 [Tomita2017]
    [flp_vol,corr_op] = TemporalSyndromeMatch(flp_vol,[1 2], type, corr_op);
    [flp_vol, corr_op] = TemporalSyndromeMatch(flp_vol,[2 3], type, corr_op);
    % Rule 2 [Tomita2017]
     for i = 1:3
        [flp_vol, corr_op,~] = SpatialSyndromeMatch(flp_vol,i, type,corr_op);
    end
end
for i = 1:2
[flp_vol,corr_op] = SingleSyndromeMatch(flp_vol,i,type,corr_op);
end

end

