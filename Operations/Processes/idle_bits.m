function rho = idle_bits(rho, targets, c_bit, c_phase)
% Applies phase and amplitude damping to bits in targets with damping
% coefficients depending on the idling time t_dur, T1 and T2 as c_phase =
% exp(-t_dur/2T2) and c_amp = exp(-t_dur/2T1)


if c_bit
    amp = AmplitudeDamping(c_bit);
    rho = amp.apply(rho, targets);
end
if c_phase
    phase = PhaseDamping(c_phase);
    rho = phase.apply(rho, targets);
end

end