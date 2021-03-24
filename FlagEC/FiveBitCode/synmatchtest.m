syndromes  = zeros(7,4,4);
k=1;
for i = 1:4
    for j = 1:7
        syndromes(j,:,i) = SyndromeMatch(i,j);
    end
    
end
