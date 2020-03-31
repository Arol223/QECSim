% Operation matrix for controlled H-gate with controls as control qubits
% and target as target.
function kCH = kCHad(controls, target, nbits)
kCH = (1/sqrt(2))*(kCNOT(controls, target, nbits) + kCZ(controls,target,nbits));
end