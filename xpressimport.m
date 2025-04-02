%Written by C.M. Magazzeni to import Express nanoindentation data from the
%KLA Tencor G200 nanoindenter.
% CMM 2020

[fullres, fullresloc]=load_gridV2(filepath, filename,batchinfo,batchdims); %Loading all the data from the sheet.
plot_fig; %plotting results
mcreate;  %create a script for handy plotting in the results folder
%% Save all workspace to .mat file in the results folder
save([fullfile(resultsdir,[filename(1:length(filename)-4) '_Express_results']) '.mat']);

close all

disp 'Express Import Complete'
