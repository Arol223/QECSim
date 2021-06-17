function [rho_out, p_out] = MeasureStabiliser(rho_in, type, num, val, cnot, had)
%MEASURESTABILISER Summary of this function goes here
%   Detailed explanation goes here
if type == 'X'
    stab = Surface17.Xstabilisers(num,:);
    order = [2 1 4 3];
elseif type == 'Z'
    stab = Surface17.Zstabilisers(num,:);
    order = [2 4 1 3];
end

bits  = find(stab);
if length(bits)<4
   order = [1 2]; % No specific gate order when measuring weight 2 stabiliser 
end
e_init = rho_in.e_init;
t_init = rho_in.t_init;
e_ro = rho_in.e_ro;
sym = rho_in.sym_ro;
t_ro = rho_in.t_ro;

ancilla = NbitState();
ancilla.init_all_zeros(1, e_init);  % Initialise ancilla bit

if t_init && rho_in.T_2_hf
    % Idle error on data bits
    gamma_a = DampCoeff(t_init, rho_in.T_2_hf);
    rho_out = idle_bits(rho_in,1:rho_in.nbits,0,gamma_a);   
else
    rho_out = NbitState(rho_in.rho);
    rho_out.copy_params(rho_in);
end
rho_out.extend_state(ancilla,'start') % Add ancilla 'above' data qubits in circuit

if type == 'X'
    rho_out = had.apply(rho_out,1);
    for i = 1:length(bits)
        target = bits(order(i)) + 1; % +1 because ancilla was added 
        rho_out = cnot.apply(rho_out, target,1);
    end
    rho_out = had.apply(rho_out,1);
elseif type == 'Z'
   for i = 1:length(bits) 
       ctrl = bits(order(i)) + 1; % see 'X' case
       rho_out = cnot.apply(rho_out, 1, ctrl);
   end
end
[rho_out, p_out] = measurement_e(rho_out,1,val,e_ro,1,sym);
if 
rho_out.trace_out_bits(1);

end

