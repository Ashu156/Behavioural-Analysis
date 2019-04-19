function[] = define_grid

global NbinsT NbinsX NbinsY NbinsA
global Xmin Xmax Ymin Ymax Xhist Yhist Ahist Thist Tmax dt dphi
global omega

Xmin = -10; Xmax = 30;
Ymin = -10; Ymax = 10;
NbinsX = 21; Xhist = linspace(Xmin,Xmax,NbinsX+1); Xhist = (Xhist(1:end-1)+Xhist(2:end))/2;
NbinsY = 21; Yhist = linspace(Ymin,Ymax,NbinsY+1); Yhist = (Yhist(1:end-1)+Yhist(2:end))/2;
NbinsA = 21; Ahist = linspace(0,2*pi,NbinsA+1); Ahist = (Ahist(1:end-1)+Ahist(2:end))/2;
dphi = 2*pi/(NbinsA-1);
dt = dphi/(2*omega);
NbinsT = ceil(Tmax/dt);
Thist = linspace(0,Tmax,NbinsT+1);