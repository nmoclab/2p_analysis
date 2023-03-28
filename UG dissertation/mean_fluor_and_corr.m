%% Calculate mean fluorescence values

% Whole recording
mean_fluor.tot.all = mean(mean(traces.all,2)); % All cells
mean_fluor.tot.pyr = mean(mean(traces.pyr,2)); % Pyramidal cells
mean_fluor.tot.int = mean(mean(traces.int,2)); % Interneurons

save([resultsPath fileName]);


%% Calculate pairwise correlations

% Whole recording pyramidal cells
[pair_corr.tot.pyr, pair_corr.tot.pyr_all] = pairwise_corr (traces.all,nCells.pyr,nCells.pyr);

% Whole recording interneurons
[pair_corr.tot.int, pair_corr.tot.int_all] = pairwise_corr (traces.all,nCells.int,nCells.int);

% Whole recording pyr-int
[pair_corr.tot.pyr_int, pair_corr.tot.pyr_int_all] = pairwise_corr (traces.all,nCells.pyr,nCells.int);

save([resultsPath fileName]);
