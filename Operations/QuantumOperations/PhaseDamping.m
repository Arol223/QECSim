%Describes PhaseDamping
classdef PhaseDamping < DampingChannel
    
    properties(Dependent)
        operation_elements
    end
    
    methods
        
        function obj = PhaseDamping(DampingCoeff)
            obj@DampingChannel(DampingCoeff)
        end
        
        function el = nbit_op_element(obj, element_number, target, tot_bits)
            el = obj.DampEl('P',element_number, target, tot_bits, obj.DampingCoeff);
        end
        
        function val = get.operation_elements(obj)
            lambda = obj.DampingCoeff;
            val(:,:,1) = [1 0; 0 sqrt(1-lambda)];
            val(:,:,2) = [0 0; 0 sqrt(lambda)];
        end
    end
    
end