% A container class used to specify noise operations. Add operation
% elements without probabilities as this enables tuning. Elements are
% specified in ndarray. Basic class handles single qubit errors, but can be
% applied to several qubits simultaneously. 
classdef QuantumErrorChannel < handle
    properties
        probability
    end
    
    properties(Abstract)
        operation_elements
    end
    
    methods
        function obj = QuantumErrorChannel(probability)
            obj.probability = probability;
        end
        
        function op = nbit_noise_element(obj, element_number, targets, tot_bits)
            % Creates a matrix for one of the operation elements acting on
            % bits targets. Example: 3-bit system, operation element is
            % pauli X, and we want to apply it to bits 2 & 3. The matrix
            % becomes I_1X_2X_3. 
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
        
        function rho = apply_error(obj, nstate, targets)
            % Applies the error on a state. Example: bitflip error with
            % probability p, 1 bit. rho_new = (1-p)*rho + p*X*rho*X'.
            if ~(isa(nstate, 'NbitState') || ismatrix(nstate))
                error('Please specify an NbitState or matrix to be affected by noise')
            end
            p = obj.probability;
            if isa(nstate, 'NbitState')
                rho_i = nstate.rho;
                rho = (1-p)*nstate.rho;
                tot_bits = nstate.nbits;
            else
                rho_i = nstate;
                rho = (1-p)*nstate;
                tot_bits = log2(size(nstate,1));
            end
            for i = 1:size(obj.operation_elements,3)
                op = obj.nbit_noise_element(i, targets, tot_bits);
                rho = rho + op*rho_i*op';
            end
        end
    end
end