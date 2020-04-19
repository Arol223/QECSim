classdef CNOTGate < QuantumGate
    %CNOTGATE A CNOT gate model including uncorrelated errors
    %   Detailed explanation goes here
    
    properties (Dependent)
        XerrT
        YerrT
        ZerrT
        XerrC
        YerrC
        ZerrC
    end
    
    properties
        controlled = true;
        knCNOT = memoize(@knCNOT);
        operation_time;
        p_no_op; % probability that the gate fails completely, i.e.becomes an identity operation.
        p_eij; % probability for ij:th error. First row is target error, second row is control error.
    end
    
    methods
        
        function obj = CNOTGate(p_eij, p_no_op, operation_time)
            obj@QuantumGate(p_eij, p_no_op, operation_time)
            obj.knCNOT.CacheSize = 5000;
        end
        
        function random_errors(obj, p_succ)
           % Sets the error coefficients randomly to get desired total p_succ.
           ep = 1-p_succ; % error probability
           p_eij = rand(2,3);
           p_no_op = rand;
           N = sum(p_eij(:))+p_no_op; %Normalisation constant
           p_eij = ep*p_eij./N;
           p_no_op = ep*p_no_op/N;
           obj.p_eij = p_eij;
           obj.p_no_op = p_no_op;
        end
        
        function res = get.XerrT(obj)
            res = BitflipError(obj.p_eij(1,1));
        end
        function res = get.YerrT(obj)
            res = PauliYError(obj.p_eij(1,2));
        end
        function res = get.ZerrT(obj)
            res = PhaseflipError(obj.p_eij(1,3));
        end
        
        function res = get.XerrC(obj)
            res = BitflipError(obj.p_eij(2,1));
        end
        function res = get.YerrC(obj)
            res = PauliYError(obj.p_eij(2,2));
        end
        function res = get.ZerrC(obj)
            res = PhaseflipError(obj.p_eij(2,3));
        end
        function err = get_error(obj, ind)
                
                if ind == [1 1]
                    err = obj.XerrT;
                elseif ind == [1 2]
                    err = obj.YerrT;
                elseif ind == [1 3]
                    err = obj.ZerrT;
                elseif ind == [2 1]
                   err = obj.XerrC;
                elseif ind == [2 2]
                    err = obj.YerrC;
                elseif ind == [2 3]
                    err = obj.ZerrC;
                end
        end
        
        function rho = pure_operation(obj, nbitstate, controls, targets)
            if isa(nbitstate,'NbitState')
                nbits = nbitstate.nbits;
                rho = nbitstate.rho;
            elseif ismatrix(nbitstate)
                nbits = log2(size(nbitstate,1));
                rho = nbitstate;
            end
            cnot = obj.knCNOT(controls,targets,nbits);
            %spy(cnot)
            rho = obj.p_succ*cnot*rho*cnot';
            %spy(rho)
        end
        
        function rho = apply_errors(obj, nbitstate, targets, controls)
            % Applies errors for cnot gate. This needs to be fixed to
            % accomodate correlated errors on both control and target bits.
            
            if isa(nbitstate, 'NbitState')
                rho = zeros(size(nbitstate.rho));
            elseif ismatrix(nbitstate)
                rho = zeros(size(nbitstate));
            end
            for i = 1:2
                for j = 1:3
                    err = obj.get_error([i j]);
                    if i == 1
                        rho = rho + err.apply_channel(nbitstate,targets,0);
                    else
                        rho = rho + err.apply_channel(nbitstate,controls,0);
                    end       
                end
            end
            
            
            % Adds an identity component
            if isa(nbitstate, 'NbitState')
                rho = rho + obj.p_no_op*nbitstate.rho;
            elseif ismatrix(nbitstate)
                rho = rho + obj.p_no_oprob*nbitstate;
            end
            
        end
        
    end
    
end

