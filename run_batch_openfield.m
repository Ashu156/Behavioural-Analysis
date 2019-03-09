% Requires the function: openfield_circle

clear all;
close all;
clc;
%%
duration = 5;
center_ratio = 5/4;

pathname = uigetdir;
files = dir(pathname);
fileIndex = find(~[files.isdir]);

for i = 1:length(fileIndex)
    
    filename = files(fileIndex(i)).name;

    load_file = (strcat(pathname,'\',filename));
    data = xlsread(load_file);

    x = data(:,3);
    y = data(:,4);

    %[distance_total, distance_center, time_center, speed_average, speed_avg_center,entries]=openfield(x,y,duration, center_ratio);
    [distance_total, distance_center, time_center, speed_average, speed_avg_center,entries] = openfield_circle(x,y,duration, center_ratio);

    output(1) = distance_total;
    output(2) = distance_center;
    output(3) = time_center;
    output(4) = speed_average;
    output(5) = speed_avg_center;
    output(6) = entries;
    
    combined_output{i,:} = output;

    animal{i,1} = filename(1:size((filename),2) - 17);
    
end

final_output = cell2mat(combined_output);