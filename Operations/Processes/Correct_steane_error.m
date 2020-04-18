function  rho  = Correct_steane_error( nbitstate,block,Steanecode...
    ,type,gen_nbr,e_init,e_readout,had_gate,CNot,CZ )
%CORRECT_STEANE_ERROR Run a bit or phase flip EC cycle using the steane
%code
%   Runs an error correction cycle for either bit or phase flip using the
%   Steane generator structure, i.e. 6 generators where 3 correct for phase
%   flips and 3 correct for bit flips. There are eight different outcomes
%   when trying to error correct, each giving a separate syndrome. This
%   adds all the outcomes and returns the total state after correction. 




end

