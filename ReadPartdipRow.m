
%clear all
%load gCell
%load EitemCell
%load gERT
%load dip
%load partdiprow
N=6308;
for countdip = 6308;
    ixing = dip(countdip,1);
    ixinItemCell = gCell{ixing,3};
    review = dip(countdip,2);
    
    [rrv_gERT] = itemCell2gERT(ixinItemCell, review,itemCell,gERT);
    diprowIngERT(countdip) = rrv_gERT;
end
%DateitemCell = itemCell{1,3}(3)
%DategERT = gERT{rrv_gERT,2}
save part3diprowIngERT diprowIngERT
