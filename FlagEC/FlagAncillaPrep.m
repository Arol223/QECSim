function [rho_out,t_tot] = FlagAncillaPrep(flag, had, e_init, t_init)
%UNTITLED2 Prepare the ancilla used for flagged stabiliser measurements
%   ----Inputs----
%   flag - whether to include the flag qubit (1 or 0)
%   had - Hadamard gate needed for flag qubit
%   e_init - Initialisation error
%   t_init - time to initialise a qubit

%   -----Outputs----
%   rho_out - The output ancilla state
%   t_tot - The total time needed for ancilla preparation

    nbits = 1 + flag;
    t_tot = nbits*t_init;
    rho_out = NbitState();
    rho_out.init_all_zeros(nbits, e_init)

    if flag
        rho_out = had.apply(rho_out, 2);
        t_tot = t_tot + had.operation_time;
    end
end

