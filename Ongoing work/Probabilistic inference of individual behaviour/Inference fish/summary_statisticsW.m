function[TransitionsW,TimeW] = summary_statisticsW(DATA,ADATA)

%% Summary histograms Transitions and Time 
%% Dependence on just velocity or just wall distance

global Wbins
global Whist
global dt

%% DATA 1: Transition histogram
TransitionsW = zeros(6,Wbins);

for i=1:length(DATA)-1
  [w indW] = min(abs(Whist-DATA(i+1,4)));
  if (DATA(i,2) == 1 && DATA(i+1,2) == 2) 
      TransitionsW(1,indW) = TransitionsW(1,indW) + 1;
  end
  if (DATA(i,2) == 1 && DATA(i+1,2) == 3) 
      TransitionsW(2,indW) = TransitionsW(2,indW) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 1) 
      TransitionsW(3,indW) = TransitionsW(3,indW) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 3) 
      TransitionsW(4,indW) = TransitionsW(4,indW) + 1;
  end      
  if (DATA(i,2) == 3 && DATA(i+1,2) == 1) 
      TransitionsW(5,indW) = TransitionsW(5,indW) + 1;
  end
  if (DATA(i,2) == 4 && DATA(i+1,2) == 2) 
      TransitionsW(6,indW) = TransitionsW(6,indW) + 1;
  end
end

%% DATA 2: Occupancy probability

TimeW = zeros(3,Wbins);

for i=1:length(ADATA)-1
  [w indW] = min(abs(Whist-ADATA(i+1,4)));
  if ADATA(i,2) == 1  
      TimeW(1,indW) = TimeW(1,indW) + dt; 
  end
  if ADATA(i,2) == 2  
      TimeW(2,indW) = TimeW(2,indW) + dt;
  end
  if ADATA(i,2) == 3  
      TimeW(3,indW) = TimeW(3,indW) + dt;
  end
end



