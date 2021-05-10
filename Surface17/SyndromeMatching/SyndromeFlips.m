function [FlipVolume] = SyndromeFlips(SyndromeVolume)
%SYNDROMEFLIPS Calculates where syndrome flips have happened from a
%syndrome volume
%   Detailed explanation goes here
FlipVolume = zeros(size(SyndromeVolume));
grid_sz = size(FlipVolume,1);
grid_depth = size(FlipVolume,3); % Corresponds to number of cycles before EC attempted

for i = 1:grid_sz
    
    for j = 1:grid_sz
        
        for k = 1:grid_depth
            if k == 1 && SyndromeVolume(i,j,k) % Assumes syndrome starts at 0
                FlipVolume(i,j,k) = 1;
            elseif k ~= 1 && (SyndromeVolume(i,j,k-1) ~= SyndromeVolume(i,j,k))
                FlipVolume(i,j,k) = 1;
            end    
        end
    end
end
end

