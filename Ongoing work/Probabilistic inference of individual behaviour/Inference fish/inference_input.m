%% inference_input
%% Analyses data to produce input for the inference
%% First we want to infer the transition rates between the three states of an individual fish

global dataset redef
global x y vx vy ax ay borders wallD wall_distances dt
global omega1 omega2 phi1 phi2 L1 L2
global minvel1 maxvel1 minvel2 maxvel2
global breakpoints1 breakpoints2 breakpoints12
global DATA1 DATA2 ADATA1 ADATA2
global velocity1 velocity2 distance1 distance2 state1 state2 mutdistance1 mutdistance2
global DATA1train DATA1test DATA2train DATA2test
global ADATA1train ADATA1test ADATA2train ADATA2test

                
%% 1. LOAD DATA
if dataset == 2
    load('2fish(22FD)coor.mat');
    load('2fish(22FD)Wall.mat');
elseif dataset == 3
	load('2fish(23FD)coor.mat');
	load('2fish(23FD)Wall.mat');
end

%% SET DIMENSIONS AND SMOOTH THE DATA
dt = 0.01; %seconds

%% smoothing with Savitzky-Golay filter
idstart = 4; 
S1 = size(trackX); idend = S1(2);
[x,y,vx,vy,ax,ay,wall_distances] = process_raw_data(trackX(:,idstart:idend), trackY(:,idstart:idend), borders, st);


%% COMPUTE ANGLES AND SEGMENT THE DATA INTO THE STATES
S = size(x); 
s = 1; t = S(2);        %% data range

%% compute angles
[omega1,phi1,L1]=compute_omega_phi_L(x(1,s:t),y(1,s:t)); %% computes angles and step sizes
[omega2,phi2,L2]=compute_omega_phi_L(x(2,s:t),y(2,s:t)); %% computes angles and step sizes


%% find minima and maxima of velocity
[minvel1,maxvel1] = velocity_segments(x,y,vx,vy,1);
[minvel2,maxvel2] = velocity_segments(x,y,vx,vy,2);


%% 2. OBTAIN TRANSITION DATA

%% DATA have a form of a table with rows corresponding to the switching events and columns to:
%% 1. Index of transition
%% 2. State: 1/2/3 = deceleration/Left acceleration/Right acceleration
%% 3. Velocity
%% 4. Distance from the wall with a sign
%% 5. Mutual distance between fish with a sign
%%
%% DATA1 = info about fish1 (1,2,3)
%% DATA2 = info about fish2 (1,2,3)

%% 2.1 Points of minima/maxima
breakpoints1 = sort([maxvel1,minvel1]); %% fish1
breakpoints2 = sort([maxvel2,minvel2]); %% fish2
breakpoints12 = sort([breakpoints1,breakpoints2]); %% fish1, fish2

DATA1 = zeros(length(breakpoints1),5);
DATA2 = zeros(length(breakpoints2),5);

DATA1(:,1) = breakpoints1;
DATA2(:,1) = breakpoints2;

%% 2.2 Classification into left/right state
if minvel1(1)==1 state1 = (-1).^([0:length(breakpoints1)-1])+2;
else state1 = (-1).^([0:length(breakpoints1)-1]+1)+2;
end
for i=1:length(state1)-1
    if state1(i)==3
        if omega1(breakpoints1(i)) > pi/2 & omega1(breakpoints1(i+1)) < -pi/2 state1(i) = 2;
        elseif omega1(breakpoints1(i)) < -pi/2 & omega1(breakpoints1(i+1)) > pi/2 state1(i) = 3;
        else state1(i) = 2*(omega1(breakpoints1(i+1))-omega1(breakpoints1(i)) > 0) + 3*(omega1(breakpoints1(i+1))-omega1(breakpoints1(i)) < 0);
        end       
    end
end

if minvel2(1)==1 state2 = (-1).^([0:length(breakpoints2)-1])+2;
else state2 = (-1).^([0:length(breakpoints2)-1]+1)+2;
end
for i=1:length(state2) - 1
    if state2(i)==3
        if omega2(breakpoints2(i)) > pi/2 & omega2(breakpoints2(i+1)) < -pi/2 state2(i) = 2;
        elseif omega2(breakpoints2(i)) < -pi/2 & omega2(breakpoints2(i+1)) > pi/2 state2(i) = 3;
        else state2(i) = 2*(omega2(breakpoints2(i+1))-omega2(breakpoints2(i)) > 0) + 3*(omega2(breakpoints2(i+1))-omega2(breakpoints2(i)) < 0);
        end
    end
