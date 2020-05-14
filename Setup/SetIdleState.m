function [varargout] = SetIdleState(idle,varargin)
%SETIDLESTATE sets the idle state of input gates to idle = 0,1,or 2. 0 ->
%no idling, 1 -> idle 
%   Detailed explanation goes here
for i = 1:nargin - 1
    varargin{i}.idle_state = idle;
end

varargout = varargin;

end
