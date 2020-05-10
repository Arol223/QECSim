classdef TwoBitGate < handle
    %TWOBITGATE Base class for controlled gates including errors
    %   Detailed explanation goes here
    
    properties
        error_probs; %2x4 vector containing error_probs for target bit and
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
        function obj = TwoBitGate(error_probs, tol, operation_time,T1,T2,idle_state)
            %TWOBITGATE Construct an instance of this class
            %   Detailed explanation goes here
            if nargin < 6
                obj.idle_state = 0;
            else
                obj.idle_state = idle_state;
            end
            if nargin < 5
                obj.T2 = 0;
            else
               obj.T2 = T2; 
            end
            if nargin < 4
                obj.T1 = 0;
            else
                obj.T1 = T1;
            end
            obj.error_probs = error_probs;
            obj.operation_time = operation_time;
            obj.tol = tol;
        end
        
        function p = get.p_success(obj)
            p = 1 - sum(obj.error_probs(:));
        end
        
        function random_err(obj, p_succ)
            p = rand(2,4);
            p = p./sum(p(:));
            p = p.*(1-p_succ);
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
        
        function rho = apply_single(obj, nbitstate,target, control)
            return_state = 0;
            if isa(nbitstate,'NbitState')
                nbits = nbitstate.nbits;
                nbitstate = nbitstate.rho;
                return_state = 1;
            else
                nbits = log2(size(nbitstate,1));
            end
            op = obj.get_op_el(nbits, target, control);
            
            rho1 =  (op*nbitstate)*(obj.p_success*op'); %Succesful op
            rho = rho1;
            if obj.error_probs(1,1)
                rho = rho + obj.error_probs(1,1).*nbitstate;  %Identity error
            end
            if obj.error_probs(2,1)
                rho = rho + obj.error_probs(2,1).*nbitstate; %Identity err.
            end
            for i = 1:2
                for j = 1:3
                    if obj.error_probs(i,j+1)
                        % This statement and the similar one above are to avoid
                        % multiplying and adding all zero matrices.
                        op = obj.get_err(j,target,nbits); %Pauli Errors
                        rho = rho + (obj.error_probs(i,j+1)*op)*(rho1*op');
                    end
                end
                target = control;
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
        function rho = apply(obj, nbitstate, targets,controls)
            return_state = 0;
            if isa(nbitstate, 'NbitState')
                nbitstate = nbitstate.rho;
                return_state = 1;
            end
            rho = obj.apply_single(nbitstate, targets(1), controls(1));
            for i = 2:length(targets)
                rho = obj.apply_single(rho, targets(i), controls(i));
            end
            
            if (obj.idle_state == 2 && obj.operation_time)
                idles = remove_dupes(unique([targets, controls]), 1:nbits);
                rho = idle_bits(rho, idles, obj.operation_time, obj.T1, obj.T2);
            end
            
            % Three following lines removes elements smaller than tol.
            rho = rho.*(abs(rho)>obj.tol);
            rho = rho./trace(rho);
            if nnz(rho) > (size(rho,1)^2)/2
                rho = full(rho);
            end
            if return_state
                rho = NbitState(rho);
            end
        end
        
    end
end


