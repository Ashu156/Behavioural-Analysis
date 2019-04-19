%% Inference

global Tend Snow aS aU aD bS bU bD beta thresh Ants NbinsX NbinsY NbinsA Time a Transitions drop
global ii jj kk

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

    
    a = zeros(6,NbinsX,NbinsY,NbinsA);
    for ii=1:NbinsX
        fprintf(1,'%d, ',ii)
        for jj=1:NbinsY
            for kk=1:NbinsA
                %a = fminsearch(@(a) -likelihood_lambda(a),[1,1,1,1,1,1]);
                a2 = minFunc(@likelihoodRT1D, ones(1,6)', options);
                
                a(1,ii,jj,kk) = a2(1);  a(2,ii,jj,kk) = a2(2);
                a(3,ii,jj,kk) = a2(3);  a(4,ii,jj,kk) = a2(4);
                a(5,ii,jj,kk) = a2(5);  a(6,ii,jj,kk) = a2(6);
            end
        end
    end
    fprintf(1,'\nInferrence completed...')


%a2 = minFunc(@likelihoodRT3D, ones(1,6*NbinsX*NbinsY*NbinsA)', options);
%a = reshape(a2,6,NbinsX,NbinsY,NbinsA);

