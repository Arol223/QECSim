function [varargout] = SetErrDiff(p_x,p_y,p_z,varargin)
%SETERRDIFF Use to set the bitflip and phaseflip error rates for multiple
%gates at once.

for i = 1:length(varargin)
    varargout{i} = varargin{i};
    varargout{i}.set_err(p_x,p_y,p_z);
end
end