end

DATA1(:,2) = state1;
DATA2(:,2) = state2;

%% 2.3 Velocity at the transitions
velocity1 = sqrt(vx(1,breakpoints1).^2 + vy(1,breakpoints1).^2);
velocity2 = sqrt(vx(2,breakpoints2).^2 + vy(2,breakpoints2).^2);

DATA1(:,3) = velocity1;
DATA2(:,3) = velocity2;

%% 2.4 Distance from the wall
%distance1 = abs(wall_distances(1,breakpoints1));
%distance2 = abs(wall_distances(2,breakpoints2));
distance1 = (wall_distances(1,breakpoints1));
distance2 = (wall_distances(2,breakpoints2));

DATA1(:,4) = distance1;
DATA2(:,4) = distance2;
%plot_timetrace(1,10,1,1000,x,y,omega1,omega2,vx,vy,ax,ay,minvel1,maxvel1,wallD);

%% 2.5 Mutual distance with a sign
mutdistance1 = sqrt((x(2,breakpoints1)-x(1,breakpoints1)).^2 + (y(2,breakpoints1)-y(1,breakpoints1)).^2);
mutdistance2 = sqrt((x(2,breakpoints2)-x(1,breakpoints2)).^2 + (y(2,breakpoints2)-y(1,breakpoints2)).^2);

% whether fish is within the sight: distance if in the vision angle +/-pi/2
angle12 = sign(vx(1,breakpoints1).*(x(2,breakpoints1)-x(1,breakpoints1)) - vy(1,breakpoints1).*(y(2,breakpoints1)-y(1,breakpoints1)));
angle21 = sign(vx(2,breakpoints2).*(x(1,breakpoints2)-x(2,breakpoints2)) - vy(2,breakpoints2).*(y(1,breakpoints2)-y(2,breakpoints2)));

% whether fish is on the left/right, alignment
sgn12 = sign(vx(1,breakpoints1).*vy(2,breakpoints1) - vy(1,breakpoints1).*vx(2,breakpoints1));
sgn21 = sign(vx(2,breakpoints2).*vy(1,breakpoints2) - vy(2,breakpoints2).*vx(1,breakpoints2));

DATA1(:,5) = mutdistance1;
DATA2(:,5) = mutdistance2;


if redef == 0
    DATA1(:,5) = mutdistance1;
    DATA2(:,5) = mutdistance2;
elseif redef == 1
    DATA1(:,5) = mutdistance1.*(angle12 > 0);
    DATA2(:,5) = mutdistance2.*(angle21 > 0);
elseif redef == 2
    DATA1(:,5) = mutdistance1.*(sgn12);
    DATA2(:,5) = mutdistance2.*(sgn21);    
elseif redef == 3
    DATA1(:,5) = mutdistance1.*(sgn12).*(angle12 > 0);
    DATA2(:,5) = mutdistance2.*(sgn21).*(angle21 > 0);    
end


% %% 2.6 Training set / Testing set splitting
% P = 1000;                       %% size of the basic data segment used for splitting the data into the 
%                                 %% training and testing set
% LP = ceil(S(2)/P);              %% number of segments
% TrainVec = round(rand(1,LP));   %% i-th element is 1 if the (i-1)*P:i*P components of the trajectory
%                                 %% go into the training set, 0 if in the testing set
% 
% DATA1train = [];
% DATA1test = [];
% DATA2train = [];
% DATA2test = [];
% 
% for i=1:length(DATA1)
%     idblock = DATA1(i,1);
%     if TrainVec(ceil(idblock/P))==1
%         DATA1train = [DATA1train;DATA1(i,:)];
%     else
%         DATA1test = [DATA1test;DATA1(i,:)];
%     end
% end
% 
% for i=1:length(DATA2)
%     idblock = DATA2(i,1);
%     if TrainVec(ceil(idblock/P))==1
%         DATA2train = [DATA2train;DATA2(i,:)];
%     else
%         DATA2test = [DATA2test;DATA2(i,:)];
%     end
% end
      

%% 3. OBTAIN DATA BETWEEN TRANSITIONS - ALL DATAPOINTS USED

%% 3.1 Take all timepoints
breakpoints = [1:length(x)];

