% Defines a phaseflip error, i.e. Pauli Z. For details, see QuantumNoiseChannel

classdef PhaseflipError < QuantumErrorChannel
   
    properties(Dependent)
        operation_elements
    end
    
    methods
        
        function obj = PhaseflipError(probability)
           obj@QuantumErrorChannel(probability)
        end
        
        function val = get.operation_elements(obj)
            val = sqrt(obj.probability)*[1 0;0 -1];
        end
    end
    
    
end