function rho = idle_bits(nbitstate, targets, c_bit, c_phase)
% Applies phase and amplitude damping to bits in targets with damping
% coefficients depending on the idling time t_dur, T1 and T2 as c_phase =
% exp(-t_dur/2T2) and c_amp = exp(-t_dur/2T1)


% if c_bit
%     amp = AmplitudeDamping(c_bit); %Uncomment to include amplitude damping
%     rho = amp.apply(rho, targets);
% end
% if c_phase
%     phase = PhaseDamping(c_phase);
%     rho = nbitstate;
%     rho = phase.apply(rho, targets);
% end

if ~c_phase
    rho = nbitstate;
    return
end

a = (1 + sqrt(1 - c_phase)); % writing phase damping as phaseflip channel

return_state = 0;
if isa(nbitstate,'NbitState')
    nb = nbitstate.nbits;
    rtmp = nbitstate.rho;
    return_state = 1;
else
    nb = log2(size(nbitstate,1));
    rtmp = nbitstate;
end

E1 = sparse(sqrt(1 - a)*[1 0; 0 -1]);
for i = 1:length(targets)
    
    left = length(1:targets(i)-1);
    right = length(targets(i)+1:nb);
    op = kron(speye(2^left),E1);
    op = kron(op, speye(2^right));
    
    rtmp = a*rtmp + op*rtmp*op;
end

if return_state
    rho = NbitState(rtmp);
    rho.copy_params(nbitstate);
else
    rho = rtmp;
end
end
