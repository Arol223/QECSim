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
        
        function set_err(obj, p_bit,p_phase)
            % Set the error rate for bit and phase flip errors. Probability
            % of Y-error is p_bit*p_phase, and combined errors on both bits
            % use P(s_i x s_j) = P(s_i)*P(s_j)
            p_err = ones(4,4);
            for i = 1:4
                switch i
                    case 1
                        p = 1; % no error
                    case 2
                        p = p_bit;   %bitflip on control
                    case 3
                        p = p_phase*p_bit;   % bit and phaseflip on control
                    case 4
                        p = p_phase; %phase flip on control
                end
                for j = 1:4
                    switch j
                        case 1 
                            p_err(i,j) = p;
                        case 2
                            p_err(i,j) = p*p_bit;
                        case 3
                            p_err(i,j) = p*p_bit*p_phase;
                        case 4
                            p_err(i,j) = p*p_phase;
                    end
                   
                end
            end
            p_err(1,1) = 0;
            obj.error_probs = p_err;
        end
        function single_bit_err(obj,p_bit,p_phase)
           errs = [0 p_bit p_bit*p_phase p_phase];
           obj.error_probs = zeros(4,4);
           obj.error_probs(1,:) = errs; %This way there are no cross terms like XxY etc.
           obj.error_probs(:,1) = errs';
        end
        function uni_err(obj,p_err)
           %Old and not in use
            p_sing = [p_err p_err^2 p_err]; % Error rate for sqbg
            p_sing = p_sing./sum(p_sing);
            p_sing = p_sing.*p_err;
            p_bit = p_sing(1);
            p_phase = p_sing(1);
            obj.set_err(p_bit,p_phase);
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
            p_bit =  1 - exp(-obj.operation_time./obj.T1);
            p_phase = 1 - exp(-obj.operation_time./obj.T2);
            obj.set_err(p_bit,p_phase); % Correct probabilities
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
                    op1 = sparse([0 1; -1 0]); % Pauli Y*i
                case 4
                    op1 = sparse([1 0;0 -1]); % Pauli Z
            end
            switch j
                case 1
                    op2 = speye(2);
                case 2
                    op2 = sparse([0 1;1 0]); %Pauli X
                case 3
                    op2 = sparse([0 1; -1 0]); % Pauli Y*i
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
            
            if (obj.idle_state == 1)
                % Idles all bits even for sequential operations.
                c_bit = obj.error_probs(1,2);
                c_phase = obj.error_probs(1,4);
                idles = [1:target-1, target+1:nbits];
                res = idle_bits(res, idles, c_bit,c_phase);
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
            
            if (obj.idle_state == 2)
                idles = remove_dupes(unique([targets, controls]), 1:nbits);
                if ~isempty(idles)
                    c_bit = obj.error_probs(1,2); %Use bitflip error rate as amplitude damping coeff 
                    c_phase = obj.error_probs(1,4); % Phaseflip as phase damping coeff
                    rho = idle_bits(rho, idles, c_bit,c_phase);
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


