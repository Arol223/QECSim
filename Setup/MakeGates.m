function [cnot, cz, xgate, ygate,zgate, hadgate] = MakeGates(T1, T2, t_dur_2qbg,...
    t_dur_sqbg, ~, idle_state)
%MAKEGATES Creates gates with the chosen parameters.
%   Builds gates for system with given T1 and T2. The operation times for
%   the gates are given in t_dur, and setting any of these to 0 will ignore
%   amplitude and phase damping. Input args bitflip and phaseflip are
%   booleans and determines whether to include just bitflips, just
%   phaseflips or both. tol sets the tolerance of the gates, meaning that
%   th state after the gate will not include terms smaller than tol in
%   absolute value.

tol = 0;
cnot = CNOTGate(tol,t_dur_2qbg,T1,T2, idle_state);
cz = CZGate(tol,t_dur_2qbg,T1,T2,idle_state);
xgate = XGate(tol,t_dur_sqbg,T1,T2,idle_state);
ygate = YGate(tol,t_dur_sqbg,T1,T2,idle_state);
zgate = ZGate(tol,t_dur_sqbg,T1,T2,idle_state);
hadgate = HadamardGate(tol,t_dur_sqbg,T1,T2,idle_state);
end

