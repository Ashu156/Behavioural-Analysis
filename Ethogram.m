close all;
clear all;
clc;

%% Loading the dataEvents file in  MATLAB
rawDataEvents =readtable('C:\Users\Dell\Downloads\events_behaviour.csv');
rawDataEvents = rawDataEvents(16:45,1:3); % limiting to dataEvents of interest, i.e., excluding the headers here
dataEvents = table2cell(rawDataEvents); % converting the table information into a cell array
chrEventTimes = char(dataEvents(:,1)); % time information as a string array
eventTimes = str2num(chrEventTimes); % converting string into numbers 
state = strcat(dataEvents(:,2),{''},dataEvents(:,3)); % creating all combinations of behavioural states
allStates = unique(state);          % basis vector of behavioural states

%% 
nrowsFinalMatrix = length(state);  % number of rows in the final matrix
nColsFinalMatrix = length(allStates); % number of columns in the final matrix

finalMatrix = zeros(nrowsFinalMatrix, nColsFinalMatrix); % initiating the final matrix as a zeros matrix

colors = {'g', 'y', 'r', 'b', 'k'}; % color codes for different behavioural states
figure('Color', [1 1 1]);

% Assigning START and STOP eventTimes to respective columns of the final matrix for all the distinct behvaioural states

for i = 1:length(state)
    token = state{i}; % gives the first behavioural state found
    switch (token) % for details see switch documentation
        
         case char(allStates(1)) % state: START grooming (1st column of final matrix)
        if regexp(token, char(allStates(1)), 'ignorecase')
            fprintf('Hmm\n')
            chrEventTimes = dataEvents{i,1};
            finalMatrix(i,1) = str2num(chrEventTimes);
            groomingStart(1,i) = str2num(chrEventTimes);
            [~, idx] = find(groomingStart);
            groomingStart = groomingStart(idx);
        end
        
        case char(allStates(2)) % state: STOP grooming (2nd column of final matrix)
        if regexp(token, char(allStates(2)), 'ignorecase')
            fprintf('Oh\n')
            chrEventTimes = dataEvents{i,1};
            finalMatrix(i,2) = str2num(chrEventTimes);
            groomingStop(1,i) = str2num(chrEventTimes);
            [~, idx] = find(groomingStop);
            groomingStop = groomingStop(idx);
            end
       
             for i = 1:length(groomingStart)
        plot([groomingStart(i) groomingStop(i)], [1 1], strcat(colors{1},'-'),'linew',25); hold on;
        end
        
        case char(allStates(3)) % state: LED ON (3rd column of final matrix)
            if regexp(token, char(allStates(3)),'ignorecase')
                fprintf('Well Done\n')
            chrEventTimes = dataEvents{i,1};
             finalMatrix(i,3) = str2num(chrEventTimes);
            LEDon(1,i) = str2num(chrEventTimes);
            [~, idx] = find(LEDon);
            LEDon = LEDon(idx);
            end
            
            for i = 1:length(LEDon)
        plot([LEDon(i) LEDon(i)], [1 1], strcat(colors{2},'-'),'linew',25);
        end
            
            case char(allStates(4)) % state: START exploration in cage (1st column of final matrix)
                if regexp(token, char(allStates(4)), 'ignorecase')
            fprintf('Excellent\n')
            chrEventTimes = dataEvents{i,1};
             finalMatrix(i,4) = str2num(chrEventTimes);
            explorationStop(1,i) = str2num(chrEventTimes);
            [~, idx] = find(explorationStop);
            explorationStop = explorationStop(idx);
            end
        
        case char(allStates(5)) % state: STOP exploration in cage (1st column of final matrix)
        if regexp(token, char(allStates(5)),'ignorecase')
            fprintf('Good\n')
            chrEventTimes = dataEvents{i,1};
             finalMatrix(i,5) = str2num(chrEventTimes);
           explorationStart(1,i) = str2num(chrEventTimes);
            [~, idx] = find(explorationStart);
            explorationStart = explorationStart(idx);
        end
        
        for i = 1:length(explorationStart)
        plot([explorationStart(i) explorationStop(i)], [1 1], strcat(colors{3},'-'),'linew',25);
        end
        
        case char(allStates(6)) % state: START halt/stop (1st column of final matrix)
        if regexp(token, char(allStates(6)), 'ignorecase')
            fprintf('Wow\n')
            chrEventTimes = dataEvents{i,1};
             finalMatrix(i,6) = str2num(chrEventTimes);
            haltStart(1,i) = str2num(chrEventTimes);
            [~, idx] = find(haltStart);
            haltStart = haltStart(idx);
        end
        
        case char(allStates(7)) % state: STOP halt/stop (1st column of final matrix)
        if regexp(token, char(allStates(7)), 'ignorecase')
            fprintf('Noob\n')
            chrEventTimes = dataEvents{i,1};
             finalMatrix(i,7) = str2num(chrEventTimes);
            haltStop(1,i) = str2num(chrEventTimes);
            [~, idx] = find(haltStop);
            haltStop = haltStop(idx);
        end
        
        for i = 1:length(haltStart)
        plot([haltStart(i) haltStop(i)], [1 1], strcat(colors{4},'-'),'linew',25); 
        end
        
        case char(allStates(8)) % state: START walking (1st column of final matrix)
        if regexp(token, char(allStates(8)), 'ignorecase')
            fprintf('Nice\n')
            chrEventTimes = dataEvents{i,1};
             finalMatrix(i,8) = str2num(chrEventTimes);
            walkingStart(1,i) = str2num(chrEventTimes);
            [~, idx] = find(walkingStart);
            walkingStart = walkingStart(idx);
        end
        
         case char(allStates(9)) % state: STOP walking (1st column of final matrix)
        if regexp(token, char(allStates(9)), 'ignorecase')
            fprintf('Nice\n')
            chrEventTimes = dataEvents{i,1};
             finalMatrix(i,9) = str2num(chrEventTimes);
            walkingStop(1,i) = str2num(chrEventTimes);
            [~, idx] = find(walkingStop);
            walkingStop = walkingStop(idx);
        end
        
        for i = 1:length(walkingStart)
        plot([walkingStart(i) walkingStop(i)], [1 1], strcat(colors{5},'-'),'linew',25); 
        end
        
    end
    
        
end



%% end of code

    