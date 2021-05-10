function [flp_vol, corr_op] = SingleSyndromeMatch(flp_vol,lvl,type, corr_op)
%SINGLESYNDROMEMATCH Find correction for a single flipped syndrome
%   Detailed explanation goes here
plane = flp_vol(:,:,lvl);

if type == 'X'
    if plane(1,1)
        corr_op(3) = PauliProduct(corr_op(3),'Z');
        plane(1,1) = 0;
    end
    if plane(1,2)
        corr_op(1) = PauliProduct(corr_op(1),'Z');
        plane(1,2) = 0;
    end
    if plane(2,1)
        corr_op(6) = PauliProduct(corr_op(6),'Z');
        plane(2,1) = 0;
    end
    if plane(2,2)
        corr_op(7) = PauliProduct(corr_op(7),'Z');
        plane(2,2) = 0;
    end
elseif type == 'Z'
    if plane(1,1)
        corr_op(1) = PauliProduct(corr_op(1),'X');
        plane(1,1) = 0;
    end
    if plane(1,2)
        corr_op(7) = PauliProduct(corr_op(7),'X');
        plane(1,2) = 0;
    end
    if plane(2,1) 
        corr_op(2) = PauliProduct(corr_op(2),'X');
        plane(2,1) = 0;
    end
    if plane(2,2)
        corr_op(9) = PauliProduct(corr_op(9),'X');
        plane(2,2) = 0;
    end
    
    flp_vol(:,:,lvl) = plane;
end

