
%build a new gCell: 3 columns, column 3 is "item" - row in itemCell
load EitemCell
load gCell
load dip
load gERT
load dipix

countdip2 = 1;
for countdip = 1:length(dip);
    ixing = dip(countdip,1);
    ixinItemCell = gCell{ixing,3};

    for j = 1:length(dipix(countdip))
        review = dip(countdip+j-1,2);
        [rrv_gERT] = itemCell2gERT(ixinItemCell, review,itemCell,gERT);
        diprowIngERT(countdip2) = rrv_gERT;
        countdip2 = countdip2+1;
    end
end
%DateitemCell = itemCell{1,3}(3)
%DategERT = gERT{rrv_gERT,2}

save diprowIngERT diprowIngERT