function [order, controls] = GateOrder(stab_n)
%GATEORDER Summary of this function goes here
%   Detailed explanation goes here


controls = [];

order = 'XAZZAX';

switch stab_n
    case 1
        controls = [1 2 3 4];
    case 2
        controls = [2 3 4 5];
    case 3
        controls = [3 4 5 1];
    case 4
        controls = [4 5 1 2];
end
controls = [controls(1) 0 controls(2:3) 0 controls(4)];

end

