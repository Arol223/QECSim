load BenchmarkAll
%% Runtime with errors
figure()
subplot(1,2,1)
plot(1:X,rteSQBG)
hold on
plot(1:X,rteTQBG)
plot(1:X,rteHad)
plot(1:X,rtenHad)
title('Runtime mean vs number of gates with errors included')
xlabel('Number of gates')
ylabel('Runtime mean [s]')
legend('All SQBG', 'TQBG', 'Hadamard','SQBG no Hadamard')
%% Runtime without errors
subplot(1,2,2)
plot(1:X,rtSQBG)
hold on
plot(1:X,rtTQBG)
plot(1:X,rtHad)
plot(1:X,rtnHad)
title('Runtime mean vs number of gates, no errors')
xlabel('Number of gates')
ylabel('Runtime mean [s]')
legend('All SQBG', 'TQBG','Hadamard', 'SQBG, no Hadamard')