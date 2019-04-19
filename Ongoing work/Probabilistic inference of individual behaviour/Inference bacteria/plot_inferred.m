%% projections of 3D rates compared with exact rates
global NbinsX NbinsY NbinsA arun aLR aLrun omega ag a 
global Xhist Yhist Ahist
global alphastar


plotrate1=1;
for s=1:2:3
    Aexact = zeros(NbinsX,NbinsY,NbinsA);
    %Aexact = aLR*ones(NbinsX,NbinsY,NbinsA);
    for i=1:NbinsX
        for j=1:NbinsY
            for k=1:NbinsA
                if s==1
                    Aexact(i,j,k) = arun + ag*(1 + cos( Ahist(k) - pi - alphastar));
                elseif s==3
                    Aexact(i,j,k) = aLrun;
                end
            end
        end
    end
    if s==1   
        m=-1; M=5;
    else
        m=-1; M=5;
    end

    figure(s+2); clf; hold on %% plots RUN->LEFT transition rates for the cross-section in the middle
    subplot(3,2,1)
    set(gca,'fontsize',16)
    pcolor(Ahist,Yhist,reshape(a(s,11,:,:),[21,21])); colorbar; 
    caxis([m,M])
    ylabel('y-coordinate'); xlabel('angle-coordinate')
    
    if s==1 
        title('run -> tumble left')
    else
        title('tumble left -> run')
    end

    subplot(3,2,2)
    set(gca,'fontsize',16)
    pcolor(Ahist,Yhist,reshape(Aexact(11,:,:),[21,21])); colorbar; 
    caxis([m,M])
    ylabel('y-coordinate'); xlabel('angle-coordinate')

    subplot(3,2,3)
    set(gca,'fontsize',16)
    pcolor(Ahist,Xhist,reshape(a(s,:,11,:),[21,21])); colorbar; 
    caxis([m,M])
    ylabel('x-coordinate'); xlabel('angle-coordinate')

    subplot(3,2,4)
    set(gca,'fontsize',16)
    pcolor(Ahist,Xhist,reshape(Aexact(:,11,:),[21,21])); colorbar; 
    caxis([m,M])
    ylabel('x-coordinate'); xlabel('angle-coordinate')

    subplot(3,2,5)
    set(gca,'fontsize',16)
    pcolor(Yhist,Xhist,reshape(a(s,:,:,11),[21,21])); colorbar; 
    caxis([m,M])
    ylabel('y-coordinate'); xlabel('x-coordinate')

    subplot(3,2,6)
    set(gca,'fontsize',16)
    pcolor(Yhist,Xhist,reshape(Aexact(:,:,11),[21,21])); colorbar; 
    caxis([m,M])
    ylabel('y-coordinate'); xlabel('x-coordinate')
    
    
end

