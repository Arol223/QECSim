function [order, controls] = GateOrder(stab_n)
%GATEORDER Summary of this function goes here
%   Detailed explanation goes here
stab = FiveQubitCode.stabilisers(stab_n,:);
order = [];
controls = [];
for i = 1:5
    if stab(i) == 'X' || stab(i) == 'Z'
        order = [order stab(i)];
        controls = [controls, i];
    end
end
order = [order(1) 'A' order(2:3) 'A' order(4)];
controls = [controls(1) 0 controls(2:3) 0 controls(4)];

end

