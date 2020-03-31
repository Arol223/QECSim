classdef PauliYError < QuantumErrorChannel
    
    properties(Dependent)
        operation_elements
    end
    
    methods
        function obj = PauliYError(probability)
           obj@QuantumErrorChannel(probability) 
        end
        
        function val = get.operation_elements(obj)
            val = sqrt(obj.probability)*[0 -1i; 1i 0];
        end
    end
    
end