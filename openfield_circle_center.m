function [x_max, x_min, y_max, y_min] = openfield_circle_center(x,y,duration, center_ratio)

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


x_min = mean(x_sort(1:20));
y_min = mean(y_sort(1:20));

x_max = mean(x_sort((size(x_sort,1) - 20):(size(x_sort,1))));
y_max = mean(y_sort((size(y_sort,1) - 20):(size(y_sort,1))));


% % Distance travelled by each rat
% 
% len=(duration*25*60);
% distance_total=0;
% speed_sum=0;
% 
% for i=1:len-1
%     distance_frame=sqrt(((x_valid(i)-x_valid(i+1))^2)+((y_valid(i)-y_valid(i+1))^2));
%    distance_total=distance_total+distance_frame;
%    speed_sum=speed_sum+distance_frame*25;
% end
% 
% disp(['Distance travelled by the Rat is ' , num2str(distance_total), ' centimeters']);
% speed_average=speed_sum/len;

% Plotting the Tracks
f1 = figure;
plot(x_valid,y_valid,'-r','Linewidth',1.5)

axis([x_min-10 x_max+10 y_min-10 y_max+10]);
set(gcf,'Color',[1 1 1]);
set(gca,'XTick',[],'YTick',[]);

 
% saveas(f1,strcat(location,'track_',animal_name,'.fig'))
hold on
% 
% % Defining the center zone
% x_center=(x_min+x_max)/2;
% y_center=(y_min+y_max)/2;