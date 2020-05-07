function rho = idle_bits(rho, targets, t_dur, T1, T2)
% Applies phase and amplitude damping to bits in targets with damping
% coefficients depending on the idling time t_dur, T1 and T2 as c_phase =
% exp(-t_dur/2T2) and c_amp = exp(-t_dur/2T1)

c_amp = exp(-t_dur/(2*T1));
c_phase = exp(-t_dur/(2*T2));

amp = AmplitudeDamping(c_amp);
phase = PhaseDamping(c_phase);
rho = amp.apply(rho, targets);
rho = phase.apply(rho, targets);
end