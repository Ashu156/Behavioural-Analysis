close all; clear all; clc;

data = xlsread('G:\Behaviour\Place_avoidance\Open_field\Control\16.06.2017\AU\AU.xlsx');

frame_start = 8750;

x_coord = data(frame_start:end, 3);
y_coord = data(frame_start:end, 4);

for i = 1:size(x_coord,1)
    if isnan(x_coord(i)) == 1
        x_coord(i) = x_coord(i - 1);
        y_coord(i) = y_coord(i - 1);
    end
end
 
x_coord = x_coord - min(x_coord); y_coord = y_coord - min(y_coord);

% x_coord=x_coord(frame_start:frame_start+(5*25*60),1);
% y_coord=y_coord(frame_start:frame_start+(5*25*60),1);


x_min = 0; x_max = 1.0631; x_max = 1;
y_min = 0; y_max = 0.8816; y_max = 1;

for k = 1:size(x_coord,1)
    if x_coord(k,1) > x_max
        x_coord(k,1) == x_max;
    end
    if y_coord(k,1) > y_max
        y_coord(k,1) == y_max;
    end
end

 x_coord = (x_coord - x_min); y_coord = (y_coord - y_min);

% Distance travelled by each rat

len = (5*25*60);
distance_total = 0;
speed_sum = 0;

for i = 1:len-1
    distance_frame = sqrt(((x_coord(i) - x_coord(i + 1))^2) + ((y_coord(i) - y_coord(i + 1))^2));
   distance_total = distance_total + distance_frame;
   speed_sum = speed_sum + distance_frame * 25;
end

disp(['Distance travelled by the Rat is ' , num2str(distance_total), ' meters']);
speed_average = speed_sum / len;

% Plotting the Tracks
f1 = figure;
plot(x_coord, y_coord, '-r', 'Linewidth', 1.5)

axis([x_min-0.05 x_max+0.05  y_min-0.05 y_max+0.05]);
% set(gca,'YDir','reverse','XTick',[],'YTick',[])
% set(gca,'XTick',[],'YTick',[])
line([x_min-0.005 x_max+0.005],[y_min-0.005 y_min-0.005],'Linewidth',2);
line([x_min-0.005 x_min-0.005],[y_max+0.005 y_min-0.005],'Linewidth',2);
line([x_max+0.005 x_max+0.005],[y_max+0.005 y_min-0.005],'Linewidth',2);
line([x_min-0.005 x_max+0.005],[y_max+0.005 y_max+0.005],'Linewidth',2);

% saveas(f1,strcat(location,'track_',animal_name,'.fig'))
hold on;

% Defining the center zone
x_center = (x_min + x_max) / 2;
y_center = (y_min + y_max) / 2;

x_length = x_max - x_min;
y_length = y_max - y_min;

plot([x_center x_center], [y_min-0.005 y_max+0.005], '-b', 'Linewidth', 2);
plot([x_min-0.005 x_max+0.005], [y_center y_center], '-b', 'Linewidth', 2);
 
frames_center = 0;
distance_center = 0;
speed_sum_center = 0;
position_state = zeros(len, 1);

for i = 1:len
   
    if x_coord(i) >= x_center && x_coord(i) <= x_max && y_coord(i) <= y_center && y_coord(i) >= y_min
        frames_center = frames_center + 1;
        distance_frame = sqrt(((x_coord(i) - x_coord(i + 1))^2) + ((y_coord(i) - y_coord(i + 1))^2));
        distance_center = distance_center + distance_frame;
        speed_sum_center = speed_sum_center + distance_frame * 25;
        position_state(i) = 1;
        plot(x_coord(i), y_coord(i), '.k');
        
    end
end

time_center = frames_center / 25;
speed_avg_center = speed_sum_center / frames_center;


% Calculating the number of crossings between the zones

movement = zeros(len, 1);

for i = 1:len-1
    movement(i,1) = position_state((i + 1), 1) - position_state(i, 1);
end
entries = size(find(movement), 1);

disp(['Distance travelled in quadrant is ' , num2str(distance_center), ' meters']);
disp(['Time in quadrant is ' , num2str(time_center), ' seconds']);
disp(['Average speed is ' , num2str(speed_average), ' m/s']);
disp(['Average speed in quadrant is ' , num2str(speed_avg_center), ' m/s']);
disp(['Number of entries is ' , num2str(entries)]);

%% Plotting time spent (Heat map)
 
time = zeros((round(x_max - x_min)) + 100,round((y_max - y_min)) + 100);
r = 7;
len_s = 1;
for i = len_s:len
    x_x = round(x_coord(i) - x_min) + 00;
    y_y = round(y_coord(i) - y_min) + 00;
    
    for k = 1:(round(x_max-x_min) + 00)
        for kk = 1:(round(y_max - y_min) + 00)
            if ((k - x_x)^2 + (kk - y_y)^2)^1/2 <= r
        time(k, kk) = time(k, kk) + 1;    
        
        end
    end
end


end
%     time(x_x,y_y)=time(x_x,y_y)+1;
%% Ploting Heat map

time = time * (1 / 25);
f2 = figure;
imagesc(time')
set(gca, 'YDir', 'reverse', 'XTick', [], 'YTick', [])
caxis([0 1])
%  saveas(f2,strcat(location, 'heat_map_', animal_name, '.eps');


