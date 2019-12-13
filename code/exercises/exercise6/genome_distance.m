function distance = genome_distance(genome1,genome2)
    distance=0;
    for i=1:size(genome1,2)
        if genome1(1,i) ~=genome2(1,i)
            distance = distance+1;
        end
    end
end