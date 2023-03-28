%--------------------------------------------------------------------------
% Pipeline to analyse DF/F activity for GAD67 project
%--------------------------------------------------------------------------
%
% >>> REQUIRED THIRD-PARTY CODES >>>
%   -   abfload (F. Collman). https://github.com/fcollman/abfload


%--------------------------------------------------------------------------
% Marco Bocchio, updated 2/2/22
%--------------------------------------------------------------------------

%% Load data

resultsPath = 'E:\GAD67 results\Recordings\';
fileName = 'gadcre1_uncued_deep1_160506_1';
load ([resultsPath fileName])

if ~exist('d1','var')
    d1 = 201;
    d2 = 201;
end



%% Load and trim ABF

imagingCh = 1; %imaging channel in abf file
mvmCh = 3;     %locomotion channel in abf file (old:4, current:3)

[~, mvmTrimmed, fs_abf, si_abf] = loadMvm(traces.all,imagingCh,mvmCh,'traces');

fileName_mvm=strcat(fileName,'_mvm.mat');
save(fileName_mvm,'fileName', 'mvmTrimmed','fs_abf','si_abf','si_img','-v7.3');
clear fileName_mvm


%% Define movement and rest epochs and align them calcium traces
clear plottingOptions; % options for plotting the raster
plottingOptions.cellColour = nCells.int; % cells to highlight in binned spike raster
plottingOptions.epochs.epochs2 = 'mvm'; % highlight movement in raster

[mvmEpochsLogic, mvmEpochsIndex, mvmOnsetIndex, mvmOffsetIndex, restEpochsLogic, restEpochsIndex, time] = defMvmEpochs (mvmTrimmed,traces.all,si_abf,si_img,1000,200,plottingOptions,'traces'); % old analysis: spanthreshold_2 = 200 ms; new: 1000s

if exist('fileName') == 0
    fileName = input('Type filename:','s');
end

% remove pre-movement period (10 frames) from rest periods (avoid
% contamination for SCE and assembly analysis)
for mvmIndexCounter = 1:length(mvmOnsetIndex)
preMvmIndexTemp = mvmOnsetIndex(mvmIndexCounter)-10:mvmOnsetIndex(mvmIndexCounter)-1;
    if mvmIndexCounter == 1
        preMvmIndex = preMvmIndexTemp;
    else
        preMvmIndex = [preMvmIndex preMvmIndexTemp];
    end
end

clear preMvmIndexTemp

restEpochsOrigLogic = restEpochsLogic; % save a copy of original rest time points
restEpochsOrigIndex = restEpochsIndex;

restEpochsLogic(preMvmIndex)=[]; % remove pre-movement periods from rest
restEpochsIndex = find (restEpochsLogic == 1);

% Save in current experiment directory
fileName_mvmEpochs=strcat(fileName,'_mvmEpochs.mat');
save(fileName_mvmEpochs,'fileName', 'mvmEpochsLogic','mvmEpochsIndex','mvmOnsetIndex','mvmOffsetIndex', 'restEpochsLogic', 'restEpochsIndex','si_img','time','-v7.3');
%clear fileName_mvmEpochs mvmTrimmed fs_abf si_abf;

% Save in global results directory
mvm.mvmEpochsIndex = mvmEpochsIndex;
mvm.mvmEpochsLogic = mvmEpochsLogic;
mvm.mvmOffsetIndex = mvmOffsetIndex;
mvm.mvmOnsetIndex = mvmOnsetIndex;
mvm.restEpochsIndex = restEpochsIndex;
mvm.restEpochsLogic = restEpochsLogic;

clear mvmIndexCounter prMvmIndex mvmEpochsIndex mvmEpochsLogic mvmOffsetIndex mvmOnsetIndex restEpochsIndex restEpochsLogic fs_abf imagingCh ~imagingTrimmed mvmCh mvmTrimmed

save([resultsPath fileName])



