% p_lineprofilesimple
% makes a line profile from user selected points
% cmm


%variables
thingtoplot=H;
linethickness=10;

subplot(2,1,1);
hplot=contourf(X,Y,thingtoplot,45,'LineColor','None');
title('Normalised Hardness nanoindentation map"');
%with title above

xlabel('\mum')
ylabel('\mum')
axis image
caxis([4 10])
c=colorbar;
c.Label.String = 'Hardness /GPa';
axis on;
hold on;
[x_og,y_og] = getpts; clearvars x_idx y_idx
plot(x_og, y_og, 'b+-', 'LineWidth', linethickness);
for i=1:size(x_og,1)
    setofinterest = abs(X - x_og(i))<=1 & abs(Y - y_og(i))<=1;%find where X is roughly equal to x_og to within some number
    if sum(setofinterest(:))==1
        [x_idx(i),y_idx(i)]=find(setofinterest==1);
    elseif sum(setofinterest(:))==0
        error('Margin is too small - increase condition')
    elseif sum(setofinterest(:))>1
        warning('Margin is too large - guessing based on first point')
        [a,b]=find(setofinterest==1);
        x_idx(i)=a(1); 
        y_idx(i)=b(1); clearvars a b
    end
end
[CX,CY,C_sum,C,xi,yi]=improfile_integrated(thingtoplot,linethickness,x_idx,y_idx,'average','array');

subplot(2,1,2);
%figure();
%plot(1:length(C),C,'.',1:length(C_sum),C_sum,'-'); Old version with arb x
yyaxis left
plot(CX,C,'.',CX,C_sum,'-');
xlabel('X distance \mum');
ylabel('Hardness /GPa');

% %UNCOMMENT to plot an extra value 
% [~,~,C_sumebsd,Cebsd,~,~]=improfile_integrated(datastack.Phireflseccorr,linethickness,x_idx,y_idx,'average','array');
% hold on
% yyaxis right
% plot(CX,Cebsd,'.',CX,C_sumebsd,'-');
% ylabel('Declination Angle \^{o}')
% hold off
% %legend - change as above
% legend({'Normalised Hardness /GPa','Normalised Hardness averaged /GPa',...
%     'EBSD Phi','EBSD Phi averaged'},'Location','Westoutside');
% %figname=['grain ' num2str(grainno) ' most'];
% %saveas(gcf,fullfile(resultsdir, figname),'png')