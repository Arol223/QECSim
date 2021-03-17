function [varargout] = SetDampCoeff(c_phase, c_amp, varargin)
%SETERRRATE Set the error rate of input gates to p_err and randomise
%errors;
%   Detailed explanation goes here
for i = 1:length(varargin)
    varargout{i} = varargin{i};
    varargout{i}.set_damp_coeff(c_phase,c_amp);
end