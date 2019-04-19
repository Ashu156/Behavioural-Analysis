function[] = plot_inferredCG(a,shift)
%% this plots the inferred parameters

%clear;
global NbinsX NbinsY NbinsA 
global Xhist Yhist Ahist 
global omega aLR arun aLrun ag alphastar
global Aexact


crossX = 10;%round(NbinsX/2);
crossY = 10;%round(NbinsY/2);
crossA = 10;%round(NbinsA/2);
for s=1:2
    if s==1
        m=-1; M=5;
    else
        m=-1; M=5;
    end
    %% compute exact rates (1) run -> tumble and (2) tumble -> run
    Aexact = zeros(NbinsX,NbinsY,NbinsA);
    for i=1:NbinsX
        for j=1:NbinsY
            for k=1:NbinsA
                if s==1
                    Aexact(i,j,k) = arun + ag*(1 + cos( Ahist(k) -pi - alphastar));
                else
                    Aexact(i,j,k) = aLrun;% + ag*(1 + cos( Ahist(k) - alphastar));;
                end
            end
        end
    end
    
    figure(s+shift); clf %% plots RUN->LEFT transition rates for the cross-section in the middle
    subplot(3,2,1)
    set(gca,'fontsize',16)
    h = pcolor(Ahist,Yhist,reshape(a(s,crossX,:,:),[NbinsY,NbinsA])); colorbar; 
    caxis([m,M])
    %set(h,'EdgeColor','none')
    ylabel('y-coordinate'); xlabel('angle-coordinate')
    
    if s==1 
        title('run -> tumble (approximation)')
    else
        title('tumble -> run (approximation)')
    end
    
    subplot(3,2,2)
    set(gca,'fontsize',16)
    h = pcolor(Ahist,Yhist,reshape(Aexact(crossX,:,:),[NbinsY,NbinsA])); colorbar; 
    caxis([m,M])
    %set(h,'EdgeColor','none')
    ylabel('y-coordinate'); xlabel('angle-coordinate')

    subplot(3,2,3)
    set(gca,'fontsize',16)
    h = pcolor(Ahist,Xhist,reshape(a(s,:,crossY,:),[NbinsX,NbinsA])); colorbar; 
    caxis([m,M])
    %set(h,'EdgeColor','none')
    ylabel('x-coordinate'); xlabel('angle-coordinate')

    subplot(3,2,4)
    set(gca,'fontsize',16)
    h = pcolor(Ahist,Xhist,reshape(Aexact(:,crossY,:),[NbinsX,NbinsA])); colorbar; 
    caxis([m,M])
    %set(h,'EdgeColor','none')
    ylabel('x-coordinate'); xlabel('angle-coordinate')

    subplot(3,2,5)
    set(gca,'fontsize',16)
    h = pcolor(Yhist,Xhist,reshape(a(s,:,:,crossA),[NbinsX,NbinsY])); colorbar; 
    caxis([m,M])
    %set(h,'EdgeColor','none')
    xlabel('y-coordinate'); ylabel('x-coordinate')

    subplot(3,2,6)
    set(gca,'fontsize',16)
    h = pcolor(Yhist,Xhist,reshape(Aexact(:,:,crossA),[NbinsX,NbinsY])); colorbar; 
    caxis([m,M])
    %set(h,'EdgeColor','none')
    xlabel('y-coordinate'); ylabel('x-coordinate')
end   
    
    
