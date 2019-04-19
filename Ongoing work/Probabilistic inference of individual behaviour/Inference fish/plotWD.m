function[] = plotWD(fg,a,Whist,Dhist)

%% plots the jointly-dependent rates on V and W

global DATA
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
    M = reshape(exp(a(indx(i),:,:)),length(Whist),length(Dhist));
    M1 = [M,zeros(length(Whist),1)];
    M2 = [M1',zeros(length(Dhist)+1,1)]';
    
    Dhist1 = [2*Dhist(1)-Dhist(2),Dhist(1:end-1)];
    Dhist2 = (Dhist+Dhist1)/2;
    
    Whist1 = [2*Whist(1)-Whist(2),Whist(1:end-1)];
    Whist2 = (Whist+Whist1)/2;
    
    pcolor([Dhist2,20],[Whist2,20],M2); %% Decay -> Left
    
    ColorDef = Col; colormap(ColorDef);
    colorbar; 
    ylim([Whist2(1),Whist(end)+1/2*(Whist(end)-Whist(end-1))]); 
    xlim([Dhist2(1),Dhist(end)+1/2*(Dhist(end)-Dhist(end-1))])
    ylabel('Wall distance (bl)')
    xlabel('Mutual distance (bl)')
    title(titl(indtit(i)))
    
    
end    
    
