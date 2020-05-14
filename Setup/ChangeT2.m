function [varargout] = ChangeT2(T2, varargin)
%CHANGET2 changes T2 for a variable number of gates
%   Detailed explanation goes here
for i = 1:nargin - 1
    varargin{i}.T2 = T2;
    varargin{i}.err_from_T();
end

varargout = varargin;

end