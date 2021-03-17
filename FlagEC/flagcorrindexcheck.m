cell_ind = 1;
for i = 1:8 % First syndrome measurement
    
  
    
    for j = 0:4 % Flag location
        
       
        
        if j == 0 % No flag raised in 1st syndrome measurement
            
            for k = 1:8 % Second syndrome measurement
                
              
                
                for l = 1:3  % Flag happening in every stabiliser measurement
                    
                 
                    for n = 1:8  % measure the syndrome with non flag circuit
                        
                        
                        cell_ind = cell_ind + 1;
                    end
                    
                end
            end
            
        else % Flag at some point in first measurement
            
            for k = 1:8
               
                cell_ind = cell_ind + 1;
            end
            
            
        end
    end
end