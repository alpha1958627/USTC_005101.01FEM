# USTC_005101.01FEM
This program was developed for the USTC 005101.01 course to help students solve plane elasticity mechanics problems using MATLAB and finite element methods. 
# Introduction
This program was developed for the USTC 005101.01 course to help students solve various plane elasticity mechanics problems using MATLAB and finite element methods. The program includes plane stress, plane strain.

# Features
- Supports plane stress, plane strain problems
- Utilizes MATLAB and finite element analysis for accurate solutions
- Calculates and displays stress, strain fields

# Getting Started
- Clone the repository to your local machine:
```
git clone https://github.com/your-username/ustc005-plane-elasticity-mechanics-matlab.git
```
- Open the project in MATLAB

- Get `mesh.txt` and `boundary.txt` in COMSOL Multiphysics

- Set parameters 
```
%Pa
E = 200000000000;
%Possion
mu = 0.3;
%thickness
t = 1;
```
- Boundary conditions
```
start = [0,3]; last = [0,5.196];

minpath = get_path_on_boundary(start,last,boundary_coordinates,boundary_nodes);

boundary_normal_constraint = get_index_from_other_coor(minpath',boundary_coordinates,node_coordinates);

clear minpath
```
- Applying Boundary Loads
  
  for example:
```
F(boundary_force *2) = 0.4*k*node_coordinates([boundary_force],1);
```

`boundary_force` array stores the indices, i, of the points where loads have been applied. For each index i:

   `F(2i-1)` corresponds to the x-degree of freedom (the force applied in the x-direction);
  `F(2i)` corresponds to the y-degree of freedom (the force applied in the y-direction)
  
Run the main script:
```
run main.m
```
Select the problem type you want to solve in.
## Problem Types Supported
1. Plane stress problems
2. Plane strain problems

# Contributing
We welcome contributions to this project. If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request. Your contributions can help enhance the program and benefit other students.

# License
This project is licensed under the MIT License.