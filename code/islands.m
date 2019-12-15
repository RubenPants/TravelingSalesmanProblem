%{
islands.m

%}

function Chrom = islands(Chrom, SUBPOP, SUBPOP_SIZE, best, current_gen, STAGNATE, REPR)
    if REPR == 1
        Chrom = adj2path(Chrom);
    end
    
    counter = zeros(1,SUBPOP);
    for s=1:SUBPOP
        counter(s) = sum(best(s,:) == best(s, current_gen+1));
    end
    indices = find(counter >= STAGNATE);

    % At least two stagnated populations, merge two at random
    if length(indices) >= 2 && mod(current_gen+1, STAGNATE) == 0
        % Define segment that will be replaced (20% of population)
        SWITCH_AMOUNT = round(SUBPOP_SIZE/5);
        r = randi(SUBPOP_SIZE-SWITCH_AMOUNT);
        
        % Give subsample to next population
        first_popu = Chrom(SUBPOP_SIZE * (indices(1)-1) + 1 : SUBPOP_SIZE * indices(1), :);
        first_piece = first_popu(r:r+SWITCH_AMOUNT-1,:);
        for i=1:length(indices) - 1
            % Load in populations
            popu_a = Chrom(SUBPOP_SIZE * (indices(i)-1) + 1 : SUBPOP_SIZE * indices(i), :);
            popu_b = Chrom(SUBPOP_SIZE * (indices(i+1)-1) + 1 : SUBPOP_SIZE * indices(i+1), :);
            
            % Put segment from b into a
            popu_a(r:r+SWITCH_AMOUNT-1,:) = popu_b(r:r+SWITCH_AMOUNT-1,:);
            
            % Update popu_a in Chrom
            Chrom(SUBPOP_SIZE * (indices(i)-1) + 1 : SUBPOP_SIZE * indices(i), :) = popu_a;
        end
        % Update last population with first_piece
        last_popu = Chrom(SUBPOP_SIZE * (indices(length(indices))-1) + 1 : SUBPOP_SIZE * indices(length(indices)), :);
        last_popu(r:r+SWITCH_AMOUNT-1,:) = first_piece;
        Chrom(SUBPOP_SIZE * (indices(length(indices))-1) + 1 : SUBPOP_SIZE * indices(length(indices)), :) = last_popu;
    end
    
    if REPR == 1
        Chrom = path2adj(Chrom);
    end
end