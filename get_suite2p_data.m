%% Set metadata

resultsPath = 'D:\GAD67 results\Test\';

fileName = 'mb062_deep1_201014';
mouse = 'mb062';
belt = 'uncued';
layer = 'deep';
fov_code = 'deep1';
sr_img = 8; %sampling rate
si_img = 1/sr_img*1000; %sampling interval
date = datetime(2020,10,14);
% fov size
d1 = 200; % x axis in pixel
d2 = 200; % y axis in pixel

%% Amend red cells
disp('Check red cells in suite2p')
redcells = (find(redcell(:,1) & iscell(:,1)))-1 %python indexing
redcells_keep = sort(input('Select red cells to keep: '));

%% Get numbers and traces for interneurons and pyramidal cells
cells_ok = find(iscell(:,1));
cells_all = (1:length(iscell(:,1)))';

int = intersect(cells_ok,redcells_keep+1); %back to MATLAB indexing
%int = (redcells_keep+1)'; %back to MATLAB indexing
pyr = iscell(:,1);
pyr(int) = 0;
pyr = find(pyr);

% DF/F
% traces.int = double(F(int,:)./median(F(int,:),2));
% traces.pyr = double(F(pyr,:)./median(F(pyr,:),2));

% DF/F with neuropil subtraction
Fnorm = F-0.7.*Fneu;
traces.int = double(Fnorm(int,:)./median(Fnorm(int,:),2));
traces.pyr = double(Fnorm(pyr,:)./median(Fnorm(pyr,:),2));

%% Calculate DF/F
%get_dff
%traces.int = double(dff(int,:)./median(dff(int,:),2));
%traces.pyr = double(dff(pyr,:)./median(dff(pyr,:),2));


%% Get ROIs and centroids
for cellCounter = 1:max(cells_all)
    rois_all{1,cellCounter}(1,:) = double(stat{1,cellCounter}.xpix);
    rois_all{1,cellCounter}(2,:) = double(stat{1,cellCounter}.ypix);
    pos_all(cellCounter,1) = double(stat{1,cellCounter}.med(2));
    pos_all(cellCounter,2) = double(stat{1,cellCounter}.med(1));
end

rois.int = rois_all(int);
rois.pyr = rois_all(pyr);
clear rois_all
pos.int = pos_all(int,:);
pos.pyr = pos_all(pyr,:);
%clear pos_all

%% Rearrange arrays to have interneurons first
traces.all = [traces.int;traces.pyr];
pos.all = [pos.int;pos.pyr];
rois.all = [rois.int,rois.pyr];

nCells.all = 1:length(cells_ok);
nCells.int = 1:length(int);
nCells.pyr = length(int)+1:length(cells_ok);

%% Save arrays

% In global result directory
save([resultsPath fileName],'mouse','fileName', 'nCells' ,'traces', 'rois', 'pos', 'cells_all', 'cells_ok', 'redcell','redcells_keep', 'F', 'Fneu','si_img','mouse','belt','layer','fov_code','date','d1','d2','-v7.3')
clearvars -except fileName nCells traces rois pos cells_all cells_ok redcell redcells_keep F Fneu resultsPath si_img mouse belt layer fov_code date d1 d2




 