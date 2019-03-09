clc;
close all;
clear all;

XDim = 1.90; % length of the arena in m in the physical world
YDim = 0.25; % width of the arena in m in the physical world
fps = 25;    % sampling rate of the camera

% Loading the trajectory file
load('F:\Behaviour\USVPlayback2018SeptemberOnwards\22kHz\Control\BLAInfusion\Saline\ProcessedVideos\Sal19\trajectories.mat')

% Defining the Coordinates of Rat
x1 = trajectories(:,1,1); % x-coordinates in pixels
y1 = trajectories(:,1,2); % y-coordinates in pixels


% Defining the first valid frame

len = size(x1,1); % length of the dataset

TFx1 = isnan(x1); % searching for NaN entries in the  x-coordinates dataset
TFy1 = isnan(y1); % searching for NaN entries in the  y-coordinates dataset

check = 0; % initializing a counter

% Getting the first valid frame

for i = 1:len
    if TFx1(i) == 0 && TFy1(i) == 0 && check == 0
        FrameStart = i;
        check = 1;
    end
end

% FrameStart = 16160; % only for shock experiments


% Trajectories starting from  the valid frame

X1Valid = x1(FrameStart:end); % x1 trajectories
Y1Valid = y1(FrameStart:end); % y1 trajectories

% Removing and counting NaNs

len = size(X1Valid,1);
NanCounterX1 = 0;



for i = 1:len
    if isnan(X1Valid(i)) == 1
        NanCounterX1 = NanCounterX1+1;
        X1Valid(i) = X1Valid(i-1);
        Y1Valid(i) = Y1Valid(i-1);
    end
end



% Determing the size of the arena
XSort = sort([X1Valid]); % sorting the x-coordinates
YSort = sort([Y1Valid]); % sorting the y-coordinates


XMin = mean(XSort(1:50)); % defining minimum of the x-coordinates
YMin = mean(YSort(1:50)); % defining minimum of the y-coordinates

XMax = mean(XSort((size(XSort,1) - 50):(size(XSort,1)))); % defining maximum of the x-coordinates
YMax = mean(YSort((size(YSort,1) - 50):(size(YSort,1)))); % defining maximum of the y-coordinates

% Determining the scale factor

XScale = XDim / (XMax - XMin); % Scaling factor for x- coordinates
YScale = YDim / (YMax - YMin); % Scaling factor for y- coordinates

% Actual coordinates

X1Coord = X1Valid * XScale; % Converting pixel values into real world x-coordinates
Y1Coord = Y1Valid*YScale;   % Converting pixel values into real world y-coordinates
XMax = XMax * XScale;       % real world  maximum of x-coordinates
XMin = XMin * XScale;       % real world  minimum of x-coordinates
YMax = YMax * YScale; YMin = YMin * YScale; % real world  maximum and minimum of y-coordinates
length = (XMax - XMin); % real world length of the track

X1Coord = X1Coord(:,1) - XMin; % normalized x-coordiantes
Y1Coord = Y1Coord(:,1) - YMin; % normalized y-coordinates

% saving the file
save('F:\Behaviour\USVPlayback2018SeptemberOnwards\22kHz\Control\BLAInfusion\Saline\ProcessedVideos\Sal19\trajectories_in_m.mat','X1Coord','Y1Coord')

plot(X1Coord, Y1Coord,'r'); axis image; % plotting the x- and y-coordinates