function full_path = astar(startPos, endPos)
    m = load("logical_occupancy_map.mat");
    map_o = occupancyMap(m.map_logical_values, 2);
    inflate(map_o, 0.5);
    map = occupancyMatrix(map_o, 'ternary');
    
    end_node = node;
    end_node.position = endPos * 2;
    end_node.g = 0;
    end_node.h = 0;
    end_node.f = 0;
    
    start_node = node;
    start_node.position = startPos * 2;
    start_node.g = 0;
    start_node.h = (start_node.position(1) - end_node.position(1))^2 + (start_node.position(2) - end_node.position(2))^2;
    start_node.f = start_node.g + start_node.h;
    
    open_list = [];
    closed_list = [];
    
    open_list = [start_node];
    
    while length(open_list) > 0
        current_node = open_list(1);
        current_index = 1;
        
        for i = 1:length(open_list)
            if open_list(i).f < current_node.f
                current_node = open_list(i);
                current_index = i;
            end
        end
        
        open_list(current_index) = [];
        closed_list = [closed_list; current_node];
        
        if isequal(current_node.position, end_node.position)
            path = [];
            current = current_node;
            
            while ~isequal(current.position, start_node.position)
                path = [path; current.position/2];
                current = current.parent;
            end
            full_path = flip(path);
            return;
        end
        
        positions = [[0, -1]; [0, 1]; [-1, 0]; [1, 0]; [-1, -1]; [-1, 1]; [1, -1]; [1, 1]];
        
        for i = 1:length(positions)
            new_pos = positions(i, :);
            node_position = [(current_node.position(1) + new_pos(1)) (current_node.position(2) + new_pos(2))];
            
            if node_position(2) > size(map, 1) || node_position(2) <= 0 || node_position(1) > size(map, 2) || node_position(1) <= 0
                continue;
            end
            
            if map(41 - node_position(2), node_position(1)) ~= 0
                continue;
            end
            
            new_node = node;
            new_node.parent = current_node;
            new_node.position = node_position;
            
            in_closed = false;
            for k = 1:length(closed_list)
                if isequal(new_node.position, closed_list(k).position)
                    in_closed = true;
                end
            end
            
            if in_closed
                continue;
            end
            
            new_node.g = current_node.g + 1;
            new_node.h = sqrt((new_node.position(1) - end_node.position(1))^2 + (new_node.position(2) - end_node.position(2))^2);
            new_node.f = new_node.g + new_node.h;
            
            in_open = false;
            for l = 1:length(open_list)
                open_node = open_list(l);
                if isequal(new_node.position, open_node.position) && new_node.f >= open_node.f
                    in_open = true;
                end
            end
            
            if in_open
                continue;
            end
            
            open_list = [open_list; new_node];
        end
    end
end