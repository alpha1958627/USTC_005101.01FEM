function minpath= get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes)
    
    start = find(ismember(boundary_coordinates,start,'rows'));
    last = find(ismember(boundary_coordinates,last,'rows'));
    
    N = size(boundary_coordinates,1);
    
    link = zeros(N);
    for i = 1:N
       link(boundary_nodes(i,1),boundary_nodes(i,2)) = 1;
       link(boundary_nodes(i,2),boundary_nodes(i,1)) = 1;
    end
    
    n = 1; 
    
    
    mid = start; path1(1) = mid;
    while mid ~= last
        k = find(link(mid,:),1);
        link(mid,k) = 0;link(k,mid) = 0;
        mid = k;
        n = n+1;
        path1(n) = k;
        
    end
    
    
     n = 1; 
    mid = start; path2(1) = mid;
    while mid ~= last
        k = find(link(mid,:),1);
        link(mid,k) = 0;link(k,mid) = 0;
        mid = k;
        n = n+1;
        path2(n) = k;
        
    end

    if (length(path1) < length(path2))
  minpath = path1;
    else
  minpath = path2;
    end

end