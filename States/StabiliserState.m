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
            % Measures the generator gen_nbr. The generators are specified
            % in a StabiliserCode object in the form 'IIIXXXX', that is
            % required to create an instance of this class. See 
            % https://arxiv.org/pdf/0905.2794.pdf?source=post_page---------------------------
            % Fig.16 p29 for an example circuit diagram specific to the
            % steane code
            
            weight = obj.stabiliser_code.stab_weight; % Weight of the stabiliser, i.e. number of non-identity operations.
            %------------Ancilla preparation---------------------
            a = AncillaState();
            a.prep_cat_state(weight) % Verified, cat state example: |0000> + |1111>
            a.extend_state(obj,'end'); % Tensor product of data block with ancilla block
            %------------Applying the generator operation----------------
            % Middle block in example circuit
            CGen = obj.stabiliser_code.cstabiliser(gen_nbr); % Matrix for controlled form of stabiliser
            a.operation(CGen);
            spy(a.rho)
            
            %-------------Readout---------------------
            % Last block in example circuit
            readout_controls = 3:-1:1; %Specific to Steane Code measurements
            readout_targets = 4:-1:2;
            readout_cnot = knCNOT(readout_controls,readout_targets,a.nbits);
            a.operation(readout_cnot);
            spy(a.rho)
            a.operation(H_i(1,a.nbits));
            spy(a.rho)
            eig = a.measure_bit(1);
            spy(a.rho)
            %-------------Tracing out ancilla--------------
            a.trace_out_system(1, [2^weight, 2^(a.nbits-weight)])
            spy(a.rho)
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
            spy(obj.rho)
        end
        
        
    end
    
end


