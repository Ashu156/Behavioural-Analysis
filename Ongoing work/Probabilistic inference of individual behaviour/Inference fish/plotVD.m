function[] = plotVD(fg,a,Vhist,Dhist)
%% plots the jointly-dependent rates on V and W

figure(fg); clf
mrk = 4; lw = 2; 

pl = [1,2,3,4];
indx = [1,2,3,5];
indtit = [1,4,2,3];
titl = {'Transitions P->L' 'Transitions L->P' 'Transitions R->P' 'Transitions P->R' 'Transitions L->R' 'Transitions R->L' 'Time P' 'Time L' 'Time R'};
xlbl = {'Velocity (bl/s)','Wall distance (bl)','Mutual distance (bl)'};
ylbl = {'Transition rate','Time'};


for i=1:4
    subplot(1,4,i); hold on; set(gca,'fontsize',18); box on
    M = reshape(exp(a(indx(i),:,:)),length(Vhist),length(Dhist));
    M1 = [M,zeros(length(Vhist),1)];
    M2 = [M1',zeros(length(Dhist)+1,1)]';
    
    Dhist1 = [2*Dhist(1)-Dhist(2),Dhist(1:end-1)];
    Dhist2 = (Dhist+Dhist1)/2;
    
    Vhist1 = [2*Vhist(1)-Vhist(2),Vhist(1:end-1)];
    Vhist2 = (Vhist+Vhist1)/2;
    
    pcolor([Dhist2,20],[Vhist2,20],M2); %% Decay -> Left
    
    ColorDef = Col; colormap(ColorDef);
    colorbar; 
    ylim([Vhist2(1),Vhist(end)+1/2*(Vhist(end)-Vhist(end-1))]); 
    xlim([Dhist2(1),Dhist(end)+1/2*(Dhist(end)-Dhist(end-1))])
    ylabel('Velocity (bl/s)')
    xlabel('Mutual distance (bl)')
    title(titl(indtit(i)))
    
end    
    
