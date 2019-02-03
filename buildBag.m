function [Bag,idx,timeTokenize] = buildBag(tokdoc);
tic

Bag = bagOfWords(tokdoc);
Bag = removeInfrequentWords(Bag,2);
[Bag,idx] = removeEmptyDocuments(Bag);
%idx is the item index of the review removed
timeTokenize = toc