ADATA1 = zeros(length(breakpoints),5);
ADATA2 = zeros(length(breakpoints),5);

ADATA1(:,1) = breakpoints;
ADATA2(:,1) = breakpoints;

%% 3.2 Classification into left/right states
for i=1:length(breakpoints1)-1
    for j=breakpoints1(i):breakpoints1(i+1)-1
        ADATA1(j,2) = DATA1(i,2);
    end
end
for j=breakpoints1(end):length(x)
    ADATA1(j,2) = 1; %just anything, need to cut it out
end

for i=1:length(breakpoints2)-1
    for j=breakpoints2(i):breakpoints2(i+1)-1
        ADATA2(j,2) = DATA2(i,2);
    end
end

%% 3.3 Velocity at all timepoints
Avelocity1 = sqrt(vx(1,:).^2 + vy(1,:).^2);
Avelocity2 = sqrt(vx(2,:).^2 + vy(2,:).^2);

ADATA1(:,3) = Avelocity1(1:length(x));
ADATA2(:,3) = Avelocity2(1:length(x));

%% 3.4 Distance from the wall with a sign
%ADATA1(:,4) = abs(wall_distances(1,:)');
%ADATA2(:,4) = abs(wall_distances(2,:)');
ADATA1(:,4) = (wall_distances(1,:)');
ADATA2(:,4) = (wall_distances(2,:)');


%% 3.5 Mutual distance with a sign
Amutdistance1 = sqrt((x(2,:)-x(1,:)).^2 + (y(2,:)-y(1,:)).^2);
Amutdistance2 = sqrt((x(2,:)-x(1,:)).^2 + (y(2,:)-y(1,:)).^2);

% whether fish is within the sight: distance if in the vision angle +/-pi/2
Angle12 = sign(vx(1,:).*(x(2,:)-x(1,:)) - vy(1,:).*(vy(2,:)-vy(1,:)));
Angle21 = sign(vx(2,:).*(x(1,:)-x(2,:)) - vy(2,:).*(vy(1,:)-vy(2,:)));

% whether fish is on the left/right, alignment
Sgn12 = sign(vx(1,:).*vy(2,:) + vy(1,:).*vx(2,:));
Sgn21 = sign(vx(2,:).*vy(1,:) + vy(2,:).*vx(1,:));

%redef = 2;     %% 0 - just distance
                %% 1 - distance if in the front
                %% 2 - adds a sign due to alignment
                %% 3 - if in the front + adds a sign due to alignment

if redef == 0
    ADATA1(:,5) = Amutdistance1;
    ADATA2(:,5) = Amutdistance2;    
elseif redef == 1
    ADATA1(:,5) = Amutdistance1.*(Angle12 > 0);
    ADATA2(:,5) = Amutdistance2.*(Angle21 > 0);
elseif redef == 2
    ADATA1(:,5) = Amutdistance1.*(Sgn12);
    ADATA2(:,5) = Amutdistance2.*(Sgn21);    
elseif redef == 3
    ADATA1(:,5) = Amutdistance1.*(Sgn12).*(Angle12 > 0);
    ADATA2(:,5) = Amutdistance2.*(Sgn21).*(Angle21 > 0);    
end


% %% 3.6 Training set / Testing set splitting
% % P = 1000;                       %% size of the basic data segment used for splitting the data into the 
% %                                 %% training and testing set
% % LP = ceil(S(2)/P);              %% number of segments
% % TrainVec = round(rand(1,LP));   %% i-th element is 1 if the (i-1)*P:i*P components of the trajectory
% %                                 %% go into the training set, 0 if in the testing set
% 
% ADATA1train = [];
% ADATA1test = [];
% ADATA2train = [];
% ADATA2test = [];
% 
% for i=1:length(TrainVec)
%     if TrainVec(i)==1
%         ADATA1train = [ADATA1train;ADATA1((i-1)*P+1:min(i*P,S(2)),:)];
%     else
%         ADATA1test = [ADATA1test;ADATA1((i-1)*P+1:min(i*P,S(2)),:)];
%     end
% end
% 
% for i=1:length(TrainVec)
%     if TrainVec(i)==1
%         ADATA2train = [ADATA2train;ADATA2((i-1)*P+1:min(i*P,S(2)),:)];
%     else
%         ADATA2test = [ADATA2test;ADATA2((i-1)*P+1:min(i*P,S(2)),:)];
%     end
% end


