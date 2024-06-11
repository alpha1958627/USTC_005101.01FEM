function F = getstress(input_vertex,U,node_coordinates,element_nodes,E,mu)
    % 找到输入顶点的索引
    input_index = find(ismember(node_coordinates, input_vertex, 'rows'));
    
    if isempty(input_index)
        error('输入的顶点坐标在点数组中未找到');
    end
    
    % 初始化存储结果的数组
    triangles_with_vertex = [];
    triangle_coords = [];
    F = [0;0;0];
    numoftriangle=0;
    % 查找包含该顶点的所有三角形
    for i = 1:size(element_nodes, 1)
        if any(element_nodes(i, :) == input_index)
            triangles_with_vertex = [triangles_with_vertex; element_nodes(i, :)];
            triangle_coords = [triangle_coords; node_coordinates(element_nodes(i, :), :)];
          r1=triangles_with_vertex(1);
          r2=triangles_with_vertex(2);
          r3=triangles_with_vertex(3);
          U1=U([2*r1-1,2*r1]);
          U2=U([2*r2-1,2*r2]);
          U3=U([2*r3-1,2*r3]);

            x1 = triangle_coords(1, 1); y1 = triangle_coords(1, 2);
            x2 = triangle_coords(2, 1); y2 = triangle_coords(2, 2);
            x3 = triangle_coords(3, 1); y3 = triangle_coords(3, 2);
            b1 = y2-y3;
            b2 = y3-y1;
            b3 = y1-y2;
            c1 = x3-x2;
            c2 = x1-x3;
            c3 = x2-x1;
            A = 0.5 * abs(x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2));
            B = [b1,0,b2,0,b3,0;
                0,c1,0,c2,0,c3;
                c1,b1,c2,b2,c3,b3]/(2*A);
            yingbian = B * [U1;U2;U3];
            D =E/(1+mu)/(1-2*mu)*[1-mu mu 0;mu 1-mu 0;0 0 (1-2*mu)/2]; %平面应变
            yingli = D*yingbian;
            disp(yingbian)
            disp(yingli)
            F=F+yingli;
            numoftriangle=numoftriangle+1;
            triangles_with_vertex = [];
            triangle_coords = [];
        end
    end
    F=F/numoftriangle;
end