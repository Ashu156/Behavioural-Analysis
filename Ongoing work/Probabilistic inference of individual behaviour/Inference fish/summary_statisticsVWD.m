function[Transitions,Time] = summary_statisticsVWD(DATA,ADATA)

%% Summary histograms Transitions and Time 
%% Dependence on velocity, wall distance and mutual distance

global Wcrude

global Vbins Wbins Dbins
global Vhist Whist Dhist 
global dt

Wthresh = 2; %% threshold for the interface between the large and the small wall distances

%% STATISTICS 1: Transition histogram
Transitions = zeros(6,Vbins,Wbins,Dbins);
for i=1:length(DATA)-1
  [v indV] = min(abs(Vhist-DATA(i+1,3)));
  [d indD] = min(abs(Dhist-DATA(i+1,5)));

  if Wcrude == 1
    if abs(DATA(i+1,4)) > Wthresh indW = 3;
    elseif DATA(i+1,4) > 0 indW = 2;
    else indW = 1;
    end
  else
      [w indW] = min(abs(Whist-DATA(i+1,4)));
  end
  
  if (DATA(i,2) == 1 && DATA(i+1,2) == 2) Transitions(1,indV,indW,indD) = Transitions(1,indV,indW,indD) + 1; end
  if (DATA(i,2) == 1 && DATA(i+1,2) == 3) Transitions(2,indV,indW,indD) = Transitions(2,indV,indW,indD) + 1; end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 1) Transitions(3,indV,indW,indD) = Transitions(3,indV,indW,indD) + 1; end
  if (DATA(i,2) == 2 && DATA(i+1,2) == 3) Transitions(4,indV,indW,indD) = Transitions(4,indV,indW,indD) + 1; end
  if (DATA(i,2) == 3 && DATA(i+1,2) == 1) Transitions(5,indV,indW,indD) = Transitions(5,indV,indW,indD) + 1; end
  if (DATA(i,2) == 4 && DATA(i+1,2) == 2) Transitions(6,indV,indW,indD) = Transitions(6,indV,indW,indD) + 1; end
end


%% STATISTICS 2: Occupancy probability
Time = zeros(3,Vbins,Wbins,Dbins);
for i=1:length(ADATA)-1
  [v indV] = min(abs(Vhist-ADATA(i+1,3)));
  [d indD] = min(abs(Dhist-ADATA(i+1,5)));

  %[w indW] = min(abs(Whist-ADATA(i+1,4)));
  if Wcrude == 1
      if abs(ADATA(i+1,4)) > Wthresh indW = 3;
      elseif ADATA(i+1,4) > 0 indW = 2;
      else indW = 1;
      end
  else
      [w indW] = min(abs(Whist-ADATA(i+1,4)));
  end
  
  if ADATA(i,2) == 1  Time(1,indV,indW,indD) = Time(1,indV,indW,indD) + dt; end
  if ADATA(i,2) == 2  Time(2,indV,indW,indD) = Time(2,indV,indW,indD) + dt; end
  if ADATA(i,2) == 3  Time(3,indV,indW,indD) = Time(3,indV,indW,indD) + dt; end
end



