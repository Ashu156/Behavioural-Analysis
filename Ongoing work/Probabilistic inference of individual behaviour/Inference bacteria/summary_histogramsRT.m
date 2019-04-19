function[Time,Transitions] = summary_histogramsRT(T,S,Z,Tdetail,Sdetail,Zdetail)
global NbinsX NbinsY NbinsA Xhist Yhist Ahist

%% 3D transitions
Transitions = zeros(6,NbinsX,NbinsY,NbinsA);
for i=1:length(S)-1
    [c1 i1] = min(abs(Xhist-Z(i+1,1)));
    [c2 i2] = min(abs(Yhist-Z(i+1,2)));
    [c3 i3] = min(abs(Ahist-mod(Z(i+1,3),2*pi)));
    if (S(i) == 1 & S(i+1) == 2) Transitions(1,i1,i2,i3) = Transitions(1,i1,i2,i3) + 1; end
    if (S(i) == 1 & S(i+1) == 3) Transitions(2,i1,i2,i3) = Transitions(2,i1,i2,i3) + 1; end
    if (S(i) == 2 & S(i+1) == 1) Transitions(3,i1,i2,i3) = Transitions(3,i1,i2,i3) + 1; end
    if (S(i) == 2 & S(i+1) == 3) Transitions(4,i1,i2,i3) = Transitions(4,i1,i2,i3) + 1; end
    if (S(i) == 3 & S(i+1) == 1) Transitions(5,i1,i2,i3) = Transitions(5,i1,i2,i3) + 1; end
    if (S(i) == 3 & S(i+1) == 2) Transitions(6,i1,i2,i3) = Transitions(6,i1,i2,i3) + 1; end
end

%% 2D occupancy
Time = zeros(3,NbinsX,NbinsY,NbinsA);
for i=2:length(Zdetail)
   [c1 i1] = min(abs(Xhist-Zdetail(i,1)));
   [c2 i2] = min(abs(Yhist-Zdetail(i,2)));
   [c3 i3] = min(abs(Ahist-mod(Zdetail(i,3),2*pi)));
   if Sdetail(i) == 1 
     Time(1,i1,i2,i3) = Time(1,i1,i2,i3) + Tdetail(i) - Tdetail(i-1);
   end
   if Sdetail(i) == 2 
     Time(2,i1,i2,i3) = Time(2,i1,i2,i3) + Tdetail(i) - Tdetail(i-1);
   end
   if Sdetail(i) == 3 
     Time(3,i1,i2,i3) = Time(3,i1,i2,i3) + Tdetail(i) - Tdetail(i-1);
   end
end

 