function[] = plot_infer_1ant(fig1,fig2)
global aS aU aD bS bU bD 
global NSU NSD NUS NUD NDS NDU 
global TimeS TimeU TimeD
global Zhist Avector

figure(fig1)
clf; hold on;
dSt = Zhist(2)-Zhist(1);
mrk = 3;

subplot(2,3,1); bar(Zhist,TimeS/(sum(TimeS)*dSt),'facecolor',[0.5,0.5,0.5]); 
ylabel('Time occupancy'); xlabel('z'); set(gca,'fontsize',19)
subplot(2,3,2); bar(Zhist,TimeD/sum(TimeD)/dSt,'facecolor','r'); xlabel('z'); set(gca,'fontsize',19)
subplot(2,3,3); bar(Zhist,TimeU/sum(TimeU)/dSt,'facecolor','b'); xlabel('z'); set(gca,'fontsize',19)

subplot(2,3,4); 
bar(Zhist,NSD/sum(NSD)/dSt,'facecolor','r'); hold on;
ylabel('Number of transitions'); xlabel('z'); set(gca,'fontsize',19)
bar(Zhist,NSU/sum(NSU)/dSt,'facecolor','b');
subplot(2,3,5); 
bar(Zhist,NDS/sum(NDS)/dSt,'facecolor',[0.5,0.5,0.5]); hold on;
bar(Zhist,NDU/sum(NDU)/dSt,'facecolor','b'); xlabel('z'); set(gca,'fontsize',19)
subplot(2,3,6); 
bar(Zhist,NUS/sum(NUS)/dSt,'facecolor',[0.5,0.5,0.5]); hold on;
bar(Zhist,NUD/sum(NUD)/dSt,'facecolor','r'); xlabel('z'); set(gca,'fontsize',19)



figure(fig2)
set(gca,'fontsize',19)
clf; hold on;
subplot(1,3,1);
  plot([-4:0.05:4],exp(aS(1)+bS(1)*[-4:0.05:4]),'--k','linewidth',2,'color',[0.5,0.5,0.5]); hold on;
  plot(Zhist,min(exp(Avector(:,1)),5),'o','markersize',mrk,'linewidth',2,'color','r'); 
  plot(Zhist,min(exp(Avector(:,2)),5),'o','markersize',mrk,'linewidth',2,'color','b');
   xlabel('z'); ylabel('\lambda(S->D,U)')
   ylim([0,2]); xlim([-4,4]);set(gca,'fontsize',19)
subplot(1,3,3);
  plot([-4:0.05:4],exp(aU(1)+bU(1)*[-4:0.05:4]),':k','linewidth',2,'color','b'); hold on;
  plot(Zhist,exp(Avector(:,3)),'o','markersize',mrk,'linewidth',2,'color',[0.5,0.5,0.5]);
  plot(Zhist,exp(Avector(:,4)),'o','markersize',mrk,'linewidth',2,'color','r');
  ylim([0,5]); xlim([-4,4]); xlabel('z'); ylabel('\lambda(U->S,D)'); set(gca,'fontsize',19)
subplot(1,3,2);
  plot([-4:0.05:4],exp(aD(1)+bD(1)*[-4:0.05:4]),'k','linewidth',2,'color','r'); hold on;
  plot(Zhist,exp(Avector(:,5)),'o','markersize',mrk,'linewidth',2,'color',[0.5,0.5,0.5]); hold on;
  plot(Zhist,exp(Avector(:,6)),'o','markersize',mrk,'linewidth',2,'color','b');
  ylim([0,5]); xlim([-4,4]); xlabel('z'); ylabel('\lambda(D->S,U)'); set(gca,'fontsize',19)
  
