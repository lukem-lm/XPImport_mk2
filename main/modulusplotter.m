%% I've left some equivalents for Modulus here

figure;
hist=histogram(M(:));
title('Histogram of Modulus Measurements')
xlabel('Modulus /GPa')
xlim([0 max(M(:))]) 
ylabel('Number of Indents')
txt = {['Average Modulus: ' num2str(meanM, '%.3g') ' GPa'],['Standard Deviation: ' num2str(stdM, '%.3g') ' GPa']};
text(0.05*max(M(:)),max(hist.Values(:))*0.9,txt)
figname=['Modulus Histogram ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

figure;
scatter(M(:),H(:));
title('Modulus vs Hardness')
xlabel('Modulus /GPa')
ylabel('Hardness /GPa')
figname=['Modulus Vs Hardness ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

figure;
scatter(M(:).^2,H(:));
title('Modulus squared vs Hardness')
xlabel('Modulus squared /GPa^2')
ylabel('Hardness /GPa')
figname=['Modulus2rd Vs Hardness ' filename(1:(max(size(filename)-4)))];
saveas(gcf,fullfile(resultsdir, figname),'png')

