function [t_dur,ptot] = GateTime(p_err, T1, T2)
%GATETIME Calculate SQBG duration given error rate, T1 and T2
%   Detailed explanation goes here
if T1
    p = @(t) 2*(1-exp(-t/(2*T1))) + (1-exp(-t/(2*T2))) - p_err;
    t0 = -log(1-p_err)*T1;
else
    p = @(t) 1 - exp(-t/(2*T2)) - p_err;
    t0 = -log(1-p_err)*T2;
end
t_dur = fsolve(p,t0);
ptot = p(t_dur)+p_err;
end

