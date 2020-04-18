function [ rho, p_rho ] = FT_CSSgen_measurement( nbitstate, block,...
    CSSCode, type, gen_nbr, val, outcome_ind,e_init, e_readout, had_gate,...
    CNot, CZ)
%FT_CSSGEN_MEASUREMENT Fault tolerant measurement of a CSS-code generator.
%   Measures a CSS generator fault-tolerantly, i.e. by majority voting.
%   Majority voting requires two or three measurements and there are
%   therefore 3 different paths to give a result of 0 or 1. The desired
%   outcome is specified in outcome_ind, where the first alternative giving
%   0 is 00x, second 010 and third 100. For val==1 the outcomes are indexed
%   the same way but the values are inverted.
%   ---Inputs----
%   * nbitstate - state to measure on.
%   * block - the block of physical bits to measure on in a system of several
%     logical bits.
%   * CSSCode - instance of class CSSCode or subclass containing
%     information about the encoding
%   * type - the type of generator to use, either 'Z' or 'X'
%   * gen_nbr - the index of the generator to measure (1, 2 or 3 for Steane)
%   * val - the value to measure, either 1 or 2.
%   * outcome_ind - because of majority voting there are 3 ways to measure
%     0 and 1. For val=0 theres 00, 010 and 100.
%   * e_init, e_readout the initialisation and readout errors.
%   * had_gate, cnot, cz - the gates required to perform the measurements. 
if (nargin < 12 && strcmp(type, 'Z'))
    error('Input a CZ-gate for measuring a Z-generator')
elseif nargin < 12
    CZ = 0;
end
switch outcome_ind  % Determines the order in which measurements should happen
    case 1
        vals = [0 0];
    case 2
        vals = [0 1 0];
    case 3 
        vals = [1 0 0];        
end
if val==1
    vals = ~vals; % inverts the values in val to get measurements for val==1.
end

[rho,p_rho] = measure_css_gen(nbitstate,block,CSSCode,type,gen_nbr,vals(1),e_init,...
    e_readout, had_gate,CNot,CZ);
for i = 2:length(vals)
   [r_tmp,p_tmp] =  measure_css_gen(nbitstate,block,CSSCode,type,gen_nbr,vals(i),e_init,...
    e_readout, had_gate,CNot,CZ);
    rho = rho+r_tmp;
    p_rho = p_rho*p_tmp;
end

end

