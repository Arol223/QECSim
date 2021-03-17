function [rho_out] = XNot(cnot, had, rho_in, control, target)
%XNOT Convenience function for applying XNot-gate
%   The XNot-gate is given by H_1 - CNot - H_1, where H_1 is understood to
%   be a Hadamard gate on the control qubit
rho_out = had.apply(rho_in,control);
rho_out = cnot.apply(rho_out, target, control);
rho_out = had.apply(rho_out,control);
end

