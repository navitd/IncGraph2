
function [Rt,T, Bag, idx, textlen, tokdoc, s, helpfulness, ...
         lengthSummary, lengthReview, exclam] = WordFreq_doc2(comb,col,Tsize);
% comb is indices in dip to be analysed
% col is the column in gERT to be analysed


load ../Electronics7/gERT
load ../Electronics7/diprowIngERT
%load    ixindip_redleft
%comb = ixindip_redleft;
%col=7;

ERTalldip = gERT(diprowIngERT,:);
%% collect scoare, helpfullness, text length before cleaning
[s,helpfulness,lengthSummary,lengthReview,exclam] = buildx(comb,ERTalldip);
x = [s, helpfulness, lengthSummary, lengthReview];

%[fig] = draw_pca(x,fig);
%% collect word frequency and number after cleaning
ERT = gERT(diprowIngERT(comb),:);
Rt = string(ERT(:,col));
Rt = lower(Rt);
Rt = tokenizedDocument(Rt);
Rt = erasePunctuation(Rt);
Rt = removeWords(Rt,stopWords);
Rt = removeShortWords(Rt,2); %removes words equal/shorter than 2
Rt = removeLongWords(Rt,15);
textlen = doclength(Rt);
%itemRt = addPartOfSpeechDetails(itemRt);
tokdoc = normalizeWords(Rt); %,'Style','lemma'); 
% words are normalized - inflections removed

Bag = bagOfWords(tokdoc);
Bag = removeInfrequentWords(Bag,2);
[Bag,idx] = removeEmptyDocuments(Bag);
%idx is the item index of the review removed

T = topkwords(Bag,Tsize);
%M=tfidf(Bag);

