classdef TwoBitGate < handle
    %TWOBITGATE Base class for controlled gates including errors
    %   Detailed explanation goes here
    
    properties
        error_probs; %4x4 matrix containing error_probs for target and control bits. Index corresponds to pauli sigma matrix.
        operation_time
        tol % Tolerance of gate. Returned state will not have elements < tol
        idle_state %0,1 or 2, determines whether to idle bits and how to do it, see SingleBitGate
        T1 % Material/ system param
        T2 % Material/system param.
    end
    
    properties (Dependent)
        p_success
    end
    
    methods (Abstract)
        get_op_el(obj, nbits, target, control)
    end
    methods
        function obj = TwoBitGate(tol, operation_time,T1,T2,idle_state)
            %TWOBITGATE Construct an instance of this class
            %   Detailed explanation goes here
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
            obj.err_from_T()
        end
        
        function p = get.p_success(obj)
            p = 1 - sum(obj.error_probs(:));
        end
        
        function uni_err(obj,p_err)
           % Set a uniform error rate with total prob p_err
           p = ones(4,4);
           p(1,1) = 1; % no identity comp. 
           p = p./sum(p(:));
           p = p.*p_err;
           obj.error_probs = p;
        end
        
        function random_err(obj, p_err)
            % Sets random error probabilities that sum to p_err
            p = rand(4,4);
            p(1,1) = 0;
            p = p./sum(p(:));
            p = p.*(p_err);
            obj.error_probs = p;
        end
        
        function err_from_T(obj)
            p_bitflip =  1 - exp(-obj.operation_time./obj.T1);
            p_phaseflip = 1 - exp(-obj.operation_time./obj.T2);
            p_e_single = p_bitflip+p_phaseflip+p_bitflip*p_phaseflip; %error rate for SQBG
            p_succ = 1-p_e_single;
            p_succ = p_succ^4; % Two bit gate consists of 4 single bit operations so this should be accurate for the error rate
            p_err = 1-p_succ;
            if p_err > 1
                p_err = 1;
                warning('For current values of T1, T2, and t_dur the probability for error is 100%')
            end
            obj.uni_err(p_err); % Equal probability for all errrors
        end
        
        function res = get_err(obj, i, j, targets, nbits)
            if targets(2)<targets(1)
                targets = [targets(2) targets(1)];
            end
            switch i
                case 1
                    op1 = speye(2);
                case 2
                    op1 = sparse([0 1;1 0]); %Pauli X
                case 3
                    op1 = sparse([0 -1i; 1i 0]); % Pauli Y
                case 4
                    op1 = sparse([1 0;0 -1]); % Pauli Z
            end
            switch j
                case 1
                    op2 = speye(2);
                case 2
                    op2 = sparse([0 1;1 0]); %Pauli X
                case 3
                    op2 = sparse([0 -1i; 1i 0]); % Pauli Y
                case 4
                    op2 = sparse([1 0;0 -1]); % Pauli Z
            end
            left = targets(1) - 1; % #bits 'left' of first bit.
            mid = targets(2) - targets(1) - 1; % #bits 'between' target/control
            right = nbits - targets(2); % #bits 'right' of second bit
            left = speye(2^left);
            mid = speye(2^mid);
            right = speye(2^right);
            res = kron(left,op1);
            res = kron(res,mid);
            res = kron(res,op2);
            res = kron(res,right);
        end
        
        function res = apply_single(obj, nbitstate,target, control)
            return_state = 0;
            if isa(nbitstate,'NbitState')
                nbits = nbitstate.nbits;
                nbitstate = nbitstate.rho;
                return_state = 1;
            elseif size(nbitstate,1) == 1
                % Handles the case when rho is a bra
                nbits = log2(length(nbitstate));
                op = obj.get_op_el(nbits,target,control);
                res = nbitstate*op';
                return
            elseif size(nbitstate,2) == 1
                % Handles case when rho is a ket 
                nbits = log2(length(nbitstate));
                op = obj.get_op_el(nbits,target,control);
                res = op*nbitstate;
                return
            else
                nbits = log2(size(nbitstate,1));
            end
            op = obj.get_op_el(nbits, target, control);
            
            rho =  (op*nbitstate)*op'; %Succesful op
            res = rho*obj.p_success;
            
            for i = 1:4
                for j = 1:4
                    p = obj.error_probs(i,j);
                    if p
                        op = obj.get_err(i,j,[target control],nbits);
                        res = res + (p*op)*(rho*op');
                    end
                end
            end
            
            if (obj.idle_state == 1 && obj.operation_time)
                % Idles all bits even for sequential operations.
                idles = [1:target-1, target+1:nbits];
                res = idle_bits(res, idles, obj.operation_time, obj.T1,obj.T2);
            end
            
            if return_state
                res = NbitState(res);
            end
        end
        function rho = apply(obj, nbitstate, targets,controls)
            % Applies the gate to a density matrix, nbitstate or state
            % vector. The state vector is always returned without errors.
            return_state = 0;
            if isa(nbitstate, 'NbitState')
                nbits = nbitstate.nbits;
                nbitstate = nbitstate.rho;
                return_state = 1;
            elseif size(nbitstate,1) == 1 || size(nbitstate,2) == 1 % State vector
               %Handles the case when nbitstate is a state vector 
                rho = obj.apply_single(nbitstate,targets(1),controls(1));
                for i = 2:length(targets)
                    rho = obj.apply_single(rho,targets(i),controls(i));
                end
                return
            else
                nbits = log2(size(nbitstate,1));
            end
            rho = obj.apply_single(nbitstate, targets(1), controls(1));
            for i = 2:length(targets)
                rho = obj.apply_single(rho, targets(i), controls(i));
            end
            
            if (obj.idle_state == 2 && obj.operation_time)
                idles = remove_dupes(unique([targets, controls]), 1:nbits);
                if ~isempty(idles)
                    rho = idle_bits(rho, idles, obj.operation_time, obj.T1, obj.T2);
                end
            end
            
            % Three following lines removes elements smaller than tol.
            if obj.tol
                rho = rho.*(abs(rho)>obj.tol);
                tr = trace(rho);
                if tr
                    rho = rho./tr;
                end
            end
            if nnz(rho) > (size(rho,1)^2)/2
                rho = full(rho);
            end
            if return_state
                rho = NbitState(rho);
            end
        end
        
    end
end


