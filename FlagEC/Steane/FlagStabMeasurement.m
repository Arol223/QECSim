function [rho_out, p_out] = FlagStabMeasurement(rho_in, block,cnot, had,...
                                    stab_n, stab_type, flagged, stab_val, flag_val)
%FlagStabeMeasurement Simulate a Steane Stabiliser measurement using flag
%circuit
%   Simulate a measurement of a single Steane stabiliser measurement using
%   the flag circuit introduced in [Chao 2018]. 
%   ----Inputs----
%   rho_in - The input qubit state (NbitState object)
%   block  - The code block to perform the measurement on (in case there is
%            more than one logical qubit)
%   cnot, had - Gate objects needed for the stabiliser measurement
%   stab_n  - Which stabiliser to measure (Specified in class
%             SteaneColorCode)
%   stab_type - The type of stabiliser, either 'Z' or 'X'
%   flagged - Whether to use a flagged or unflagged circuit, for details
%             see e.g. [Chamberland 2018]
%   stab_val - The measurement outcome for stabiliser state; 0 <-> |0>,
%              1 <-> |1>
%   flag_val - The flag measurement outcome, 0 for unflagged and 1 for
%              flagged

%   -----Outputs-----
%   rho_out - The output state
%   p_out - The probability of getting rho_out as the output state after
%           the measurement

t_init = rho_in.t_init; % Qubit init time
e_init = rho_in.e_init; % Qubit init error
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
dta_ctrls = SteaneColorCode.stabilisers(stab_n,:); % Data qubit targets, order is important
dta_ctrls = dta_ctrls + 7*(block-1); % Get the right controls if not error correcting first block
dta_target = 1;

if flagged 
    % Flagged measurement circuit, full description can be found in
    % [Chamberland2018]
    dta_ctrls = dta_ctrls + 2; % +2 because 2 ancillas are added;
    if stab_type == 'Z'
        rho_out = cnot.apply(rho_out,dta_target,dta_ctrls(1));
        rho_out = cnot.apply(rho_out,1,2);
        rho_out = cnot.apply(rho_out,dta_target, dta_ctrls(2));
        rho_out = cnot.apply(rho_out, dta_target, dta_ctrls(3));
        rho_out = cnot.apply(rho_out,1,2);
        rho_out = cnot.apply(rho_out, dta_target, dta_ctrls(4));
    elseif stab_type == 'X'
        rho_out = XNot(cnot,had,rho_out,dta_ctrls(1),dta_target);
        rho_out = cnot.apply(rho_out,1,2);
        rho_out = XNot(cnot,had,rho_out,dta_ctrls(2),dta_target);
        rho_out = XNot(cnot,had,rho_out,dta_ctrls(3),dta_target);
        rho_out = cnot.apply(rho_out,1,2);
        rho_out = XNot(cnot,had,rho_out,dta_ctrls(4),dta_target);
    end
    [rho_out,p1] = measurement_e(rho_out, 1, stab_val,e_ro, 1, sym); % measuring stabiliser value
    rho_out = had.apply(rho_out, 2);    % Applying hadamard gate for X-basis measurement
    [rho_out,p2] = measurement_e(rho_out, 2, flag_val, e_ro, 1, sym); % measuring the flag
    p_out = p1*p2; % probability of measuring flag and stabiliser ev combo
    rho_out.trace_out_bits(1:2);
else
    dta_ctrls = dta_ctrls + 1; % +1 because 1 ancilla is added
    if stab_type == 'Z'
        rho_out = cnot.apply(rho_out, dta_target, dta_ctrls(1));
        rho_out = cnot.apply(rho_out, dta_target, dta_ctrls(2));
        rho_out = cnot.apply(rho_out, dta_target, dta_ctrls(3));
        rho_out = cnot.apply(rho_out, dta_target, dta_ctrls(4));
    elseif stab_type == 'X'
        rho_out = XNot(cnot,had,rho_out,dta_ctrls(1),dta_target);
        rho_out = XNot(cnot,had,rho_out,dta_ctrls(2),dta_target);
        rho_out = XNot(cnot,had,rho_out,dta_ctrls(3),dta_target);
        rho_out = XNot(cnot,had,rho_out,dta_ctrls(4),dta_target);
    end
    [rho_out, p_out] = measurement_e(rho_out,1,stab_val,e_ro,1,sym);
    rho_out.trace_out_bits(1);
end

end

