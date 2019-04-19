function[] = plot_inferredN_trajectory(fg)
global aS aU aD bS bU bD beta Zhist dZhist a aexact
global ant 

pl=2;
mrk = 1;
%a=log(aexact);

figure(fg); clf
%cns1 = 15; cns2 = 100; cns3 = 20;
cns1 = 1; cns2 = 1; cns3 = 1;
subplot(pl,3,1);
    plot(Zhist,exp(aS(ant)+bS(ant)*Zhist),'linewidth',2,'color',[0.5,0.5,0.5]); hold on;
    plot(Zhist,exp(a(1,:))/cns1,'o','color','r','markersize',mrk,'linewidth',4); 
    plot(Zhist,exp(a(2,:))/cns1,'o','color','b','markersize',mrk,'linewidth',4);
    xlim([-4,4]); ylim([0,2]); xlabel('z'); ylabel('\lambda(S->D,U)')
    
subplot(pl,3,2);
    plot(Zhist,exp(aU(ant)+bU(ant)*Zhist),'linewidth',2,'color','b'); hold on;
    plot(Zhist,exp(a(3,:))/cns2,'o','color',[0.5,0.5,0.5],'markersize',mrk,'linewidth',4); 
    plot(Zhist,exp(a(4,:))/cns2,'o','color','r','markersize',mrk,'linewidth',4);
    xlim([-4,4]); ylim([0,5]); xlabel('z'); ylabel('\lambda(U->S,D)')

subplot(pl,3,3);
    plot(Zhist,exp(aD(ant)+bD(ant)*Zhist),'linewidth',2,'color','r'); hold on;
    plot(Zhist,exp(a(5,:))/cns3,'o','color',[0.5,0.5,0.5],'markersize',mrk,'linewidth',4);
    plot(Zhist,exp(a(6,:))/cns3,'o','color','b','markersize',mrk,'linewidth',4);
    xlim([-4,4]); ylim([0,5]); xlabel('z'); ylabel('\lambda(D->S,U)')

subplot(pl,3,4);
    plot(dZhist,exp(beta(ant)*exp(-dZhist.^2)),'linewidth',2,'color',[0.5,0.5,0.5]);  hold on;
    plot(dZhist,cns1*exp(a(7,:)),'o','color','r','markersize',mrk,'linewidth',4);
    plot(dZhist,cns1*exp(a(8,:)),'o','color','b','markersize',mrk,'linewidth',4);
    xlim([-4,4]); ylim([0,2]);
    %ylim([0,2]); xlabel('dz'); ylabel('\beta(S->D,U)')
   
subplot(pl,3,5);
    plot(dZhist,exp(beta(ant)*exp(-dZhist.^2)),'linewidth',2,'color','b');  hold on;
    plot(dZhist,cns2*exp(a(9,:)),'o','color',[0.5,0.5,0.5],'markersize',mrk,'linewidth',4);
    plot(dZhist,cns2*exp(a(10,:)),'o','color','r','markersize',mrk,'linewidth',4);
    xlim([-4,4]); ylim([0,2]);
    %ylim([0,2]); xlabel('dz'); ylabel('\beta(U->S,D)')
  
subplot(pl,3,6);
    plot(dZhist,exp(beta(ant)*exp(-dZhist.^2)),'k','linewidth',2,'color','r');hold on;
    plot(dZhist,cns3*exp(a(11,:)),'o','color',[0.5,0.5,0.5],'markersize',mrk,'linewidth',4); 
    plot(dZhist,cns3*exp(a(12,:)),'o','color','b','markersize',mrk,'linewidth',4);
    xlim([-4,4]); ylim([0,2]);
    %ylim([0,2]); xlabel('dz'); ylabel('\beta(D->S,U)')

