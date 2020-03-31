classdef DepolarisingChannel < QuantumErrorChannel
   
    properties(Dependent)
        operation_elements
    end
    
    methods
        
        function obj = DepolarisingChannel(probability)
            obj@QuantumErrorChannel(3*probability/4)
        end
        
        function set_p(obj,val)
            % Setter and getter methods in matlab can't be overloaded the
            % same way as in other languages. Use this instead of
            % obj.probability = x to get the right results. 
            obj.probability = 3*val/4;
        end
        
        function val = get.operation_elements(obj)
            p = obj.probability/3;
            val(:,:,1) = sqrt(p)*[0 1; 1 0];
            val(:,:,2) = sqrt(p)*[0 -1i; 1i 0];
            val(:,:,3) = sqrt(p)*[1 0; 0 -1];
        end
        
    end
    
end