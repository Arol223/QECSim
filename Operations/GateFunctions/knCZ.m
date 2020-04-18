function C = knCZ( controls, targets, nbits )
%KNCZ A transversal Z-gate matrix where wvery control controls one target. 
%   Detailed explanation goes here
    C = kCZ(controls(1), targets(1), nbits);
    for i = 2:length(controls)
        C = kCZ(controls(i),targets(i),nbits)*C;
    end
end

