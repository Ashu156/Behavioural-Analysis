function[Time,Transitions,Tau] = summary_histogramsRT_CG(T,S,Z,Tdetail,Sdetail,Zdetail)
global Xmin Xmax Ymin Ymax
global NbinsX NbinsY NbinsA NbinsT 
global Xhist Yhist Ahist Thist Tmax dt dphi


%% modify to the coarse-grained case!!!
%% 3D transitions
Transitions = zeros(2,NbinsX,NbinsY,NbinsA);
for i=1:length(S)-1
    [c1 i1] = min(abs(Xhist-Z(i+1,1)));
    [c2 i2] = min(abs(Yhist-Z(i+1,2)));
    [c3 i3] = min(abs(Ahist-mod(Z(i+1,3),2*pi)));
    if (S(i) == 1 & S(i+1) == 2) Transitions(1,i1,i2,i3) = Transitions(1,i1,i2,i3) + 1; end
    if (S(i) == 2 & S(i+1) == 1) Transitions(2,i1,i2,i3) = Transitions(2,i1,i2,i3) + 1; end
end  


%% Time occupancy of the RUN state
Time = zeros(2,NbinsX,NbinsY,NbinsA);
for i=2:length(Zdetail)
   [c1 i1] = min(abs(Xhist-Zdetail(i,1)));
   [c2 i2] = min(abs(Yhist-Zdetail(i,2)));
   [c3 i3] = min(abs(Ahist-mod(Zdetail(i,3),2*pi)));
   if Sdetail(i) == 1  
     Time(1,i1,i2,i3) = Time(1,i1,i2,i3) + Tdetail(i) - Tdetail(i-1);
   end
end


%% Time occupancy of the TUMBLE state
%% First find the duration in the TUMBLE state from T,S
Tau = [];
for i=1:length(S)-1
    if S(i) == 2
        Tau = [Tau, [Z(i,1);Z(i,2);Z(i,3);T(i+1) - T(i)]]; %% stores entrance position, angle and time spent
    end
end
       
