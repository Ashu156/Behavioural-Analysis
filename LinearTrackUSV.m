clc;
close all;
clear all;

x_dim=2.44;
y_dim=0.25;
fps=25;
% 
% % Location of output
% % location='H:\Users\hp\Desktop\';
% % animal_name='187';
% 
% % Loading the trajectory file
load('F:\Behaviour\USVPlayback2018SeptemberOnwards\TrackOnly\Control\ProcessedVideos\A1\trajectories.mat')

% % Defining the Coordinates of Rat
x1=trajectories(:,1,1);
y1=trajectories(:,1,2);

% Defining the first valid frame

len=size(x1,1);

TFx1=isnan(x1);
TFy1=isnan(y1);

check=0;

for i=1:len
    if TFx1(i)==0 && TFy1(i)==0 && check==0
        frame_start=i;
        check=1;
    end
end

% % frame_start=16160; % only for shock experiments
% 
% 
% Trajectories starrting from valid frame

x1_valid=x1(frame_start:frame_start+31500);
y1_valid=y1(frame_start:frame_start+31500);

% Removing and counting NaNs

len=size(x1_valid,1);
nan_counter_x1=0;



for i=1:len
    if isnan(x1_valid(i))==1
        nan_counter_x1=nan_counter_x1+1;
        x1_valid(i)=x1_valid(i-1);
        y1_valid(i)=y1_valid(i-1);
    end
end



% Determing the size of the arena
x_sort=sort([x1_valid]);
y_sort=sort([y1_valid]);


x_min= mean(x_sort(1:50));
y_min= mean(y_sort(1:50));

x_max=mean(x_sort((size(x_sort,1)-50):(size(x_sort,1))));
y_max=mean(y_sort((size(y_sort,1)-50):(size(y_sort,1))));

% Determining the scale factor

x_scale=x_dim/(x_max-x_min);
y_scale=y_dim/(y_max-y_min);

% Actual coordinates

x1_coord=x1_valid*x_scale;
y1_coord=y1_valid*y_scale;

% Distance travelled by each rat

% len=size(x1_coord,1);
x_max=x_max*x_scale;
x_min=x_min*x_scale;
y_max=y_max*y_scale; y_min=y_min*y_scale;
length=(x_max-x_min);
numbersectors=10;
length_sector=length/numbersectors;


len_s=1;
len=1500;
len_increase=1499;
time_matrix=zeros(10,numbersectors);
distance_matrix=zeros(20,1);
for j=1:21
distance1=0;    

for i=len_s:len-1
   distance1=distance1+sqrt(((x1_coord(i)-x1_coord(i+1))^2)+((y1_coord(i)-y1_coord(i+1))^2)); 
end

disp(['Distance travelled by the Rat is ' , num2str(distance1), ' meters']);


% Time spent sector-wise
time_sector=zeros(numbersectors,1);
for i=len_s:len
    x_sector(i,1)=(x1_coord(i)-x_min)/length_sector;
    x1_sector(i,1)=floor(x_sector(i,1))+1;
    if x1_sector(i,1)>numbersectors
        x1_sector(i,1)=numbersectors;
    end
    if x1_sector(i,1)<1
        x1_sector(i,1)=1;
    end
        time_sector(x1_sector(i,1),1)=time_sector(x1_sector(i,1),1)+1;
end
len_s=len+1;
len=len_s+len_increase;
time_matrix(j,:)=(time_sector')./25;
distance_matrix(j)=distance1;
end
time_matrix=(sum(time_matrix,1))./25;
% save(strcat('G:\2017\May_2017\19.05.2017\AU\','minbymin.mat'),'time_matrix','distance_matrix')
d=zeros(1,3);
d(1,1)=sum(distance_matrix(3:5));
d(1,2)=sum(distance_matrix(6:8));
d(1,3)=sum(distance_matrix(14:16));
c=(x1_coord(15001:30750));
d=find(c(:)>(x_min+(x_dim/2)));
d(1,1)/25
c=sum(time_matrix,1);
time_prox=sum(c(8:8))
time_dist=sum(c(1:7));

%  x1_coord=x1_coord(:,1)-x_min;

%% end of code
