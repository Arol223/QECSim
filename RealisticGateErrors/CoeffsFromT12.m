function [p_XY, p_Z] = CoeffsFromT12(t_dur, T1, T2)
%COEFFSFROMT12 Follows https://journals.aps.org/pra/abstract/10.1103/PhysRevA.86.062318#fulltext

p_XY = (1 - exp(-t_dur/T1))/4;
p_Z = (1 - exp(-t_dur/T2))/2 - p_XY;
end

