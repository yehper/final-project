classdef utils
     methods (Static)
       %% get voronoi cells
       function cells=get_voronoi(poses,lBound,hBound)
           cells = voronoiPolyhedrons(poses,lBound,hBound);
           cells = cells';
            % fix vertices order
            for i=1:numel(cells)
                % calc Convex hull of current cell
                k = convhull(cells{i}(:,1), cells{i}(:,2));
                cells{i} = [cells{i}(k,1); cells{i}(k,2)];
            end
       end
        %% get voronoi cells and vertecies
        function [v,c]=get_voronoi_old(x,y)
            % get cells in order without bounds
            [~,c] = voronoin([x y]);
            % get cells not order with bounds
            [vl,cl] = VoronoiLimit(x,y);
            v = vl;
            % run on all cells
            for i=1:numel(c)
                curr_cell = c{i};
                n = numel(curr_cell);
                % check if unbounded cell
                if(find(curr_cell == 1))
                    % check if first ver is 1
                    if(curr_cell(1) == 1)
                        % shift one time
                        curr_cell = circshift(curr_cell,1);
                    end
                    one_idx = find(curr_cell == 1);
                    sh_cell = fliplr(circshift(curr_cell,numel(curr_cell)-1));
                    one_idx_sh = find(sh_cell == 1);
                    % filter according to cell length
                    fl_cells = cl(cellfun(@(x)numel(x)==n+1 && any(x(:) == curr_cell(1)),cl));
                    % check each cell
                    for j=1:numel(fl_cells)
                        % shift the cell
                        shift = numel(fl_cells{j}) - find(fl_cells{j} == curr_cell(1))+1; 
                        cell = circshift(fl_cells{j},shift);
                        % check if the same cell
                        if((isequal(cell(1:one_idx-1),curr_cell(1:one_idx-1)) && isequal(cell(one_idx+2:end),curr_cell(one_idx+1:end))) ||...
                           (isequal(cell(1:one_idx_sh-1),sh_cell(1:one_idx_sh-1)) && isequal(cell(one_idx_sh+2:end),sh_cell(one_idx_sh+1:end))))
                            c{i} = cell;
                            break;
                        end
                    end
                end
            end
        end
        %% find voronoi neighbors
        function neighbors=get_neighbors(NumOfRob,NumOfAgents,poses,cells)
            neighbors = sparse(NumOfRob, NumOfRob);
            % run on each cell
            for i=1:NumOfRob
                for j=+1:NumOfRob
                    if(~((i > NumOfAgents && j > NumOfAgents)||(i <= NumOfAgents && j <= NumOfAgents)))
                        % calc number of intersections
                        inter = numel(intersect(cells{i},cells{j}));
                        % check if neighbors
                        if(inter > 1)
                            % set neighbors
                            neighbors(i,j) = 1;
                            neighbors(j,i) = 1;
                        end
                    end
                end
            end
            % leave only closest agent to attacker
            for i=NumOfAgents +1:NumOfRob
                curr_neighbors = find(neighbors(i,:));
                min_dist = Inf;
                min_idx = curr_neighbors(1);
                for j=1:numel(curr_neighbors)
                    curr_dist =  norm(poses(:,i)-poses(:,curr_neighbors(j)));
                    if(curr_dist < min_dist)
                        if(min_dist < Inf)
                            neighbors(i,min_idx) = 0;
                        end
                        min_dist = curr_dist;
                        min_idx = curr_neighbors(j);
                    end
                end
            end
        end
        %% calc_angular_speed_by_point
        function w=calc_angular_speed_by_point(pos,point)
                    y = point(2)-pos(2);
                    x = point(1)-pos(1);
                    theta = atan2(y,x);
                    theta = mod(theta - mod(pos(3),2*pi),2*pi);
                    if theta > pi
                        theta = -(2*pi -theta);
                    end
                    w = interp1([-pi,pi],[-1,1],theta);
        end
     end
end