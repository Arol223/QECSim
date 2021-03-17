function [varargout] = SetErrDiff(p_bit,p_phase,varargin)
%SETERRDIFF Use to set the bitflip and phaseflip error rates for multiple
%gates at once.

for i = 1:length(varargin)
    varargout{i} = varargin{i};
    varargout{i}.set_err(p_bit,p_phase);
end
end

