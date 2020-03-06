% Defines a bitflip error, i.e Pauli X. For more details see QuantumErrorChannel
classdef BitflipError < QuantumErrorChannel
    
    properties(Dependent)
        operation_elements
    end
    
    methods
       
        function obj = BitflipError(probability)
           obj@QuantumErrorChannel(probability)
        end
       
        function val = get.operation_elements(obj)
           val = sqrt(obj.probability)*[0 1;1 0]; 
        end
        
    end
    
end