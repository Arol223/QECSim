% Describes AmplitudeDamping
classdef AmplitudeDamping < DampingChannel
   
    properties(Dependent)
       operation_elements 
    end
    
    methods
        
        function obj = AmplitudeDamping(DampingCoeff)
           obj@DampingChannel(DampingCoeff) 
        end
        
        function val = get.operation_elements(obj)
            gamma = obj.DampingCoeff;
            val(:,:,1) = [1 0; 0 sqrt(1-gamma)];
            val(:,:,2) = [0 sqrt(gamma);0 0];
        end
        
    end
    
    
end