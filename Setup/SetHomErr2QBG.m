function [varargout] = SetHomErr2QBG(p_err,varargin)
%SETHOMERR2QBG Summary of this function goes here
%   Detailed explanation goes here
for i = 1:nargin-1
    varargout{i} = varargin{i};
    varargout{i}.set_err_hom(p_err);
end

end

