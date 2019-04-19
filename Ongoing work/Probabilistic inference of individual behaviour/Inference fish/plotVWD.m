function[] = plotVWD(fg,row,a,Vhist,Whist,Dhist,Windex)
%% plots the jointly-dependent rates on V, W and D

global DATA
global Vmax Dmax 
global redef

figure(fg); %clf;
mrk = 4; lw = 2; dm = length(Whist);


pl = [1,2,3,4];
indx = [1,2,3,5];
indtit = [1,4,2,3];
titl = {'Transitions P->L' 'Transitions L->P' 'Transitions R->P' 'Transitions P->R' 'Transitions L->R' 'Transitions R->L' 'Time P' 'Time L' 'Time R'};
xlbl = {'Velocity (bl/s)','Wall distance (bl)','Mutual distance (bl)'};
ylbl = {'Transition rate','Time'};


if redef == 0
    c1 = 5; c2 = 15;
elseif redef == 1
    c1 = 5; c2 = 15;
elseif redef == 2
    c1 = 5; c2 = 15;
else
    c1 = 5; c2 = 15;
end
    
%% set wall distance constant - it does not influence things anyways
for i=1:4
    subplot(dm,4,4*(row-1) + pl(i)); hold on; set(gca,'fontsize',18); box on
    M = reshape(exp(a(indx(i),:,Windex,:)),length(Vhist),length(Dhist));
    M1 = [M,zeros(length(Vhist),1)];
    M2 = [M1',zeros(length(Dhist)+1,1)]';
    
    Dhist1 = [2*Dhist(1)-Dhist(2),Dhist(1:end-1)];
    Dhist2 = (Dhist+Dhist1)/2;
    
    Vhist1 = [2*Vhist(1)-Vhist(2),Vhist(1:end-1)];
    Vhist2 = (Vhist+Vhist1)/2;
    
    Dmax = 4; Vmax = 8;
    pcolor([Dhist2,Dmax],[Vhist2,Vmax],M2); %% Decay -> Left
    
    ColorDef = Col; colormap(ColorDef);
    colorbar; 
    ylim([Vhist2(1),Vhist(end)+1/2*(Vhist(end)-Vhist(end-1))]); 
    xlim([Dhist2(1),Dhist(end)+1/2*(Dhist(end)-Dhist(end-1))])
    ylabel('Velocity (bl/s)')
    xlabel('Mutual distance (bl)')
    title(titl(indtit(i)))
    
    ax1 = gca;
    xTick = Dhist;
    set(ax1, 'XTick', xTick)
    yTick = [1,3,5,7];
    set(ax1, 'YTick', yTick)
    caxis([0,c1])
end

subplot(dm,4,4*(row-1)+3); caxis([0,c2]) 
subplot(dm,4,4*(row-1)+4); caxis([0,c2]) 