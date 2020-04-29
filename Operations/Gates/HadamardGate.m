classdef HadamardGate < QuantumGate
    %HADAMARDGATE Hadamard gate with errors
    %   Detailed explanation goes here
    
    properties
        controlled = false;
        operation_time;
        target_errors;
        control_errors = 0;
        p_eij; % probability for errors
        p_no_op;
    end
    
    properties (Dependent)
       xerr
       yerr
       zerr
    end
    
    methods
        
        function obj = HadamardGate(p_eij, p_no_op, operation_time)
            obj@QuantumGate(p_eij, p_no_op, operation_time)
        end
        
        function res = get.xerr(obj)
            res = BitflipError(obj.p_eij(1));
        end
        
        function res = get.yerr(obj)
            res = PauliYError(obj.p_eij(2));
        end
        
        function res = get.zerr(obj)
            res = PhaseflipError(obj.p_eij(3));
        end
        
        function err = get_error(obj, i)
            switch i
                case 1
                    err = obj.xerr;
                case 2 
                    err = obj.yerr;
                case 3 
                    err = obj.zerr;
            end
        end
        
        function rho = pure_operation(obj, nbitstate, targets)
            if isa(nbitstate,'NbitState')
                nbits = nbitstate.nbits;
                rho = nbitstate.rho;
            elseif ismatrix(nbitstate)
                nbits = log2(size(nbitstate,1));
                rho = nbitstate;
            end
            had = kHad(targets,nbits);
            rho = obj.p_succ*had*rho*had';
        end
        
        function rho = apply_errors(obj, nbitstate, targets)
            [m,n] = size(nbistate);
            rho = spalloc(m,n,m*n/2);
            for i = 1:3
                err = obj.get_error(i);
                rho = rho + err.apply_channel(nbitstate,targets,0);
            end
            if isa(nbitstate, 'NbitState')
                rho = rho + obj.p_no_op*nbitstate.rho;
            elseif ismatrix(nbitstate)
                rho = rho + obj.p_no_op*nbitstate;
            end
        end
                
    end
    
end

