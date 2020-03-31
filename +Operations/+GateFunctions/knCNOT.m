% Transversal CNOT. Every control controls exactly one target.
% There doesn't seem to be a standard way to number qubits, but in this
% suite the top qubit in a circuit diagram is counted as bit 1, regardless
% of whether it is a data qubit or an ancilla. In the state |0xxxx...x> bit
% 1 is 0 and the rest are x.
function C = knCNOT(controls,targets,nbits)
    import Operations.GateFunctions.kCNOT
    C = kCNOT(controls(1),targets(1),nbits);
    for i  = 2:length(controls)
        C = kCNOT(controls(i),targets(i),nbits)*C;
    end
end