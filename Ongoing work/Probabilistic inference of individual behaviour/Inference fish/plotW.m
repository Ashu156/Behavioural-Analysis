function[] = plotW(fg,a,Whist)
%% plots the inferred rates of the D-marginal

figure(fg); clf;
mrk = 4; lw = 2;

subplot(1,3,1); hold on; set(gca,'fontsize',18); box on
plot(Whist,exp(a(1,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0,0,0.5]); %% Decay -> Left
plot(Whist,exp(a(2,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0,0]); %% Decay -> Left
xlabel('Wall distance (bl)')
ylabel('Transition rate')
title('Passive to Left/Right')
xlim([min(Whist),max(Whist)])
ylim([0,10])

subplot(1,3,2); hold on; set(gca,'fontsize',18); box on
plot(Whist,exp(a(3,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0.5,0.5]); %% Left -> Decay
plot(Whist,exp(a(4,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0,0]); %% Left -> Right
xlabel('Wall distance (bl)')
ylabel('Transition rate')
title('Left to Passive/Right')
xlim([min(Whist),max(Whist)])
ylim([0,10])

subplot(1,3,3); hold on; set(gca,'fontsize',18); box on
plot(Whist,exp(a(5,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0.5,0.5]); %% Left -> Decay
plot(Whist,exp(a(6,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0,0,0.5]); %% Left -> Right
xlabel('Wall distance (bl)')
ylabel('Transition rate')
title('Right to Passive/Left')
xlim([min(Whist),max(Whist)])
ylim([0,10])

