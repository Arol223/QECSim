function [cnot, cz, xgate, ygate,zgate, hadgate] = MakeGates(T1, T2, t_dur,...
            ~, idle_state)
%MAKEGATES Creates gates with the chosen parameters.
%   Builds gates for system with given T1 and T2. The operation times for
%   the gates are given in t_dur, and setting any of these to 0 will ignore
%   amplitude and phase damping. Input args bitflip and phaseflip are
%   booleans and determines whether to include just bitflips, just
%   phaseflips or both. tol sets the tolerance of the gates, meaning that
%   th state after the gate will not include terms smaller than tol in
%   absolute value.
if size(t_dur,1) == 1
    t_dur = t_dur.';
end
tol = 1e-16;
cnot = CNOTGate(tol,t_dur(1),T1,T2, idle_state);
cz = CZGate(tol,t_dur(2),T1,T2,idle_state);
xgate = XGate(tol,t_dur(3),T1,T2,idle_state);
ygate = YGate(tol,t_dur(4),T1,T2,idle_state);
zgate = ZGate(tol,t_dur(5),T1,T2,idle_state);
hadgate = HadamardGate(tol,t_dur(6),T1,T2,idle_state);
end

