function [t_dur,ptot] = GateTime(p_err, T1, T2)
%GATETIME Calculate SQBG duration given error rate, T1 and T2
%   Detailed explanation goes here
p = @(t) 2*(1-exp(-t/T1)) + (1-exp(-t/T2)) - p_err;
t0 = -log(1-p_err)*T1;

t_dur = fsolve(p,t0);
ptot = p(t_dur)+p_err;
end

