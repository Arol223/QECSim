function [p_bit,p_phase] = TQBGrate(p_err)
%TQBGRATE Calculate error rate for two qubit gate following scheme from
%High Fidelity Readout article (4 single qubit gates);
%   Input parameter is the total error rate for a SQBG.

p = [p_err,p_err^2,p_err]; % Errors for SQBG assuming same prob for bit/phaseflip
p = p./sum(p); %Normalise
p = p.*p_err;   %Set correct rate. 


end

