% Compute path using the A* algorithm
function full_path = astar(start, finish)
    m = load("logical_occupancy_map.mat");
    map_o = occupancyMap(m.map_logical_values, 2);
    % inflate map so that generated points are not close to walls
    inflate(map_o, 0.5);
    map = occupancyMatrix(map_o, 'ternary');
    
    % double positions as map is double the size of inputs   
    end_node = node(finish * 2, [], 0, 0);
    start_node = node(start * 2, [], 0, pdist([start * 2; end_node.position], 'euclidean'));
    
    open_list = [start_node];
    closed_list = [];
    
    while ~isempty(open_list)
        current_node = open_list(1);
        current_index = 1;
        
        for i = 1:length(open_list)
            if open_list(i) < current_node
                current_node = open_list(i);
                current_index = i;
            end
        end
        
        open_list(current_index) = [];
        closed_list = [closed_list; current_node];
        
        if current_node == end_node
            path = [];
            current = current_node;
            
            while current ~= start_node
                % divide by 2 as coverting back to original scale
                path = [path; current.position/2];
                current = current.parent;
            end
            full_path = flip(path);
            return;
        end
        
        % all position around a cell (down, up, left, right, bottom left,
        % bottom right, top left, top right)
        sorrounding_cells = [[0, -1]; [0, 1]; [-1, 0]; [1, 0];
                            [-1, -1]; [-1, 1]; [1, -1]; [1, 1]];
        
        for i = 1:length(sorrounding_cells)
            node_position = current_node.position + sorrounding_cells(i, :);
            
            % node is outside the map
            horizontal = node_position(2) > size(map, 1) || node_position(2) <= 0;
            vertical = node_position(1) > size(map, 2) || node_position(1) <= 0;
            
            if horizontal || vertical
                continue;
            end
            
            % node is on a wall
            if map(41 - node_position(2), node_position(1)) ~= 0
                continue;
            end
            
            % compute distance to end node
            distance = pdist([node_position; end_node.position], 'euclidean');
            new_node = node(node_position, current_node, current_node.g + 1, distance);
            
            % check if node is in the closed list
            in_closed = false;
            for k = 1:length(closed_list)
                if new_node == closed_list(k)
                    in_closed = true;
                    break;
                end
            end
            
            if in_closed
                continue;
            end
            
            % check if node is in the open list and is more expensive
            in_open = false;
            for l = 1:length(open_list)
                open_node = open_list(l);
                if new_node == open_node && new_node >= open_node
                    in_open = true;
                    break;
                end
            end
            
            if in_open
                continue;
            end
            
            open_list = [open_list; new_node];
        end
    end
end