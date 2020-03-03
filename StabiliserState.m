% Used to describe a logical qubit of a stabiliser code. Takes as input an
% instance of the class StabiliserCode
classdef StabiliserState < NbitState
    
    properties
        stabiliser_code
    end
    
    methods
        
        %Constructor
        function obj = StabiliserState(stabiliser_code)
            obj@NbitState();
            if isa(stabiliser_code,'StabiliserCode')
                obj.stabiliser_code = stabiliser_code;
            else
                error('Cannot create a StabiliserState without providing a StabiliserCode')
            end
            
        end
        
        function eig = measure_generator(obj, gen_nbr)
            weight = obj.stabiliser_code.stab_weight;
            a = AncillaState();
            a.prep_cat_state(weight)
            a.extend_state(obj,'end');
            CGen = obj.stabiliser_code.cstabiliser(gen_nbr);
            a.operation(CGen);
            a.paired_CNOT('bot', weight);
            a.operation(H_i(1,a.nbits));
            eig = a.measure_bit(1);
            a.trace_out_bits(1:weight)
            obj.rho = a.rho;
        end
        
        
        
        function init_logical_zero(obj)
            % Fault tolerantly initialise in the logical 0 state of the
            % stabiliser code
            obj.init_all_zeros(obj.stabiliser_code.nbits);
            m = zeros(3);
            for i = 1:3 % 3 measurements are needed for steane code, need to generalise this...
                for j = 1:3
                    m(i,j) = obj.measure_generator(i);
                    spy(obj.rho)
                    if j == 2 && m(2) == m(1)
                        break
                    end
                end
            end
            % This part is again specific to the Steane code, will try to
            % find a way to generalise
            M = zeros(3,1);
            for c = 1:3
               if mean(m(i,:)) < 2/3
                  M(i) = 0;
               else
                   M(i) = 1;
               end
            end
            ind = 1^M(2) + 2^M(3) + 4^M(1);
            Z = [1 0;0 -1];
            Z = extend_operator(Z, ind, obj.nbits);
            obj.operation(Z)
        end
        
        
    end
    
end


