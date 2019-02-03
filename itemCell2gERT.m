
function [rrv_gERT] = itemCell2gERT(ixinItemCell, rvinItemCell,itemCell,gERT);
%convert indices from itemCell (where each row is a different item
% to gERT where each row is a different review
review=rvinItemCell; 
asin1 = string( itemCell( ixinItemCell,1));
for row = 1:length(gERT)
    asin2 = string(gERT(row,1));
    if strcmp(asin1,asin2)
        r1gERT(ixinItemCell) = row;
        order = itemCell{ixinItemCell,6};
        %Dates(order(review)) = D(1);
        %place = order(review)
        rrv_gERT = row+order(review)-1;
        break
    end
end
