% Requires the function: openfield_circle_centerinput
% Written by Sohail

clear all;
close all;
clc;

duration = 5;
center_ratio = 5/4;

% pathname = uigetdir;
% files = dir(pathname);
% fileIndex = find(~[files.isdir]);
% 
%     
%     filename = files(fileIndex(i)).name;

    [filename,pathname,FilterIndex] = uigetfile;
    load_file=(strcat(pathname,'\',filename));
    data = xlsread(load_file);

    x = data(:,3);
    y = data(:,4);

    [x_max, x_min, y_max, y_min ] = openfield_circle_center(x,y,duration, center_ratio);
    
    [filename,pathname,FilterIndex] = uigetfile;
    load_file = (strcat(pathname,'\',filename));
    data = xlsread(load_file);

    x = data(:,3);
    y = data(:,4);
    [distance_total, distance_center, time_center, speed_average, speed_avg_center,entries] = openfield_circle_centerinput(x,y,duration, center_ratio, x_max, x_min, y_max, y_min);

    output(1) = distance_total;
    output(2) = distance_center;
    output(3) = time_center;
    output(4) = speed_average;
    output(5) = speed_avg_center;
    output(6) = entries;
    
    combined_output{1,:} = output;

    animal{1,1} = filename(1:size((filename),2) - 17);
    


final_output = cell2mat(combined_output);
