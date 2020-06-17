function full_path = astar(start, finish)
    m = load("logical_occupancy_map.mat");
    map_o = occupancyMap(m.map_logical_values, 2);
    inflate(map_o, 0.5);
    map = occupancyMatrix(map_o, 'ternary');
    
    start_pos = start * 2;
    end_pos = finish * 2;
    
    end_node = node(end_pos, [], 0, 0);
    
    distance = (start_pos(1) - end_pos(1))^2 + (start_pos(2) - end_pos(2))^2;
    start_node = node(start * 2, [], 0, distance);
    
    open_list = [];
    closed_list = [];
    
    open_list = [start_node];
    
    while length(open_list) > 0
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
                path = [path; current.position/2];
                current = current.parent;
            end
            full_path = flip(path);
            return;
        end
        
        positions = [[0, -1]; [0, 1]; [-1, 0]; [1, 0]; [-1, -1]; [-1, 1]; [1, -1]; [1, 1]];
        
        for i = 1:length(positions)
            node_position = current_node.position + positions(i, :);
            
            if node_position(2) > size(map, 1) || node_position(2) <= 0 || node_position(1) > size(map, 2) || node_position(1) <= 0
                continue;
            end
            
            if map(41 - node_position(2), node_position(1)) ~= 0
                continue;
            end
            
            distance = sqrt((node_position(1) - end_node.position(1))^2 + (node_position(2) - end_node.position(2))^2);
            new_node = node(node_position, current_node, current_node.g + 1, distance);
            
            in_closed = false;
            for k = 1:length(closed_list)
                if new_node == closed_list(k)
                    in_closed = true;
                end
            end
            
            if in_closed
                continue;
            end
            
            in_open = false;
            for l = 1:length(open_list)
                open_node = open_list(l);
                if new_node == open_node && new_node >= open_node
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