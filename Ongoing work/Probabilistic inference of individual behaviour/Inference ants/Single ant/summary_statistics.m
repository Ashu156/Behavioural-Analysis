function[NSU, NSD, NUS, NUD, NDS, NDU, TimeS, TimeU, TimeD] = summary_statistics(T,S,Z,Tdetail,Sdetail,Zdetail)
global Snow aS aU aD bS bU bD thresh 
global Nbins Zhist Avector
%global NSU NSD NUS NUD NDS NDU TimeS TimeU TimeD


%% DATA 1: Number of transitions in each bin
ZSU = []; ZSD = []; ZUS = []; ZUD = []; ZDS = []; ZDU = [];
for i=1:length(S)-1
  if (S(i) == 1 && S(i+1) == 2) ZSU = [ZSU,Z(i+1)]; end
  if (S(i) == 1 && S(i+1) == 3) ZSD = [ZSD,Z(i+1)]; end
  if (S(i) == 2 && S(i+1) == 1) ZUS = [ZUS,Z(i+1)]; end
  if (S(i) == 2 && S(i+1) == 3) ZUD = [ZUD,Z(i+1)]; end
  if (S(i) == 3 && S(i+1) == 1) ZDS = [ZDS,Z(i+1)]; end
  if (S(i) == 3 && S(i+1) == 2) ZDU = [ZDU,Z(i+1)]; end
end
NSU = hist(ZSU,Zhist); NSD = hist(ZSD,Zhist); NUS = hist(ZUS,Zhist);
NUD = hist(ZUD,Zhist); NDS = hist(ZDS,Zhist); NDU = hist(ZDU,Zhist);

%% DATA 2: Time spent at each bin
zS = []; zU = []; zD = []; 
TimeS = zeros(Nbins,1); TimeU = zeros(Nbins,1); TimeD = zeros(Nbins,1);
for i=1:length(Zdetail)-1
  %if mod(i,10000)==0 fprintf(1,'\n\n\nTIME = %1.0f, ',i); end
  [c index] = min(abs(Zhist-Zdetail(i)));
  if Sdetail(i) == 1 
    zS = [zS,Zdetail(i)]; 
    TimeS(index) = TimeS(index) + Tdetail(i+1) - Tdetail(i);
  end
  if Sdetail(i) == 2 
    zU = [zU,Zdetail(i)]; 
    TimeU(index) = TimeU(index) + Tdetail(i+1) - Tdetail(i);
  end
  if Sdetail(i) == 3 
    zD = [zD,Zdetail(i)]; 
    TimeD(index) = TimeD(index) + Tdetail(i+1) - Tdetail(i);
  end
end


