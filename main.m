clear
clc
[node_coordinates,element_nodes] = readComsolField('mesh.txt');
[boundary_coordinates,boundary_nodes]= readComsolBoundary('boundary.txt');

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

%--------------------------------------------------------------------------------------------------------
start = [0,3]; last = [0,5.196];

minpath = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);

boundary_normal_constraint = get_index_from_other_coor(minpath',boundary_coordinates,node_coordinates);

clear minpath
%--------------------------------------------------------------------------------------------------------
start = [3,0]; last = [6,0];
minpath = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);

boundary_fixed =  get_index_from_other_coor(minpath',boundary_coordinates,node_coordinates);
clear minpath
%--------------------------------------------------------------------------------------------------------


start = [3,0]; last = [0,3];
minpath = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);

boundary_free_1=  get_index_from_other_coor(minpath',boundary_coordinates,node_coordinates);

clear minpath
%--------------------------------------------------------------------------------------------------------

start = [3.2,5.196]; last = [6,0];
minpath = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);

boundary_free_2 =  get_index_from_other_coor(minpath',boundary_coordinates,node_coordinates);
clear minpath
%--------------------------------------------------------------------------------------------------------

start = [0,5.196]; last = [3.2,5.196];
minpath = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);

boundary_force =  get_index_from_other_coor(minpath',boundary_coordinates,node_coordinates);
clear minpath
%--------------------------------------------------------------------------------------------------------

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

    F(boundary_force*2)=discretize_linear_load(boundary_force,element_nodes,node_coordinates) ;
    
    U(disp_act_dofs) = K(disp_act_dofs,disp_act_dofs)\(F(force_pre_dofs)-K(disp_act_dofs,disp_pre_dofs)*U(disp_pre_dofs));
    F = K * U;
    i=61 ;
    disp('3.2,5.196')
    U([2*i-1,2*i])



 

    
    



