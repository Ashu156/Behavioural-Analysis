function[TransitionsVW,TimeVW] = summary_statisticsVW(DATA,ADATA)

%% Summary histograms Transitions and Time 
%% Dependence on both velocity and wall distance

global Vbins Wbins
global Vhist Whist
global dt

%% DATA 1: Transition histogram
TransitionsVW = zeros(6,Vbins,Wbins);



%% DATA 1: Transition histogram
for i=1:length(DATA)-1
  [v indV] = min(abs(Vhist-DATA(i+1,3)));
  [w indW] = min(abs(Whist-DATA(i+1,4)));
  if (DATA(i,2) == 1 && DATA(i+1,2) == 2) 
      TransitionsVW(1,indV,indW) = TransitionsVW(1,indV,indW) + 1; 
  end
  if (DATA(i,2) == 1 && DATA(i+1,2) == 3) 
      TransitionsVW(2,indV,indW) = TransitionsVW(2,indV,indW) + 1;
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 1) 
      TransitionsVW(3,indV,indW) = TransitionsVW(3,indV,indW) + 1; 
  end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 3) 
      TransitionsVW(4,indV,indW) = TransitionsVW(4,indV,indW) + 1; 
  end
  if (DATA(i,2) == 3 && DATA(i+1,2) == 1) 
      TransitionsVW(5,indV,indW) = TransitionsVW(5,indV,indW) + 1; 
  end
  if (DATA(i,2) == 4 && DATA(i+1,2) == 2) 
      TransitionsVW(6,indV,indW) = TransitionsVW(6,indV,indW) + 1; 
  end
end

%% DATA 2: Occupancy probability

TimeVW = zeros(3,Vbins,Wbins);

for i=1:length(ADATA)-1
  [v indV] = min(abs(Vhist-ADATA(i+1,3)));
  [w indW] = min(abs(Whist-ADATA(i+1,4)));
  if ADATA(i,2) == 1  
      TimeVW(1,indV,indW) = TimeVW(1,indV,indW) + dt; 
  end
  if ADATA(i,2) == 2  
      TimeVW(2,indV,indW) = TimeVW(2,indV,indW) + dt; 
  end
  if ADATA(i,2) == 3  
      TimeVW(3,indV,indW) = TimeVW(3,indV,indW) + dt; 
  end
end



