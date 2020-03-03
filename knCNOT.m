% Transversal CNOT. Every control controls exactly one target.
function C = knCNOT(controls,targets,nbits)
    C = kCNOT(controls(1),targets(1),nbits);
    for i  = 2:length(controls)
        C = C*kCNOT(controls(i),targets(i),nbits);
    end
end