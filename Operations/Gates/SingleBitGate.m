classdef SingleBitGate < handle
    %SINGLEBITGATE Base class for single qubit gates.
    properties
        error_probs % 1x4 vector containing probs for I, X, Y and Z errors in that order.
        operation_time
    end
    
    properties (Dependent)
        p_success
    end
    
    properties (Abstract)
        op_mat; %The operation matrix for the gate, specified in subclass
    end
    
    
    methods
        
        function obj = SingleBitGate(error_probs)
            if nargin == 1
                obj.error_probs = error_probs;
            end
        end
        
        function res = get.p_success(obj)
            res = 1 - sum(obj.error_probs); % Probability for gate to not fail
        end
        
        function rand_error(obj, p_success)
            % Sets the probs of obj.error_probs at random to get success rate p_success
            p = rand(1,4);
            p = p./sum(p);
            p = p.*(1-p_success);
            obj.error_probs = p;
        end
        
        function res = get_err(obj, i, target, nbits)
            switch i
                case 1
                    op = sparse([0 1;1 0]); %Pauli X
                case 2
                    op = sparse([0 -1i; 1i 0]); % Pauli Y
                case 3
                    op = sparse([1 0;0 -1]); % Pauli Z
            end
            right = nbits - target;
            left = target -1;
            right = speye(2^right);
            left = speye(2^left);
            res = kron(left,op);
            res = kron(res,right);
        end
        
        function op = get_op_el(obj, nbits, target)
            right = nbits - target;
            left = target - 1;
            right = speye(2^right);
            left = speye(2^left);
            op = obj.op_mat;
            op = kron(left,op);
            op = kron(op,right);
        end
        
        function rho = apply_single(obj, nbitstate, target)
            % Applies the gate with errors to target bit. Gate applied
            % first, then each type of error
            return_state = 0;
            if isa(nbitstate,'NbitState')
                nbits = nbitstate.nbits;
                nbitstate = nbitstate.rho;
                return_state = 1;
            else
                nbits = log2(size(nbitstate,1));
            end
            op = obj.get_op_el(nbits, target);
            
            rho = (op*nbitstate)*(obj.p_success*op'); %Succesful op
            if obj.error_probs(1)
                rho = rho + obj.error_probs(1).*nbitstate;  %Identity error
            end
            for i  = 1:3
                if obj.error_probs(i+1)
                    op = obj.get_err(i,target,nbits); %Pauli Errors
                    % This statement and the similar one above are to avoid
                    % multiplying and adding all zero matrices.
                    rho = rho + (obj.error_probs(i+1)*op)*(rho*op');
                end
            end
            
            
            if return_state
                rho = NbitState(rho);
            end
        end
        
        function rho = apply(obj, nbitstate, targets, ~)
            % Applies the gate sequentially to bits in targets, including
            % errors.
            return_state = 0;
            if isa(nbitstate, 'NbitState')
                nbitstate = nbitstate.rho;
                return_state = 1;
            end
            rho = obj.apply_single(nbitstate, targets(1));
            for i = 2:length(targets)
                rho = obj.apply_single(rho, targets(i));
            end
            if return_state
                rho = NbitState(rho);
            end
            
        end
        
        
    end
end