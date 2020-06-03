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
        inc_err = 1; %Flag, 1 means errors are included by default. Will use idling if false, but noit gate errors
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
        
        function set_err(obj,p_bit,p_phase)
            obj.error_probs = [0,p_bit,p_bit*p_phase,p_phase];
        end
        function uni_err(obj,p_err)
            % Set the errors so that the total error rate is p_err
           p = [0, p_err,p_err^2,p_err];
           p = p./sum(p);
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
            p_bitflip = 1 - exp(-obj.operation_time./obj.T1);
            p_phaseflip = 1 - exp(-obj.operation_time./obj.T2);
            obj.error_probs = zeros(1,4);
            obj.error_probs(2) = p_bitflip; %X-error
            obj.error_probs(3) = p_bitflip*p_phaseflip;%Y-error
            obj.error_probs(4) = p_phaseflip;%Z-error
        end
        
        function res = get_err(obj, i, target, nbits)
            switch i
                case 1
                    op = sparse([0 1;1 0]); %Pauli X
                case 2
                    op = sparse([0 1; -1 0]); % Pauli Y*i
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
        
        function res = apply_single(obj, nbitstate, target)
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
                res = nbitstate*op';
                return
            elseif size(nbitstate,2) == 1
                % handles case when nbitstate is a ket
                nbits = log2(length(nbitstate));
                op = obj.get_op_el(nbits,target);
                res = op*nbitstate;
                return
            else
                nbits = log2(size(nbitstate,1));
            end
            op = obj.get_op_el(nbits, target);
            
            rho = (op*nbitstate)*op'; %Succesful op
            res = rho;
            if obj.inc_err
                res = res*obj.p_success;
                for i  = 1:3
                    if obj.error_probs(i+1)
                        op = obj.get_err(i,target,nbits); %Pauli Errors
                        % This statement and the similar one above are to avoid
                        % multiplying and adding all zero matrices.
                        res = res + (obj.error_probs(i+1)*op)*(rho*op');
                    end
                end
            end
            
            if (obj.idle_state == 1)
                % Idles all bits even for sequential operations.
                c_bit = obj.error_probs(2); %Coeff for bitflip, used for amp damping
                c_phase = obj.error_probs(4); %Coeff for phaseflip, used for phase damping
                idles = [1:target-1, target+1:nbits];
                res = idle_bits(res, idles,c_bit, c_phase);
            end
            
            if return_state
                res = NbitState(res);
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
            
            if (obj.idle_state == 2)
                idles = remove_dupes(targets, 1:nbits);
                if ~isempty(idles)
                    c_bit = obj.error_probs(2);
                    c_phase = obj.error_probs(4);
                    rho = idle_bits(rho, idles, c_bit,c_phase);
                end
            end
            % Following 2 lines remove elements <tol
%             if obj.tol
%                 rho=rho.*(abs(rho)>obj.tol);
%                 tr = trace(rho);
%                 
%                 if tr
%                     rho = rho./tr;
%                 end
%             end
            if return_state
                rho = NbitState(rho);
            end
            
        end
        
        
    end
end