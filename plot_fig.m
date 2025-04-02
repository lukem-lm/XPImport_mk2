%plot fig - CMM script to plot out the various graphs from the data.
%The following graphs are plotted: Hardness, Modulus, Depth, Load, Surface,
%Hardness/Modulus, and some histograms of hardness.
% CMM 2020

%locations for saving
resultsdir = fullfile(filepath, [filename(1:length(filename)-4) '_Express_results']);
if isdir(resultsdir) == 0; mkdir(resultsdir); end

% Set things as individual arrays:
X = fullresloc(:,:,1); % X and Y positions
Y = fullresloc(:,:,2);
S = fullres(:,:,1);
D = fullres(:,:,2);
L = fullres(:,:,3);
M = fullres(:,:,4);
S2oL = fullres(:,:,5);
H = fullres(:,:,6);

% Set places where the location is both 0 to NaN (no data)
isdel = X == 0 & Y == 0;
X(isdel) = NaN;
Y(isdel) = NaN;
X = X - min(X(:));
Y = Y - min(Y(:));
H(isdel) = NaN;
M(isdel) = NaN;
D(isdel) = NaN;
L(isdel) = NaN;
S(isdel) = NaN;

% For hardness and modulus, some smarter ceilings
ceilingH = 1e5; % values over 10000GPa
whereHighH = H > ceilingH;
H(whereHighH) = NaN;
whereLowH = H < 0;
H(whereLowH) = NaN;
%DISCLAIMER: this is a hack, and is not supposed to be used prior to any
%statistical analysis. This is purely for visualisation purposes.
if cleanplotq == 1
    H(whereHighH) = nanmean(H(:)) + nanstd(H(:));
    if nanmean(H(:)) > nanstd(H(:))
        H(whereLowH) = nanmean(H(:)) - nanstd(H(:));
    else
        H(whereLowH) = 0;
    end
end

ceilingM = 1e3; % values over 1000GPa
whereHighM = M > ceilingM;
M(whereHighM) = NaN; % sanity values
whereLowM = M < 0;
M(whereLowM) = NaN;
if cleanplotq == 1
    M(whereHighM) = nanmean(M(:)) + nanstd(M(:));
    if nanmean(M(:)) > nanstd(M(:))
        M(whereLowM) = nanmean(M(:)) - nanstd(M(:));
    else
        M(whereLowM) = 0;
    end
end

% For the rest, do some sensible things when the instrument divides by 0
D(D > 1e300) = NaN;
L(L > 1e300) = NaN;
S(S > 1e300) = NaN;
S2oL(S2oL > 1e300) = NaN;

% Handy values
meanH = nanmean(H(:));
stdH = nanstd(H(:));
meanM = nanmean(M(:));
stdM = nanstd(M(:));

%% The plotting itself

% Hardness Plot
figure;
% CHANGE: Replace NaN values in H with 0 for plotting
H_plot = H;
H_plot(isnan(H_plot)) = 0;
hplot = contourf(X, Y, H_plot, 1000, 'LineColor', 'None'); % Reduced contour levels for better performance
if meanH > stdH
    caxis([meanH - 1.5 * stdH, meanH + 5 * stdH]); %changed from 1.5 to 4 and 5
else
    caxis([min(H_plot(:)), meanH + 1 * stdH]);
end

%Varied to jet colour from default
colormap(jet); 
colorbar;

title('Nanoindentation Map');
xlabel('\mum');
ylabel('\mum');
axis image;
c = colorbar;
c.Label.String = 'Hardness (GPa)';
figname = ['Hardness Figure ' filename(1:(max(size(filename) - 4)))];
print(fullfile(resultsdir, figname), '-dpng', resolution);

% Modulus Plot
figure;
% CHANGE: Replace NaN values in M with 0 for plotting
M_plot = M;
M_plot(isnan(M_plot)) = 0;
hplot = contourf(X, Y, M_plot, 1000, 'LineColor', 'None'); % Reduced contour levels
if meanM > stdM
    caxis([meanM - 1.5 * stdM, meanM + 5 * stdM]);%changed from 1.5 to 5 and 5
else
    caxis([min(M_plot(:)), meanM + 1 * stdM]);
end

%Varied to jet colour from default
colormap(jet); 
colorbar;

title('Modulus');
xlabel('\mum');
ylabel('\mum');
axis image;
c = colorbar;
c.Label.String = 'Modulus (GPa)';
figname = ['Modulus Figure ' filename(1:(max(size(filename) - 4)))];
print(fullfile(resultsdir, figname), '-dpng', resolution);

% Depth Plot
figure;
% CHANGE: Replace NaN values in D with 0 for plotting
D_plot = D;
D_plot(isnan(D_plot)) = 0;
hplot = contourf(X, Y, D_plot, 20, 'LineColor', 'None'); % Reduced contour levels

%Varied to jet colour from default
colormap(jet); 
colorbar;

title('Indentation Depth');
xlabel('\mum');
ylabel('\mum');
axis image;
c = colorbar;
c.Label.String = 'Depth (nm)';
figname = ['Depth Figure ' filename(1:(max(size(filename) - 4)))];
print(fullfile(resultsdir, figname), '-dpng', resolution);

%Load Plot
figure;
L_plot = L;
L_plot(isnan(L_plot)) = 0;
hplot = contourf(X, Y, L_plot, 20, 'LineColor', 'None');


%Varying colour to jet
colormap(jet);
colorbar;

