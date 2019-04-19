function[] = plotV(fg,a,Vhist)
%% plots the inferred rates of the V-marginal

global DATA
figure(fg); clf;

mrk = 4; lw = 2;

subplot(1,3,1); hold on; set(gca,'fontsize',18); box on
plot(Vhist,exp(a(1,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0,0,0.5]); %% Decay -> Left
plot(Vhist,exp(a(2,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0,0]); %% Decay -> Left
xlabel('Velocity (bl/s)')
ylabel('Transition rate')
title('Passive to Left/Right')
ylim([0,10])

subplot(1,3,2); hold on; set(gca,'fontsize',18); box on
plot(Vhist,exp(a(3,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0.5,0.5]); %% Left -> Decay
plot(Vhist,exp(a(4,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0,0]); %% Left -> Right
xlabel('Velocity (bl/s)')
ylabel('Transition rate')
title('Left to Passive/Right')
ylim([0,20])

subplot(1,3,3); hold on; set(gca,'fontsize',18); box on
plot(Vhist,exp(a(5,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0.5,0.5,0.5]); %% Left -> Decay
plot(Vhist,exp(a(6,:)),'o-','markersize',mrk,'linewidth',lw,'color',[0,0,0.5]); %% Left -> Right
xlabel('Velocity (bl/s)')
ylabel('Transition rate')
title('Right to Passive/Left')
ylim([0,20])

