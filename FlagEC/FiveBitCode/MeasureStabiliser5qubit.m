function [rho_out, p_out] = MeasureStabiliser5qubit(rho_in, block, ... 
    cnot, had, stab_n, stab_val, flagged, flag_val)
%MEASURESTABILISER Summary of this function goes here
%   Detailed explanation goes here
t_init = rho_in.t_init; % Qubit init time
e_init = rho_in.e_init; % Qubit init error
p_out = 1; 
e_ro = rho_in.t_ro; % Readout error
sym = rho_in.sym_ro;
[ancilla, t_ancilla] = FlagAncillaPrep(flagged,had,e_init,t_init);

if t_ancilla && rho_in.T_2_hf
    % Idle error on data bits
    gamma_a = DampCoeff(t_ancilla, rho_in.T_2_hf);
    rho_out = idle_bits(rho_in,1:rho_in.nbits,0,gamma_a);   
else
    rho_out = NbitState(rho_in.rho);
    rho_out.copy_params(rho_in);
end
rho_out.extend_state(ancilla,'start') % Add ancilla 'above' data qubits in circuit

[order, controls] = GateOrder(stab_n);
controls = controls + 5*(block - 1);

if flagged
    controls = controls + 2;
else
    controls = controls + 1;
end


for i = 1:length(order)
    o = order(i);
    c = controls(i);
    switch o
        case 'X'
            rho_out = XNot(cnot,had,rho_out,c,1);
        case 'Z'
            rho_out = cnot.apply(rho_out,1,c);
        case 'A'
            rho_out = cnot.apply(rho_out, 1, 2); % Couple flag with measurement ancilla
    end
end

if flagged
    rho_out = had.apply(rho_out,2);
   [rho_out,p_out] = measurement_e(rho_out,2,flag_val,e_ro,1,sym);
   if flag_val
       rho_out.trace_out_bits(1:2);
       return
   end
   [rho_out,p_tmp] = measurement_e(rho_out,1,stab_val,e_ro,1,sym);
   p_out = p_out*p_tmp;
   rho_out.trace_out_bits(1:2);
   return
end    

[rho_out, p_out] = measurement_e(rho_out,1,stab_val,e_ro,1,sym);
rho_out.trace_out_bits(1);

end

