clc;
close all;
clear all;

x_dim = 1.97;
y_dim = 0.254;
fps = 25;

% Location of output
location = 'C:\FFOutput\May_2015\07.05.2015\';
animal_name = 'B_U_Repeat';
% Loading the trajectory file
load('G:\2015\May_2015\23.05.2015\C_M\trajectories.mat')

% Defining the Coordinates of Rat
x1 = trajectories(:,1,1);
y1 = trajectories(:,1,2);


% Defining the first valid frame

len = size(x1,1);

TFx1 = isnan(x1);
TFy1 = isnan(y1);

check = 0;

for i = 1:len       
    if TFx1(i) == 0 && TFy1(i) == 0 && check == 0
        frame_start = i;
        check = 1;
    end
end


% Trajectories starrting from valid frame

x1_valid = x1(frame_start:frame_start + 7500, 1);
y1_valid = y1(frame_start:frame_start + 7500, 1);

% Removing and counting NaNs

len = size(x1_valid, 1);
nan_counter_x1 = 0;
nan_counter_x2 = 0;


for i = 1:len
    if isnan(x1_valid(i)) == 1
        nan_counter_x1 = nan_counter_x1 + 1;
        x1_valid(i) = x1_valid(i - 1);
        y1_valid(i) = y1_valid(i - 1);
    end
end



% Determing the size of the arena
x_sort = sort([x1_valid]);
y_sort = sort([y1_valid]);


x_min = mean(x_sort(1:50));
y_min = mean(y_sort(1:50));

x_max = mean(x_sort((size(x_sort,1) - 50):(size(x_sort, 1))));
y_max = mean(y_sort((size(y_sort,1) - 50):(size(y_sort, 1))));

% Determining the scale factor

x_scale = x_dim / (x_max - x_min);
y_scale=y_dim/(y_max-y_min);

% Actual coordinates

x1_coord = x1_valid * x_scale;
y1_coord = y1_valid * y_scale;

% Distance travelled by each rat
%len=size(x1_coord,1);
x_max1 = x_max * x_scale;
x_min1 = x_min * x_scale;
len_s = 1;
len = 15000;
distance1 = 0;
for i = len_s:len - 1
   distance1 = distance1 + sqrt(((x1_coord(i) - x1_coord(i + 1))^2) + ((y1_coord(i) - y1_coord(i + 1))^2)); 
end

disp(['Distance travelled by the Rat is ' , num2str(distance1), ' meters']);
t = len_s:1:len + 1;
% Plotting the Tracks
f1 = figure;
% plot(t,x1_coord,y1_coord,'om','Linewidth',0.75,'MarkerFaceColor','m','MarkerSize',4)
% 
% axis([x_min*x_scale-.1 x_max*x_scale+.1 y_min*y_scale-.1 y_max*y_scale+.1])
% set(gca,'YDir','reverse','XTick',[],'YTick',[])

plot3(x1_coord,y1_coord,t,'or')
 
% saveas(f1,strcat(location,'track_',animal_name,'.fig'))
% hold on

% % Defining buffer zone
% boundary=10;
% time_sector=zeros(2,1);
% theta_x=(max(x1_coord)-min(x1_coord))/4;
% theta_y=(max(y1_coord)-min(y1_coord))/4;
% xhigh=max(x1_coord)-theta_x;
% xlow=min(x1_coord)+theta_x;
% yhigh=max(y1_coord)-theta_y;
% ylow=min(y1_coord)+theta_y;
% for j=1:7500
%    
%     if xhigh>=x1_coord(j)&& x1_coord(j)>=xlow && yhigh>=y1_coord(j) && y1_coord(j)>=ylow
%         time_sector(1,:)=time_sector(1,:)+1;
%         plot(x1_coord(j),y1_coord(j),'.k');
%         
%     end
% end
% time_sector(2,:)=(22500-time_sector(1,:));
% time_centre=time_sector(1,:)/25;
% time_edge=900-time_centre;

% Calculating the number of crossings between the zones

% state=1;
% c=zeros(22500,1);
% for i=1:22500
%     if xhigh>=x1_coord(i) && x1_coord(i)>=xlow && yhigh>=y1_coord(i) && y1_coord(i)>=ylow
%         c(i,1)=state;
%     end
% end
% d=zeros(22499,1);
% for i=1:22499
%     d(i,:)=c((i+1),1)-c(i);
% end
% e=size(find(d),1);
% 
% entry=zeros(e,1);
% for i=1:e
%     if d(find(d),1)==1
%         entry(i,:)=1
%     end
% end


% Plotting time spent (Heat map)

time = zeros((round(x_max-x_min))+100,round((y_max-y_min))+100);
r = 7;
for i = len_s:len
    x_x = round(x1_valid(i) - x_min) + 50;
    y_y = round(y1_valid(i) - y_min) + 50;
    
    for k =1:(round(x_max - x_min) + 100)
        for kk=1:(round(y_max - y_min) + 100)
            if ((k - x_x)^2 + (kk - y_y)^2)^1/2 <= r
        time(k, kk) = time(k, kk) + 1;    
        
        end
    end
end


end
    time(x_x, y_y) = time(x_x, y_y) + 1;
%% Ploting Heat map

time = time * (1 / 25);
f2 = figure;
imagesc(time')
set(gca,'YDir','reverse','XTick',[],'YTick',[])
caxis([0 1])
%  saveas(f2,strcat(location,'heat_map_',animal_name,'.eps'));
