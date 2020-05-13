function [gate] = CleanGate(gate)
%CLEANGATE Make a clean version of a gate, i.e. without errors
%   Detailed explanation goes here
gate.T1 = Inf;
gate.T2 = Inf;
gate.operation_time = 0;
gate.tol = 0;
gate.err_from_T;
end

