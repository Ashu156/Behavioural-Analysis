tic
clc
close all
clear all

x_dim=1.90;
y_dim=0.25;
fps=25;
% 
% Location of output
% location='H:\Users\hp\Desktop\';
animal_name='M9';

% Loading the trajectory file
load('E:\Behaviour\USV_playback\22k\BLAinfusion\Muscimol\Processed videos\M8\trajectories.mat');
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

frame_start = 1389; % only for shock experiments


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
time_matrix=zeros(21,numbersectors);
distance_matrix=zeros(10,1);
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

HabStart=1; HabEnd=7500;
pb1Start=7501; pb1End=12000;
pb2Start=19501; pb2End=24000;

fromBinNosHab = x1_sector(HabStart:HabEnd-1); % starting node for habituation session
nextBinNosHab = x1_sector(HabStart+1:HabEnd);   % ending node for habituation session

fromBinNospb1 = x1_sector(pb1Start:pb1End-1); % starting node for 1st playback session
nextBinNospb1 = x1_sector(pb1Start+1:pb1End);   % ending node for 1st playback session

fromBinNospb2 = x1_sector(pb2Start:pb2End-1); % starting node for 2nd playback session
nextBinNospb2 = x1_sector(pb2Start+1:pb2End);   % ending node for 2nd playback session

freqMatHab = zeros(numbersectors, numbersectors); % initializing the transition probability / stochastic matrix
freqMatpb1 = zeros(numbersectors, numbersectors); % initializing the transition probability / stochastic matrix
freqMatpb2 = zeros(numbersectors, numbersectors); % initializing the transition probability / stochastic matrix


for i=1:size(fromBinNosHab,1)
if fromBinNosHab(i)== nextBinNosHab(i) % not counting if the rat remains in the same sector,i.e., autotransitions are not allowed
    
freqMatHab(fromBinNosHab(i),nextBinNosHab(i)) = 0;

else
freqMatHab(fromBinNosHab(i),nextBinNosHab(i)) = freqMatHab(fromBinNosHab(i),nextBinNosHab(i)) + 1; % counting the number of transitions

end
end

for i=1:size(fromBinNospb1,1)
if fromBinNospb1(i)== nextBinNospb1(i) % not counting if the rat remains in the same sector
    freqMatpb1(fromBinNospb1(i),nextBinNospb1(i)) = 0;
else
    
freqMatpb1(fromBinNospb1(i),nextBinNospb1(i)) = freqMatpb1(fromBinNospb1(i),nextBinNospb1(i)) + 1; % counting the number of transitions

end

if fromBinNospb2(i)== nextBinNospb2(i) % not counting if the rat remains in the same sector
    freqMatpb1(fromBinNospb1(i),nextBinNospb2(i)) = 0;
    
else    

freqMatpb2(fromBinNospb2(i),nextBinNospb2(i)) = freqMatpb2(fromBinNospb2(i),nextBinNospb2(i)) + 1; % counting the number of transitions
end
end




numrow= numbersectors;  % number of rows in the transition probability matrix 
numcol= numbersectors; % number of columns in the transition probability matrix

% Normalizing the matrix entries such that each row sums up to 1

for j=1:numrow
    
    MatHab(j)=sum(freqMatHab(j,:));
    Matpb1(j)=sum(freqMatpb1(j,:));
    Matpb2(j)=sum(freqMatpb2(j,:));
    
    for k=1:numcol
        
        freqMatHab(j,k)=freqMatHab(j,k)./MatHab(j);
        freqMatpb1(j,k)=freqMatpb1(j,k)./Matpb1(j);
        freqMatpb2(j,k)=freqMatpb2(j,k)./Matpb2(j);
          
    end
end

 TFhab=isnan(freqMatHab);
 TFpb1=isnan(freqMatpb1);
 TFpb2=isnan(freqMatpb2);


for j=1:numrow
    for k =1:numcol
        
        if TFhab(j,k)==1
            freqMatHab(j,k)=0;
        end

        if TFpb1(j,k)==1
            freqMatpb1(j,k)=0;
        end
        
        if TFpb2(j,k)==1
            freqMatpb2(j,k)=0;
        end
    end
end

% plotting the matrix as a heat plot

figure;
subplot(311),imagesc(freqMatHab), colorbar, caxis([0 1]); title('habituation');
subplot(312),imagesc(freqMatpb1), colorbar, caxis([0 1]); title('1st playback');
subplot(313),imagesc(freqMatpb2), colorbar, caxis([0 1]); title('2nd playback');

% save(strcat('E:\Behaviour\USV_playback\22k\BLAinfusion\Muscimol\Processed videos\M9\',animal_name,'freq.mat'),'freqMatHab','freqMatpb1','freqMatpb2')

toc;
