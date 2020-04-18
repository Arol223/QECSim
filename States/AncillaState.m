classdef AncillaState < NbitState
    
    methods
        function obj = AncillaState()
            obj@NbitState()
        end
        
        function val = measure_bit(obj, bit)
            if (bit < 1 || bit > obj.nbits)
                error('Specify a bit between 1 and nbits')
            end
            p_0 = measure_prob(obj.rho, bit, 0, obj.nbits);    % Probability to measure the bit in 0
            d_roll = rand(1,1);
            if d_roll <= p_0 % Makes
                val = 0;
                proj = [1;0];
                proj = proj*proj';
            else
                val = 1;
                proj = [0;1];
                proj = proj*proj';
            end
            s1 = bit - 1;
            s2 = obj.nbits - bit;
            if s1 == 0
                proj = kron(proj,speye(2^s2));
            elseif s2 == 0
                proj = kron(speye(2^s1),proj);
            else
                proj = tensor_product({eye(2^s1),proj,eye(2^s2)});
            end
            spy(obj.rho)
            obj.rho = proj*obj.rho*proj';
            obj.rho = obj.rho/trace(obj.rho);
            spy(obj.rho)
            
            
        end
        
        
        function paired_CNOT(obj, dir, nbits)  
            % Applies a transversal CNOT between neighbouring pairs either bottom->top or top->bottom
            op = speye(2^obj.nbits);
            for i = 1:nbits - 1
                op = op*kCNOT(i, i+1, obj.nbits);
            end
            if strcmp(dir,'top')
               obj.operation(op);
            elseif strcmp(dir, 'bot')
                obj.operation(op');
            end
        end
        
        function prep_cat_state(obj, nbits)
            % Follows circuit from: https://arxiv.org/pdf/0905.2794.pdf?source=post_page---------------------------
            % Fig 16 p.29. 
            % Works 100% for Steane code, need to verify it works for more ancillas...
            m = 1;                          
            H_2 = H_i(2, nbits+1); % Hadamard acting on bit 2            
            controls = [2,2,3:nbits, nbits+1];
            targets = [1,3,4:nbits+1, 1];
            gates = zeros(2^(nbits+1),2^(nbits+1),length(controls));
            for i = 1:length(controls)
               gates(:,:,i) = kCNOT(controls(i),targets(i),nbits+1); 
            end
            while m ~= 0
                obj.init_all_zeros(nbits+1)
                obj.operation(H_2);
                for i = 1:length(gates(1,1,:))
                   obj.operation(gates(:,:,i)); 
                end
                m = obj.measure_bit(1);
                spy(obj.rho);
            end
            obj.trace_out_bits(1)
            spy(obj.rho);
        end
        
        
        
    end
    
end