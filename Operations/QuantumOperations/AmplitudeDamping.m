% Describes AmplitudeDamping
classdef AmplitudeDamping < DampingChannel
   
    properties(Dependent)
       operation_elements 
    end
    
    methods
        
        function obj = AmplitudeDamping(DampingCoeff)
           obj@DampingChannel(DampingCoeff) 
        end
        
        function el = nbit_op_element(obj, element_number, target, tot_bits)
            el = obj.DampEl('A',element_number, target, tot_bits, obj.DampingCoeff);
        end
        
        function val = get.operation_elements(obj)
            % Operation elements as defined in Nielsen and Chuang ch. 8
            gamma = obj.DampingCoeff;
            val(:,:,1) = [1 0; 0 sqrt(1-gamma)];
            val(:,:,2) = [0 sqrt(gamma);0 0];
        end
        
    end
    
    
end