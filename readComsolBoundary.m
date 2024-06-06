function [coordinates, elements] = readComsolBoundary(filename)
    % 打开文件
fileID = fopen(filename, 'r');

 if fileID == -1
        error('无法打开文件: %s', filename);
 end

% 初始化变量
coordinates = [];
elements = [];
flag = '';

% 逐行读取文件
while ~feof(fileID)
    line = fgetl(fileID);
    
    % 检查并设置标志以确定当前部分
    if contains(line, '% Coordinates')
        flag = 'coordinates';
        continue;
    elseif contains(line, '% Elements (lines)')
        flag = 'elements';
        continue;
    elseif startsWith(line, '%')
        continue;
    end
    
    % 根据标志读取相应的数据
    if strcmp(flag, 'coordinates')
        coords = str2num(line); %#ok<ST2NM>
        if ~isempty(coords)
            coordinates = [coordinates; coords];
        end
    elseif strcmp(flag, 'elements')
        elems = str2num(line); %#ok<ST2NM>
        if ~isempty(elems)
            elements = [elements; elems];
        end
    end
end

% 关闭文件
fclose(fileID);

% 显示结果
% disp('Coordinates:');
% disp(coordinates);
% 
% disp('Elements (lines):');
% disp(elements);
end