close all; clc;

plot(pb1,pb2,'o','MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 0],'MarkerSize',10)
hold on
plot([-1 1],[-1,1],'-k','linew',2)
coef_fit = polyfit(hab,pb2,1);  % Linear fit
y_fit = polyval(coef_fit,xlim); % Linear fit
plot(xlim,y_fit,'-.r','linew',3) % plotting the linear fit
set(gcf,'Color',[1 1 1]);
set(gca,'XTick',[-1.5:0.5:1.5],'YTick',[-1.5:0.5:1.5]);
% title('Control hab vs pb1'); 
xlim([-1.5 1.5]); ylim([-1.5 1.5]);
hold on
plot([-1.5 1.5],[-1 -1], '-g')
plot([-1 -1],[-1.5 1.5], '-r')