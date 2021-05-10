function [flp_vol, corr_op, scenario] = SpatialSyndromeMatch(flp_vol,lvl,type, corr_op)
%SPATIALSYNDROMEMATCH Matches syndromes that have flipped in space with a
%correction operator and filters results from flip volume
%   ---Input---
%   flp_vol - The volume describing which syndrome flips occurred
%   lvl     - Which level of the volume to check
%   type    - If it's an X or Z type measurement result

plane = flp_vol(:,:,lvl);

c1 = plane(1,1) && plane(1,2);
c2 = plane(1,2) && plane(2,1);
c3 = plane(2,1) && plane(2,2);

scenario = 0;
if c1
    if c3
        scenario = 4;
    else
        scenario = 1;
    end
elseif c2
    scenario = 2;
elseif c3
    scenario = 3;
end

switch scenario
    
    case 0 
        return
    case 1
        if type == 'X'
            corr_op(2) = PauliProduct(corr_op(2), 'Z');
        elseif type == 'Z'
            corr_op(4) = PauliProduct(corr_op(4), 'X');
        end
        flp_vol(1,1,lvl) = 0;
        flp_vol(1,2,lvl) = 0;
    case 2
        if type == 'X'
            corr_op(5) = PauliProduct(corr_op(5),'Z');
        elseif type == 'Z'
            corr_op(5) = PauliProduct(corr_op(5),'X');
        end
        flp_vol(1,2,lvl) = 0;
        flp_vol(2,1,lvl) = 0;
    case 3
        if type == 'X'
            corr_op(8) = PauliProduct(corr_op(8), 'Z');
        elseif type == 'Z'
            corr_op(6) = PauliProduct(corr_op(6), 'X');
        end
        flp_vol(2,1,lvl) = 0;
        flp_vol(2,2,lvl) = 0;
    case 4
        if type == 'X'
            corr_op(2) = PauliProduct(corr_op(2), 'Z');
            corr_op(8) = PauliProduct(corr_op(8), 'Z');
        elseif type == 'Z'
            corr_op(4) = PauliProduct(corr_op(4), 'X');
            corr_op(6) = PauliProduct(corr_op(6), 'X');
        end
        flp_vol(:,:,lvl) = zeros(size(flp_vol(:,:,lvl)));
end
end

