classdef SingleBitGate < handle
    %SINGLEBITGATE Base class for single qubit gates.
    properties
        error_probs % 1x4 vector containing probs for I, X, Y and Z errors in that order.
        operation_time
        tol % Tolerance of the gate. Returned state will not have elements<tol.
        T1 % Material/system parameter
        T2 % Material/system parameter
        idle_state % If 1, amplitude and phase damping are applied to all bits
        % that aren't operated on even when doing a sequential
        % operation on multiple bits. If 2, only bits that
        % aren't operated on at all are idled.
    end
    
    properties (Dependent)
        p_success
    end
    
    properties (Abstract)
        op_mat; %The operation matrix for the gate, specified in subclass
    end
    
    
    methods
        
        function obj = SingleBitGate(tol,operation_time,T1,T2,idle_state)
            if nargin < 5
                obj.idle_state = 0;
            else
                obj.idle_state = idle_state;
            end
            if nargin < 4
                obj.T2 = Inf;
            else
                obj.T2 = T2;
            end
            if nargin < 3
                obj.T1 = Inf;
            else
                obj.T1 = T1;
            end
            
            obj.operation_time = operation_time;
            obj.tol = tol;
            obj.err_from_T();
        end
        
        function res = get.p_success(obj)
            res = 1 - sum(obj.error_probs); % Probability for gate to not fail
        end
        
        function uni_err(obj,p_err)
            % Set a uniform error rate with total prob p_err
           p = ones(1,4);
           p(1) = 0; % No identity comp
           p = p./sum(p(:));
           p = p.*p_err;
           obj.error_probs = p;
        end
        function rand_error(obj, p_err)
            % Sets the probs of obj.error_probs at random to get success rate p_success
            p = rand(1,4);
            p(1) = 0; % no identity error
            p = p./sum(p);
            p = p.*p_err;
            obj.error_probs = p;
        end
        
        function err_from_T(obj)
            p_biflip = 1 - exp(-obj.operation_time./obj.T1);
            p_phaseflip = 1 - exp(-obj.operation_time./obj.T2);
            obj.error_probs = zeros(1,4);
            obj.error_probs(2) = p_biflip;
            obj.error_probs(4) = p_phaseflip;
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
            % first, then each type of error. If nbitstate is a vector gate
            % is applied without errors.
            return_state = 0;
            if isa(nbitstate,'NbitState')
                nbits = nbitstate.nbits;
                nbitstate = nbitstate.rho;
                return_state = 1;
            elseif size(nbitstate,1) == 1
                %Handles case when nbitstate is a bra
                nbits = log2(length(nbitstate));
                op = obj.get_op_el(nbits,target);
                rho = nbitstate*op';
                return
            elseif size(nbitstate,2) == 1
                % handles case when nbitstate is a bra
                nbits = log2(length(nbitstate));
                op = obj.get_op_el(nbits,target);
                rho = op*nbitstate;
                return
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
            
            if (obj.idle_state == 1 && obj.operation_time)
                % Idles all bits even for sequential operations.
                idles = [1:target-1, target+1:nbits];
                rho = idle_bits(rho, idles, obj.operation_time, obj.T1,obj.T2);
            end
            
            if return_state
                rho = NbitState(rho);
            end
        end
        
        function rho = apply(obj, nbitstate, targets, ~)
            % Applies the gate sequentially to bits in targets, including
            % errors. If nbitstate is a vector, it applies the gate without
            % errors.
            return_state = 0;
            if isa(nbitstate, 'NbitState')
                nbits = nbitstate.nbits;
                nbitstate = nbitstate.rho;
                return_state = 1;
            elseif size(nbitstate,1) == 1 || size(nbitstate,2) == 1
                rho = obj.apply_single(nbitstate,targets(1));
                for i = 2:length(targets)
                    rho = obj.apply(rho,targets(i));
                end
                return
            else
                nbits = log2(size(nbitstate,1));
            end
            rho = obj.apply_single(nbitstate, targets(1));
            for i = 2:length(targets)
                rho = obj.apply_single(rho, targets(i));
            end
            
            if (obj.idle_state == 2 && obj.operation_time)
                idles = remove_dupes(targets, 1:nbits);
                if ~isempty(idles)
                    rho = idle_bits(rho, idles, obj.operation_time, obj.T1, obj.T2);
                end
            end
            % Following 2 lines remove elements <tol
            if obj.tol
                rho=rho.*(abs(rho)>obj.tol);
                tr = trace(rho);
                
                if tr
                    rho = rho./tr;
                end
            end
            if return_state
                rho = NbitState(rho);
            end
            
        end
        
        
    end
end