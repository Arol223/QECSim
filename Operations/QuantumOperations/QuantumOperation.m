classdef QuantumOperation < handle
    % Basic class for doing quantum operations on single bits. Operation
    % elements are matrices which act on one bit at a time.
    properties (Abstract)
        operation_elements
        element_weights
    end
    
    methods
        
        function obj = QuantumOperation()
        
        end
        
        function op = nbit_op_element(obj, tot_bits, element_number,...
                                        targets)                
            % Creates a matrix for one of the operation elements acting on
            % bits targets. Example: 3-bit system, operation element is
            % pauli X, and we want to apply it to bits 2 & 3. The matrix
            % becomes I_1X_2X_3. 
            element = obj.operation_elements(:,:,element_number);
            pre_op = zeros(2,2,tot_bits);
            for i = 1:tot_bits
                if ismember(i,targets)
                    pre_op(:,:,i) = obj.element_weights(i)*element;
                else
                    pre_op(:,:,i) = speye(2);
                end
            end
            op = tensor_product(pre_op);
        end
        
        function rho = apply_operation(obj, nstate, targets)
            % Applies the error on a state. Example: bitflip error with
            % probability p, 1 bit. rho_new = (1-p)*rho + p*X*rho*X'.
            if ~(isa(nstate, 'NbitState') || ismatrix(nstate))
                error('Please specify an NbitState or matrix to be affected by noise')
            end
            if isa(nstate, 'NbitState')
                rho_i = nstate.rho;
                tot_bits = nstate.nbits;
            else
                rho_i = nstate;
                tot_bits = log2(size(nstate,1));
            end
            op = obj.nbit_op_element(1, targets, tot_bits);
            rho = op*rho_i*op';
                
            for i = 2:size(obj.operation_elements,3)
                op = obj.nbit_op_element(i, targets, tot_bits);
                rho = rho + op*rho_i*op';
            end
        end
    end
    
end