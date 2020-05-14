function [T2_range,fid] = MeasureGateFid(test_state,gate,T2_range,t_bit)
%MEASUREGATEFID Get a fidelity vector that can be plotted as a function of
%T2

clean = CleanGate(gate); % Clean gate to get reference target state
t_state = clean.apply(rho,t_bit); % The target state
fid = zeros(1,length(T2));
for i = 1:length(T2_range)
    res = gate.apply(test_state);
    fid(i) = Fidelity(res,t_state);
end
end
