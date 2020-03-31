% Traces out A in the system AxB where A is s_1xs_1 and B is s_2xs_2.
function rho_n = bipartite_partial_trace(rho, s_1, s_2)
    rho_n = rho(1:s_2,1:s_2);
    for i=2:s_1-1
        rho_n = rho_n + rho(i*s_2+1,(i+1)*s_2);
    end
end