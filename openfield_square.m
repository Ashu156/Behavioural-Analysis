function [distance_total, distance_center, time_center, speed_average, speed_avg_center,entries] = openfield(x,y,duration, center_ratio)

% Created with MATALAB 2014a

% Defining the first valid frame

len = size(x,1);

TFx = isnan(x);
TFy = isnan(y);

check = 0;

for i = 1:len       
    if TFx(i) == 0 && TFy(i) == 0 && check == 0
        frame_start = i;
        check = 1;
    end
end

frame_start = 9567;
% Trajectories starrting from valid frame

x_valid = x(frame_start:frame_start + (5*25*60),1);
y_valid = y(frame_start:frame_start + (5*25*60),1);

% Removing NaNs

len = size(x_valid,1);


for i = 1:len
    if isnan(x_valid(i)) == 1
        x_valid(i) = x_valid(i - 1);
        y_valid(i) = y_valid(i - 1);
    end
end



% Determing the size of the arena
x_sort = sort(x_valid);
y_sort = sort(y_valid);


x_min = mean(x_sort(1:50));
y_min = mean(y_sort(1:50));

x_max = mean(x_sort((size(x_sort,1)-50):(size(x_sort,1))));
y_max = mean(y_sort((size(y_sort,1)-50):(size(y_sort,1))));


% Distance travelled by each rat

len = (duration*25*60);
distance_total = 0;
speed_sum = 0;

for i = 1:len - 1
    distance_frame = sqrt(((x_valid(i) - x_valid(i + 1))^2) + ((y_valid(i) - y_valid(i + 1))^2));
   distance_total = distance_total + distance_frame;
   speed_sum = speed_sum + distance_frame*25;
end

disp(['Distance travelled by the Rat is ' , num2str(distance_total), ' centimeters']);
speed_average = speed_sum / len;

% Plotting the Tracks
f1 = figure;
plot(x_valid,y_valid,'-r','Linewidth',1.5);
axis([x_min-10 x_max+10 y_min-10 y_max+10]);
set(gcf,'Color',[1 1 1]);
set(gca,'XTick',[],'YTick',[]);

 
% saveas(f1,strcat(location,'track_',animal_name,'.fig'))
hold on;

% Defining the center zone
x_center = (x_min + x_max) / 2;
y_center = (y_min + y_max) / 2;

x_length = x_max - x_min;
y_length = y_max - y_min;

x_center_min = x_center - (x_length / (2*center_ratio));
x_center_max = x_center + (x_length / (2*center_ratio));
y_center_min = y_center - (y_length / (2*center_ratio));
y_center_max = y_center + (y_length / (2*center_ratio));

frames_center = 0;
distance_center = 0;
speed_sum_center = 0;
position_state = zeros(len,1);

for i = 1:len
   
    if x_valid(i) >= x_center_min  &&  x_valid(i) <= x_center_max  &&  y_valid(i) >= y_center_min  &&  y_valid(i) <= y_center_max
        frames_center = frames_center + 1;
        distance_frame = sqrt(((x_valid(i) - x_valid(i + 1))^2) + ((y_valid(i) - y_valid(i + 1))^2));
        distance_center = distance_center + distance_frame;
        speed_sum_center = speed_sum_center + distance_frame*25;
        position_state(i) = 1;
        plot(x_valid(i),y_valid(i),'.k');
        
    end
end

time_center = frames_center / 25;
speed_avg_center = speed_sum_center / frames_center;


% Calculating the number of crossings between the zones

movement = zeros(len,1);

for i = 1:len - 1
    movement(i,1) = position_state((i + 1),1) - position_state(i,1);
end
entries = size(find(movement),1);

disp(['Distance travelled in center is ' , num2str(distance_center), ' centimeters']);
disp(['Time in center is ' , num2str(time_center), ' seconds']);
disp(['Average speed is ' , num2str(speed_average), ' cm/s']);
disp(['Average apeed in center is ' , num2str(speed_avg_center), ' cm/s']);
disp(['Number of entries is ' , num2str(entries)]);

% % Plotting time spent (Heat map)
% 
% time=zeros((round(x_max-x_min))+100,round((y_max-y_min))+100);
% r=7;
% for i=len_s:len
%     x_x=round(x1_valid(i)-x_min)+50;
%     y_y=round(y1_valid(i)-y_min)+50;
%     
%     for k=1:(round(x_max-x_min)+100)
%         for kk=1:(round(y_max-y_min)+100)
%             if ((k-x_x)^2+(kk-y_y)^2)^1/2<=r
%         time(k,kk)=time(k,kk)+1;    
%         
%         end
%     end
% end
% 
% 
% end
%     time(x_x,y_y)=time(x_x,y_y)+1;
% % % Ploting Heat map
% % 
% time=time*(1/25);
% f2=figure;
% imagesc(time')
% set(gca,'YDir','reverse','XTick',[],'YTick',[])
% caxis([0 1])
%  saveas(f2,strcat(location,'heat_map_',animal_name,'.eps'))
