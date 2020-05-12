% Defines general class for damping channels. Takes a damping coefficient.
% Form of these can be found in Nielsen and Chuang chapter 8.
% Needs a separate class from other operations since the operation doesn't
% have individual weights for the elements but rather a damping coefficient
% that appears only in specific matrix elements. 

classdef DampingChannel < handle
    
    properties
        DampingCoeff % For amplitude damping this would be gamma.
    end
    
    properties(Abstract)
       operation_elements % Form depends on specific dampng behaviour.
    end
    
    methods
        
        function obj = DampingChannel(DampingCoeff)
            obj.DampingCoeff = DampingCoeff;
        end
        
        function set.DampingCoeff(obj, DampingCoeff)
            obj.DampingCoeff = DampingCoeff;
        end
        
        function val = get.DampingCoeff(obj)
            val = obj.DampingCoeff;
        end
        
        function res = apply(obj, nstate, targets)
            % Used to apply error to state, which can be defined either by
            % a density matrix or an instance of NbitState. Returns a
            % density matrix.
            res = obj.apply_single(nstate,targets(1));
            for i=2:length(targets)
                res = obj.apply_single(nstate,targets(i));
            end
        end
        
        function op = nbit_op_element(obj, element_number, target, tot_bits)
            % Used to construct an operation element for a multi qubit
            % density matrix. targets is a vector containing indices of
            % bits to be affected by error. 
            element = obj.operation_elements(:,:,element_number);
            pre_op = zeros(2,2,tot_bits);
            for i = 1:tot_bits
                if ismember(i,target)
                    pre_op(:,:,i) = element;
                else
                    pre_op(:,:,i) = eye(2);
                end
            end
            op = tensor_product(pre_op);
            
        end
        
        function res = apply_single(obj, nstate, target)
            if ~(isa(nstate,'NbitState')|| ismatrix(nstate))
                error('nstate must be an NbitState, a subclass thereof or a matrix')
            end
            return_state = 0;
            if isa(nstate,'NbitState')
                res = nstate.rho;
                tot_bits = nstate.nbits;
                return_state = 1;
            else
                res = nstate;
                tot_bits = log2(size(nstate,1));
            end
            op = obj.nbit_op_element(1,target,tot_bits);
            res = op*res*op';
            for i =2:size(obj.operation_elements,3)
               op = obj.nbit_op_element(i, target, tot_bits);
               res = res + op*res*op';
            end
            if return_state
                res = NbitState(res);
            end
        end
        
    end
end


