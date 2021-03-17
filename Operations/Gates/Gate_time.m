function t_dur = Gate_time(p_err,T_12)
%Gate_time Calculate the needed SQBG-duration to get error rate p_err with
%T_1 or T_2 as specified in T_12
t_dur = -log(1-p_err)*T_12;
end

