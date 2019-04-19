%% Inference for the coarse-grained model, assuming the internal parameters omega aRT are known
%[SUML,a] = inferenceRT_CG2(omega,gamma);

global NbinsX NbinsY NbinsA
global a omega aLR gamma 
global ii jj kk
global Aexact SUML

addpath('~/Documents/MATLAB/minFunc_2012')
addpath('~/Documents/MATLAB/minFunc_2012')
addpath('~/Documents/MATLAB/minFunc_2012/minFunc')
addpath('~/Documents/MATLAB/minFunc_2012/minFunc/compiled')
addpath('~/Documents/MATLAB/minFunc_2012/minFunc/mex')

maxFunEvals = 2000;    
options.MaxIter = 2000;
options = [];
options.GradObj = 'on';
options.Display = 'off';%'iter';
options.useMex = 0;
options.maxFunEvals = maxFunEvals;
options.Method = 'lbfgs';

%omega = 100; gamma = 1;
a = zeros(2,NbinsX,NbinsY,NbinsA);

%figure(4); hold on; lw=2;
%plot(phi,reshape(Time(2,round(NbinsX/2),round(NbinsY/2),:),1,NbinsA),'linewidth',lw,'color',[0.7,0,0])
%fprintf(1,'\nTime occupancy in the TUMBLE state computed!',ind)

SUML = 0;
for ii=1:NbinsX
    fprintf(1,'%d, ',ii)
    for jj=1:NbinsY
        for kk=1:NbinsA
            a2 = minFunc(@likelihoodRT_CG, ones(1,2)', options);
            %a2 = minFunc(@likelihoodRT_CG, [Aexact(ii,jj,kk),Aexact(ii,jj,kk)]', options);
            a(1,ii,jj,kk) = a2(1);  a(2,ii,jj,kk) = a2(2);
            [l,lg] = likelihoodRT_CG(a2);
            SUML = SUML + l;
        end
    end
end
fprintf(1,'\nInferrence completed...')
