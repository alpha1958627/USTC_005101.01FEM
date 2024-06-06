clear
% 打开文件
% 初始化变量
[node_coordinates,element_nodes] = readComsolField('2mesh.txt');
[boundary_coordinates,boundary_nodes]= readComsolBoundary('2b.txt');

number_nodes = size(node_coordinates,1);
number_elements = size(element_nodes,1);

number_boundary_ele = size(boundary_nodes,1);

boundary_ele_nodes(:,1) = get_index_from_other_coor(boundary_nodes(:,1),boundary_coordinates,node_coordinates);
boundary_ele_nodes(:,2) = get_index_from_other_coor(boundary_nodes(:,2),boundary_coordinates,node_coordinates);

number_dofs = 2*number_nodes;

F = zeros(number_dofs,1);
U = zeros(number_dofs,1);
K_ele = zeros(6,6,number_elements);
K = zeros(number_dofs);

%Pa
E = 200000000000;
%Possion
mu = 0.3;
%thickness
t = 1;









% for i = 1:number_boundary_ele
%    p1 = node_coordinates(boundary_ele_nodes(i,1),:);
%    p2 = node_coordinates(boundary_ele_nodes(i,2),:);
% %    n1 = boundary_ele_nodes(i,1);
% %    n2 = boundary_ele_nodes(i,2);
% %    
% %    txt1 = string(n1);
% %    txt2 = string(n2);
%    
%    plot([p1(1),p2(1)],[p1(2),p2(2)],'k-');
%    hold on;
% end

start = [0,3]; last = [0,5.196];
[path1,path2] = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);

path1_global = get_index_from_other_coor(path1',boundary_coordinates,node_coordinates);

path2_global = get_index_from_other_coor(path2',boundary_coordinates,node_coordinates);

% disp(path1_global)
boundary_normal_constraint = path1_global;%对称边界条件


clear path1 path2 path1_global path2_global

start = [3,0]; last = [6,0];
[path1,path2] = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);

path1_global = get_index_from_other_coor(path1',boundary_coordinates,node_coordinates);

path2_global = get_index_from_other_coor(path2',boundary_coordinates,node_coordinates);

boundary_fixed = path2_global;%固定边界条件

clear path1 path2 path1_global path2_global
start = [3,0]; last = [0,3];
[path1,path2] = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);

path1_global = get_index_from_other_coor(path1',boundary_coordinates,node_coordinates);

path2_global = get_index_from_other_coor(path2',boundary_coordinates,node_coordinates);

boundary_free_1 = path1_global;

clear path1 path2 path1_global path2_global
start = [3.2,5.196]; last = [6,0];
[path1,path2] = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);

path1_global = get_index_from_other_coor(path1',boundary_coordinates,node_coordinates);

path2_global = get_index_from_other_coor(path2',boundary_coordinates,node_coordinates);

boundary_free_2 = path2_global;

clear path1 path2 path1_global path2_global
start = [0,5.196]; last = [3.2,5.196];
[path1,path2] = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);
% disp(path1)
% plot(boundary_coordinates(path1,1),boundary_coordinates(path1,2))

path1_global = get_index_from_other_coor(path1',boundary_coordinates,node_coordinates);

path2_global = get_index_from_other_coor(path2',boundary_coordinates,node_coordinates);

boundary_force = path1_global;%应力

% disp(boundary_force)


%删掉重复的点
k = size(boundary_free_1,2);

boundary_free_1([1,k]) = [];

k = size(boundary_free_2,2);
boundary_free_2([1,k]) = [];
clear k;

for i =1:number_elements
    r1 = node_coordinates(element_nodes(i,1),:);
    r2 = node_coordinates(element_nodes(i,2),:);
    r3 = node_coordinates(element_nodes(i,3),:);
    n1 = element_nodes(i,1);
    n2 = element_nodes(i,2);
    n3 = element_nodes(i,3);
    
    %装配
    K_ele(:,:,i) =  LinearTriangleElementStiffness(E,mu,t,r1,r2,r3,2);
    ele_dof = [2*n1-1,2*n1,2*n2-1,2*n2,2*n3-1,2*n3];
    K(ele_dof,ele_dof) = K(ele_dof,ele_dof) + K_ele(:,:,i);
end
    clear r1 r2 r3 n1 n2 n3 ele_dof i


    
    % % nx = -1.196/(1.196*1.196+3.2*3.2)^0.5;
    % % ny = 3.2/(1.196*1.196+3.2*3.2)^0.5;
    % %  = [ny,-nx;nx,ny];
    
    % for i = 1:size(boundary_normal_constraint,2)
    %     Trans_dof(2*i-1) = boundary_normal_constraint(i)*2-1;
    %     Trans_dof(2*i) = boundary_normal_constraint(i)*2;
    % end
    % clear i
    
    % % NOT_TRANS_dof = setdiff(1:number_dofs,Trans_dof);
    
    % Trans = zeros(number_dofs);
    % Trans(NOT_TRANS_dof,NOT_TRANS_dof) = diag(ones(number_dofs-size(boundary_normal_constraint,2)*2,1));
    
    % tmp = repmat({},size(boundary_normal_constraint,2),1);
    % Trans(Trans_dof,Trans_dof) = blkdiag(tmp{:});
    
    % % K_ = Trans*K*Trans';
    % clear tmp
    
    
    %%设置边界条件
    %force
    
    
    
    
    total_dofs = [1:number_dofs]';

    force_act_dofs = [boundary_fixed'*2-1;boundary_fixed'*2;boundary_normal_constraint'*2-1];
    
    force_pre_dofs = setdiff(total_dofs,force_act_dofs);
    %已经确定力

    %displacement
    tmp = boundary_normal_constraint'*2-1;
    tmp =[tmp;boundary_fixed'*2-1;boundary_fixed'*2];
    % boundary_fixed
    disp_pre_dofs = tmp;
  %约定好的唯一自由度
    disp_act_dofs = setdiff(total_dofs,disp_pre_dofs);
    
    k=-5000/3.2;
    node_coordinates([boundary_force],1)
    F(boundary_force *2) = 0.4*k*node_coordinates([boundary_force],1);
    F(boundary_force([1,size(boundary_force,2)])  *2) = [0.2*0.2*k*0.5,3.0*0.2*k*0.5];   
    % F(boundary_force *2)
    % sum(F(boundary_force *2))
    
    
    U(disp_act_dofs) = K(disp_act_dofs,disp_act_dofs)\(F(force_pre_dofs)-K(disp_act_dofs,disp_pre_dofs)*U(disp_pre_dofs));
    % U(disp_act_dofs) = K(disp_act_dofs,disp_act_dofs)\F(force_pre_dofs)
    F = K * U;
    i=3;
    disp('0,5.196')
    U([2*i-1,2*i])
    i=180;
    disp('6,0')
    U([2*i-1,2*i])
    i=61;
    disp('3.2,5.196')
    U([2*i-1,2*i])

    

    
    
    



