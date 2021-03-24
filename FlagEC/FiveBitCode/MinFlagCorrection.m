function [x_inds, y_inds, z_inds] = MinFlagCorrection(error)
%MINFLAGCORRECTION Summary of this function goes here
%   Detailed explanation goes here
x_inds = [];
y_inds = [];
z_inds = [];
for i = 1:5
    switch error(i)
        case 'X'
            x_inds = [x_inds i];
        case 'Y'
            y_inds = [y_inds i];
        case 'Z'
            z_inds = [z_inds i];
    end
end

