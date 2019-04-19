function [TCG,SCG,ZCG,TdetailCG,SdetailCG,ZdetailCG] = coarse_grain(T,S,Z,Tdetail,Sdetail,Zdetail);
%% coarse grains the full data by neglecting the microstates and transitions between them
%% 1 = RUN, 2 = TUMBLE UP, 3 = TUMBLE DOWN

SCG = S;
ZCG = Z; %% stores positions and angles at transitions
TCG = T;
SdetailCG = Sdetail;
TdetailCG = Tdetail;
ZdetailCG = Zdetail;

for i=1:length(S)
    if SCG(i) == 3 
        SCG(i) = 2; 
    end %% all 2,3 states replaced by 2
end
%% now trash the transitions that are not informative
for i=length(SCG)-1:-1:1
    if (SCG(i) == 2 & SCG(i+1) == 2) 
        TCG(i+1) = []; 
        SCG(i+1) = [];
        ZCG = [ZCG(1:i,:);ZCG(i+2:end,:)];
    end 
end


for i=1:length(Sdetail)
    if SdetailCG(i) == 3 
        SdetailCG(i) = 2; 
    end %% all 2,3 states replaced by 2
end
for i=length(SdetailCG)-2:-1:1
    if (SdetailCG(i) == 2 & SdetailCG(i+1) == 2 & SdetailCG(i+2) == 2) 
        TdetailCG(i+1) = []; 
        SdetailCG(i+1) = [];
        ZdetailCG = [ZdetailCG(1:i,:);ZdetailCG(i+2:end,:)];
    end 
end

%%%%%%%%%%%%%%%%
% Time = zeros(2,NbinsX,NbinsY,NbinsA);
% for i=2:length(Zdetail)
%    [c1 i1] = min(abs(Xhist-Zdetail(i,1)));
%    [c2 i2] = min(abs(Yhist-Zdetail(i,2)));
%    [c3 i3] = min(abs(Ahist-mod(Zdetail(i,3),2*pi)));
%    if Sdetail(i) == 1 
%      Time(1,i1,i2,i3) = Time(1,i1,i2,i3) + Tdetail(i) - Tdetail(i-1);
%    end
% end