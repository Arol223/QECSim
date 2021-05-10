function [flp_vol, corr_op] = TemporalSyndromeMatch(flp_vol, lvls, type, corr_op)
%TEMPORALSYNDROMEMATCH Temporal error chain matching, see [Tomita 2017]
%   ---Inputs---
%   flp_vol - The volume describing which syndrome flips occurred
%   lvls    - The levels between which to check for matches ([1 2] or [2 3])
%   type    - 'X' or 'Z' type syndrome
%   corr_op - Input correction operator

if isequal(lvls, [1 2])
    planes = flp_vol(:,:,1) + flp_vol(:,:,2);
    planes = mod(planes,2);
elseif isequal(lvls, [2 3])
    planes = flp_vol(:,:,2) + flp_vol(:,:,3);
    planes = mod(planes,2);
end

[~, corr_op, scenario] = SpatialSyndromeMatch(planes,1,type,corr_op);
switch scenario
    case 0 
        return
    case 1
        if type == 'X'
            flp_vol(1, 1:2, lvls(1):lvls(2)) = zeros(1,2,2);
        elseif type == 'Z'
            flp_vol(1, 1:2, lvls(1):lvls(2)) = zeros(1,2,2);
        end
    case 2
        if type == 'X'
            flp_vol(1,2,lvls(1):lvls(2)) = zeros(1,1,2);
            flp_vol(2,1,lvls(1):lvls(2)) = zeros(1,1,2);
        elseif type == 'Z'
            flp_vol(1,2,lvls(1):lvls(2)) = zeros(1,1,2);
            flp_vol(2,1,lvls(1):lvls(2)) = zeros(1,1,2);
        end
    case 3
        if type == 'X'
            flp_vol(2,1:2,lvls(1):lvls(2)) = zeros(1,2,2);
        elseif type == 'Z'
            flp_vol(2,1:2,lvls(1):lvls(2)) = zeros(1,2,2);
        end
    case 4
        if type == 'X'
            flp_vol(:,:,lvls(1):lvls(2)) = zeros(2,2,2);
        elseif type == 'Z'
            flp_vol(:,:,lvls(1):lvls(2)) = zeros(2,2,2);
        end
end

end

