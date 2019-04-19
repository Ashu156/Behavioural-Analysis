function[] = plotD(fg,a,Dhist)
%% plots the inferred rates of the D-marginal

global DATA
figure(fg); clf;

mrk = 4; lw = 2;


subplot(1,3,1); hold on; set(gca,'fontsize',18); box on
plot(Dhist,exp(a(1,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0,0,0.5]); %% Decay -> Left
plot(Dhist,exp(a(2,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0,0]); %% Decay -> Left
xlabel('Mutual distance (bl)')
ylabel('Transition rate')
title('Passive to Left/Right')
ylim([0,10]); xlim([min(Dhist),max(Dhist)])

subplot(1,3,2); hold on; set(gca,'fontsize',18); box on
plot(Dhist,exp(a(3,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0.5,0.5]); %% Left -> Decay
plot(Dhist,exp(a(4,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0,0]); %% Left -> Right
xlabel('Mutual distance (bl)')
ylabel('Transition rate')
title('Left to Passive/Right')
ylim([0,10]); xlim([min(Dhist),max(Dhist)])

subplot(1,3,3); hold on; set(gca,'fontsize',18); box on
plot(Dhist,exp(a(5,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0.5,0.5]); %% Left -> Decay
plot(Dhist,exp(a(6,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0,0,0.5]); %% Left -> Right
xlabel('Mutual distance (bl)')
ylabel('Transition rate')
title('Right to Passive/Left')
ylim([0,10]); xlim([min(Dhist),max(Dhist)])

