function [varargout] = ChangeTol(tol,varargin)
%CHANGETOL change the tolerance of gates
%   Detailed explanation goes here
for i = 1:nargin - 1
    varargin{i}.tol = tol;
end

varargout = varargin;

end

