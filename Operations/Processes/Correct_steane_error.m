function  [rho,p]  = Correct_steane_error( nbitstate,block,Steanecode...
    ,type,e_init,e_readout,had_gate,CNot,CZ )
%CORRECT_STEANE_ERROR Run a bit or phase flip EC cycle using the steane
%code
%   Runs an error correction cycle for either bit or phase flip using the
%   Steane generator structure, i.e. 6 generators where 3 correct for phase
%   flips and 3 correct for bit flips. There are eight different outcomes
%   when trying to error correct, each giving a separate syndrome. This
%   adds all the outcomes and returns the total state after correction. 
if nargin <9
   if strcmp(type, 'X')
       CZ = 0;
   else
       error('Cannot use Z EC without a CZ gate')
   end
end
rho = NbitState.empty(8,0);
p = zeros(8,1);

for i = 1:8
    syndrome = get_syndrome(i);
    [r_tmp, p_tmp] = measure_syndrome(nbitstate,block,Steanecode,type,...
        syndrome,e_init,e_readout,had_gate, CNot,CZ);
    p(i) = p_tmp;
    rho(i) = r_tmp;
end

