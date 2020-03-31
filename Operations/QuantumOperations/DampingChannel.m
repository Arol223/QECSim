% Defines general class for damping channels. Takes a damping coefficient.
% Form of these can be found in Nielsen and Chuang chapter 8.

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
        
        function State = apply_channel(obj, nstate, targets)
            % Used to apply error to state, which can be defined either by
            % a density matrix or an instance of NbitState. Returns a
            % density matrix.
            if ~(isa(nstate,'NbitState')|| ismatrix(nstate))
                error('nstate must be an NbitState, a subclass thereof or a matrix')
            end
            if isa(nstate,'NbitState')
                State = nstate.rho;
                tot_bits = nstate.nbits;
            else
                State = nstate;
                tot_bits = log2(size(nstate,1));
            end
            
            op = obj.nbit_op_element(1, targets, tot_bits);
            State = op*State*op';
            for i = 2:size(obj.operation_elements,3)
                op = obj.nbit_op_element(i, targets, tot_bits);
                State = State + op*State*op';
            end
            
        end
        
        function op = nbit_op_element(obj, element_number, targets, tot_bits)
            % Used to construct an operation element for a multi qubit
            % density matrix. targets is a vector containing indices of
            % bits to be affected by error. 
            element = obj.operation_elements(:,:,element_number);
            pre_op = zeros(2,2,tot_bits);
            for i = 1:tot_bits
                if ismember(i,targets)
                    pre_op(:,:,i) = element;
                else
                    pre_op(:,:,i) = speye(2);
                end
            end
            op = tensor_product(pre_op);
        end
        
    end
end


