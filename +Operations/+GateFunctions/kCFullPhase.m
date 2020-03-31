% Operation matrix for controlled phase shift theta of target qubit. Corresponds
% to rotation around z-axis.
function CPhase = kCFullPhase(theta, controls, target, nbits)
U = R_z(theta);
CPhase = kCU(U, controls, target, nbits);
end
