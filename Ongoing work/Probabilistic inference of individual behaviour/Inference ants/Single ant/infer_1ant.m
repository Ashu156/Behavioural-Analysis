function[] = infer_1ant
global Nbins Zhist Avector
global infer

%-----------> If necessary, manually include the paths
addpath('~/Documents/MATLAB/minFunc_2012')
addpath('~/Documents/MATLAB/minFunc_2012')
addpath('~/Documents/MATLAB/minFunc_2012/minFunc')
addpath('~/Documents/MATLAB/minFunc_2012/minFunc/compiled')
addpath('~/Documents/MATLAB/minFunc_2012/minFunc/mex')

%-----------> Parameters of the inference
maxFunEvals = 1000;
options = [];
options.GradObj = 'on';
options.Display = 'iter';
options.MaxIter = 1000;
options.maxFunEvals = maxFunEvals;
options.Method = 'cg';

%% Inference using Data1 and Data2 -> each bin separately
if infer == 1
    fprintf('\n\nExample: 1 ANT \nMethod: independent inference for each bin\n');
    fprintf('Result after %d evaluations of limited-memory solvers on likelihood \nNumber of unknowns: 6 \nNumber of bins: %d',maxFunEvals,Nbins);
    fprintf('\nalpha = 0 (starting point)\n');
    fprintf('---------------------------------------\n');

    Avector = [];
    for i=1:length(Zhist)
        ibar = i;
        a = fminsearch(@(a) -likelihood(a),[1,1,1,0,1,-1]);
        Avector = [Avector; a];
    end
    fprintf(1,'\nInferrence completed...')
end

%% Inference using Data1 and Data2 -> simultaneous optimization through all bins to check if the answer is consistent with the simplification
if infer == 2
    fprintf('\n\nExample: 1 ANT \nMethod: simultaneous inference\n');
    fprintf('Result after %d evaluations of limited-memory solvers on likelihood \nNumber of unknowns: 6*(Nbins+1) \nNumber of bins: %d',maxFunEvals,Nbins);
    fprintf('\nalpha = 0 (starting point)\n');
    fprintf('---------------------------------------\n');

    
    [a,f,exitflag,output] = minFunc(@likelihood_simult, ones(1,6*Nbins)', options);
    Avector = [a(1:Nbins), a(Nbins+1:2*Nbins), a(2*Nbins+1:3*Nbins), a(3*Nbins+1:4*Nbins), a(4*Nbins+1:5*Nbins), a(5*Nbins+1:6*Nbins)];
    fprintf(1,'\nInferrence completed...')
end
