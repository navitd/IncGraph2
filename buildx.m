function [s,helpfulness,lengthSummary,lengthReview,exclam] = buildx(comb,ERT);
%comb is an indices vector, specifying indices in dip vec.
% ERT is ERTalldip - all dip incidents from  diprowIngERT
%therefore ERT(ixindip_redleft) is ixindip_redleft ->diprowIngERT->
N1 = length(comb);
s=zeros(N1,1);
helpfulness= zeros(N1,1);
lengthSummary = zeros(N1,1);
lengthReview = zeros(N1,1);
exclam = zeros(N1,1);
for icomb = 1:N1
    review = comb(icomb);
    s(icomb) = cell2mat( ERT(review,3) );
    if ERT{review,4}(2)~=0
        helpfulness(icomb) =  ERT{review,4}(1)/ERT{review,4}(2);
    else
        helpfulness(icomb) = 0;
    end
    lengthSummary(icomb) = numel(char(string( ERT(review,6))));
    lengthReview(icomb) = numel(char(string( ERT(review,7))));
    exclam(icomb) = numel( find( char(string( ERT(review,7)))=='!') );
end
