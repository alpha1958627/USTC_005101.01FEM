function f=discretize_linear_load(boundary_force,element_nodes,node_coordinates)
    
% 初始化一个空的结果数组
result = [];

% 遍历BF数组
for i = 1:length(boundary_force)-1
    % 获取当前boundary_force对的两个数字
    num1 = boundary_force(i);
    num2 = boundary_force(i+1);
    
    % 遍历node数组,找到包含这两个数字的行
    for j = 1:size(element_nodes,1)
        row = element_nodes(j,:);
        if (any(row == num1) && any(row == num2))
            % 找到该行的第三个数字
            result = [result, row(row ~= num1 & row ~= num2)];
        end
    end
end

% 输出结果
% node_coordinates
% disp(node_coordinates([result],2))


f=zeros(size(boundary_force));
xk=node_coordinates(boundary_force);
yk=node_coordinates(boundary_force,2)';
xi=xk(1:end-1);
yi=yk(1:end-1);
xk=xk(2:end);
yk=yk(2:end);
xj=node_coordinates([result],1)';
yj=node_coordinates([result],2)';
%Ni
for i = 1:length(boundary_force)-1
% for i = 1:1
  ai = xj(i)*yk(i)-xk(i)*yj(i);%xjyk-xkyj
  bi = yj(i)-yk(i);%yj-yk
  ci = xk(i)-xj(i);%xk-xj
  Si =  0.5 * abs((xj(i) - xi(i))*(yk(i) - yi(i)) - (xk(i) - xi(i))*(yj(i) - yi(i)));
  func = @(x) 5000/3.2*(ai+bi.*x+ci*yk(i)).*x/(2*Si);%(Ni*p(x))
  f(i) = f(i) + integral(func,xi(i),xk(i));
  %计算f(i+1) k->j,i->k,j->i----------------------------------------------------------------
  ai = xi(i)*yj(i)-xj(i)*yi(i);%xjyk-xkyj
  bi = yi(i)-yj(i);%yj-yk
  ci = xj(i)-xi(i);%xk-xj
  func = @(x) (ai+bi.*x+ci*yk(i))*5000/3.2.*x/(2*Si);
  f(i+1) = f(i+1) + integral(func,xi(i),xk(i));
  
end
end