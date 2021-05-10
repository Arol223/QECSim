function [flp_vol] = FilterMeasurement(flp_vol)
%FILTERMEASUREMENT Filter out syndrome flip pairs happening in consecutive
%measurements
%   Detailed explanation goes here
[m,n,~] = size(flp_vol);

for i = 1:m % Removes time paired flips as these are most likely measurement errors
    for j = 1:n
        if (flp_vol(i,j,1) && flp_vol(i,j,2))  
            flp_vol(i,j,1) = 0;
            flp_vol(i,j,2) = 0;
        elseif flp_vol(i,j,2) && flp_vol(i,j,3)
            flp_vol(i,j,2) = 0;
            flp_vol(i,j,3) = 0;
        end
    end
end
end