title('Indentation Load', 'FontSize', 14);
xlabel('\mum', 'FontSize', 12);
ylabel('\mum', 'FontSize', 12);
axis image;

% Calculate mean and standard deviation of L_plot
data_mean = mean(L_plot(:), 'omitnan'); % Mean, ignoring NaN values
data_std = std(L_plot(:), 'omitnan');   % Standard deviation, ignoring NaN values

% Set axis limits to mean ± 1 standard deviation
xlim([data_mean - data_std, data_mean + data_std]);
ylim([data_mean - data_std, data_mean + data_std]);

% Set colorbar limits to mean ± 1 standard deviation
caxis([data_mean - data_std, data_mean + data_std]);

% Add grid
grid on;

% Colorbar label
c = colorbar;
c.Label.String = 'Load (mN)';
c.Label.FontSize = 12;

% Save figure
figname = ['Load Figure ' filename(1:(max(size(filename) - 4)))];
print(fullfile(resultsdir, figname), '-dpng', resolution);

% Surface Displacement Plot
figure;
% CHANGE: Replace NaN values in S with 0 for plotting
S_plot = S;
S_plot(isnan(S_plot)) = 0;
hplot = contourf(X, Y, S_plot, 20, 'LineColor', 'None'); % Reduced contour levels

%Varied to jet colour from default
colormap(jet); 
colorbar;

title('Surface Displacement Plot');
xlabel('\mum');
ylabel('\mum');
axis image;
c = colorbar;
c.Label.String = 'Tip Position (nm)';
figname = ['SurfaceDisp Figure ' filename(1:(max(size(filename) - 4)))];
print(fullfile(resultsdir, figname), '-dpng', resolution);

% Stiffness Squared over Load Plot
figure;
% CHANGE: Replace NaN values in S2oL with 0 for plotting
S2oL_plot = S2oL;
S2oL_plot(isnan(S2oL_plot)) = 0;
hplot = contourf(X, Y, S2oL_plot, 20, 'LineColor', 'None'); % Reduced contour levels

%Varied to jet colour from default
colormap(jet); 
colorbar;


title('Stiffness Squared over Load Plot');
xlabel('\mum');
ylabel('\mum');
axis image;
c = colorbar;
c.Label.String = 'Stiffness ^{2} / Load(N/m)';
figname = ['S2oL Figure ' filename(1:(max(size(filename) - 4)))];
print(fullfile(resultsdir, figname), '-dpng', resolution);

% Hardness over Modulus Plot
HnM = H ./ M;
figure;
% CHANGE: Replace NaN values in HnM with 0 for plotting
HnM_plot = HnM;
HnM_plot(isnan(HnM_plot)) = 0;
hplot = contourf(X, Y, HnM_plot, 20, 'LineColor', 'None'); % Reduced contour levels

%Varied to jet colour from default
colormap(jet); 
colorbar;


title('Hardness divided by Modulus');
xlabel('\mum');
ylabel('\mum');
axis image;
if nanmean(HnM_plot(:)) > nanstd(HnM_plot(:))
    caxis([nanmean(HnM_plot(:)) - 2 * nanstd(HnM_plot(:)), nanmean(HnM_plot(:)) + 2 * nanstd(HnM_plot(:))]);
else
    caxis([min(HnM_plot(:)), nanmean(HnM_plot(:)) + 2 * nanstd(HnM_plot(:))]);
end
c = colorbar;
c.Label.String = 'Hardness/Modulus';
figname = ['HardnessOVMod ' filename(1:(max(size(filename) - 4)))];
print(fullfile(resultsdir, figname), '-dpng', resolution);

%% HISTOGRAMS
% Hardness Histogram
figure;
hist = histogram(H(:));
title('Histogram of Hardness Measurements');
xlabel('Hardness /GPa');
xlim([0 max(H(:))]);
ylabel('Number of Indents');
txt = {['Average Hardness: ' num2str(meanH, '%.3g') ' GPa'], ['Standard Deviation: ' num2str(stdH, '%.3g') ' GPa']};
text(0.05 * max(H(:)), max(hist.Values(:)) * 0.9, txt);
figname = ['Hardness Histogram ' filename(1:(max(size(filename) - 4)))];
print(fullfile(resultsdir, figname), '-dpng', resolution);

% Close-up of the Hardness Histogram
figure;
hist = histogram(H(:));
title('Close Up Histogram of Hardness Measurements');
xlabel('Hardness /GPa');
if meanH > stdH
    xlim([meanH - 2 * stdH, meanH + 2 * stdH]);
else
    xlim([0, meanH + 2 * stdH]);
end
ylabel('Number of Indents');
figname = ['Zoom Hardness Histogram ' filename(1:(max(size(filename) - 4)))];
print(fullfile(resultsdir, figname), '-dpng', resolution);

% Modulus Histogram
figure;
hist = histogram(M(:));
title('Histogram of Modulus Measurements');
xlabel('Modulus /GPa');
xlim([0 max(M(:))]);
ylabel('Number of Indents');
txt = {['Average Modulus: ' num2str(meanM, '%.3g') ' GPa'], ['Standard Deviation: ' num2str(stdM, '%.3g') ' GPa']};
text(0.05 * max(M(:)), max(hist.Values(:)) * 0.9, txt);
figname = ['Modulus Histogram ' filename(1:(max(size(filename) - 4)))];
print(fullfile(resultsdir, figname), '-dpng', resolution);

close all;