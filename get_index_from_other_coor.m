function index = get_index_from_other_coor(local_index,local_node_coordinates,global_node_coordinates)
    for i =1:size(local_index,1)
       index(i) = find(ismember(global_node_coordinates,local_node_coordinates(local_index(i),:),'rows'));
    end
    
end