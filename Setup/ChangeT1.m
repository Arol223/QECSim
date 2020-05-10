function [varargout] = ChangeT1(T1,varargin)
%CHANGET1 Summary of this function goes here
%   Detailed explanation goes here
for i = 1:nargin - 1
    varargin{i}.T1 = T1;
    varargin{i}.err_from_T();
end

varargout = varargin;

end

