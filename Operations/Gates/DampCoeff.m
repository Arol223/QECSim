function c_damp = DampCoeff(t_dur,T_12)
%DAMPCOEFF Calculate a damping coefficient as c_x = 1-exp(-t_dur/T12)

c_damp = 1 - exp(-t_dur/(2*T_12));
end

