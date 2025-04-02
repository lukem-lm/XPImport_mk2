%% Fix spacing. 
function [X,Y,H,M,S,S2oL,L,HnM,D,fullres, fullresloc]=z_fixspacing(fullres, fullresloc)
% Code to interp the fullres values themselves when I've messed up the
% indent spacing. 


%want pixel spacing of 2um.
numpx=204;
numpy=122;
newX=linspace(0,406,numpx)'; %real extent went to 408x 244. 2um spacing means 
newY=linspace(0,242,numpy);

newX=repmat(newX,[1,numpy]);
newY=repmat(newY,[numpx,1]);

fullres1interp = griddedInterpolant(X,Y,fullres(:,:,1),'nearest');
fullres1new = fullres1interp(newX(:), newY(:));
fullres1 = gridify_vector(fullres1new,size(newX,1),size(newY,2))';

fullres2interp = griddedInterpolant(X,Y,fullres(:,:,2),'nearest');
fullres2new = fullres2interp(newX(:), newY(:));
fullres2 = gridify_vector(fullres2new,size(newX,1),size(newY,2))';

fullres3interp = griddedInterpolant(X,Y,fullres(:,:,3),'nearest');
fullres3new = fullres3interp(newX(:), newY(:));
fullres3 = gridify_vector(fullres3new,size(newX,1),size(newY,2))';

fullres4interp = griddedInterpolant(X,Y,fullres(:,:,4),'nearest');
fullres4new = fullres4interp(newX(:), newY(:));
fullres4 = gridify_vector(fullres4new,size(newX,1),size(newY,2))';

fullres5interp = griddedInterpolant(X,Y,fullres(:,:,5),'nearest');
fullres5new = fullres5interp(newX(:), newY(:));
fullres5 = gridify_vector(fullres5new,size(newX,1),size(newY,2))';

fullres6interp = griddedInterpolant(X,Y,fullres(:,:,6),'nearest');
fullres6new = fullres6interp(newX(:), newY(:));
fullres6 = gridify_vector(fullres6new,size(newX,1),size(newY,2))';


clearvars fullresloc fullres
fullresloc(:,:,1)=newX; %X and Y positions
fullresloc(:,:,2)=newY;
fullres(:,:,1)=fullres1;
fullres(:,:,2)=fullres2;
fullres(:,:,3)=fullres3;
fullres(:,:,4)=fullres4;
fullres(:,:,5)=fullres5;
fullres(:,:,6)=fullres6;

X=newX; %X and Y positions
Y=newY;
S=fullres(:,:,1);
D=fullres(:,:,2);
L=fullres(:,:,3);
M=fullres(:,:,4);
S2oL=fullres(:,:,5);
H=fullres(:,:,6);
HnM=H./M;

end