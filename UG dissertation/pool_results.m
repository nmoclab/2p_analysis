% Updated 17/3/2023

%% Set results path

%resultsPath = 'D:\GAD67 results\Test\';

resultsPath = 'C:\Users\mnms67\Downloads\matfiles\';
[filenames] = extract_variables ('fileName',[],resultsPath,[],[]);
[layer] = extract_variables ('layer',[],resultsPath,[],[]);

%% Extract number of cells

[pyr,int] = extract_variables ('nCells',[],resultsPath, 'pyr', 'int');
[all] = extract_variables ('nCells',[],resultsPath, 'all');

n_all = zeros(1,length(all));
n_pyr = zeros(1,length(all));
n_int = zeros(1,length(all));


for recCounter = 1:length(all)
    n_all(recCounter) = length(all{recCounter});
    n_pyr(recCounter) = length(pyr{recCounter});
    n_int(recCounter) = length(int{recCounter});
end


%% Extract mean fluorescence values

[mean_fluor_pyr,mean_fluor_int] = extract_variables ('mean_fluor','tot',resultsPath, 'pyr', 'int');
[mean_fluor_all] = extract_variables ('mean_fluor','tot',resultsPath, 'all');

mean_fluor_pyr = cell2mat(mean_fluor_pyr);
mean_fluor_int = cell2mat(mean_fluor_int);
mean_fluor_all = cell2mat(mean_fluor_all);

%% Extract pairwise correlations values

[pair_corr_pyr,pair_corr_int] = extract_variables ('pair_corr','tot',resultsPath, 'pyr', 'int');
[pair_corr_pyr_int] = extract_variables ('pair_corr','tot',resultsPath, 'pyr_int');

pair_corr_pyr = cell2mat(pair_corr_pyr);
pair_corr_int = cell2mat(pair_corr_int);
pair_corr_pyr_int = cell2mat(pair_corr_pyr_int);

%% Save in csv file

T=table(filenames',layer',n_all',n_pyr',n_int',mean_fluor_pyr',mean_fluor_int',mean_fluor_all',pair_corr_pyr',pair_corr_int',pair_corr_pyr_int',...
'VariableNames',{'filename','layer','n cells','n pyr','n int','mean fluor all','mean fluor int', 'mean fluor pyr', 'pair corr all','pair corr pyr','pair corr int'});

writetable(T,[resultsPath 'results.csv'])