function [varargout] = SetErrRate(p_err,varargin)
%SETERRRATE Set the error rate of input gates to p_err and randomise
%errors;
%   Detailed explanation goes here
for i = 1:nargin-1
    varargout{i} = varargin{i};
    varargout{i}.rand_error(p_err);
end

