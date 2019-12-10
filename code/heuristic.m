%{
heuristic.m

Low level function for calculating an offspring given 2 parents (genomes).

Input parameters:
    ParentA - Genome of the first parent (path representation)
    ParentB - Genome of the second parent (path representation)
    Dist    - Distance matrix
%}

function Offspring=heuristic(ParentA, ParentB, Dist)
    Offspring = zeros(size(ParentA));  % Vector
    cities = size(ParentA, 2);
    
    % Start off the algorithm with choosing a random city
    Offspring(1) = rand_int(1,1,cities) + 1;
    used = zeros(size(ParentA));
    used(1) = Offspring(1);
    
    % Iterate
    walking_index = 1;
    while walking_index < cities
        % Get indices of matching cities' proceeding city
        a = find(ParentA == Offspring(walking_index)) + 1;
        b = find(ParentB == Offspring(walking_index)) + 1;
        if (a > cities); a = 1; end
        if (b > cities); b = 1; end
        
        if ismember(ParentA(a), used) && ismember(ParentB(b), used)
            % Get minimal distance of remaining cities
            best_dist = Inf;
            best_city = 0;
            for i=1:cities
                if ~ismember(i, used)
                    dist = Dist(Offspring(walking_index), i);
                    if dist < best_dist
                        best_dist = dist;
                        best_city = i;
                    end
                end
            end
            Offspring(walking_index + 1) = best_city;
            used(walking_index + 1) = best_city;
        elseif ismember(ParentA(a), used)
            Offspring(walking_index + 1) = ParentB(b);
            used(walking_index + 1) = ParentB(b);
        elseif ismember(ParentB(b), used)
            Offspring(walking_index + 1) = ParentA(a);
            used(walking_index + 1) = ParentA(a);
        else
            % Get distances
            dist_a = Dist(Offspring(walking_index), ParentA(a));
            dist_b = Dist(Offspring(walking_index), ParentB(b));

            % Choose minimum for next city
            if dist_a < dist_b
                Offspring(walking_index + 1) = ParentA(a);
                used(walking_index + 1) = ParentA(a);
            else
                Offspring(walking_index + 1) = ParentB(b);
                used(walking_index + 1) = ParentB(b);
            end
        end
        walking_index = walking_index + 1;
    end
