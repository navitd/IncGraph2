
clear all
close all

Tsize=1000;

load ixindip_redleft
comb = ixindip_redleft;
[T, Bag, textlen, tokdoc, s, helpfulness, ...
         lengthSummary, lengthReview, exclam] = WordFreq_doc2(comb,7,Tsize);     
%figure(1)
%wordcloud(Bag)
%title('red left group') 
save T1000left T Bag tokdoc textlen s helpfulness lengthSummary lengthReview exclam

clear all
Tsize=1000;

load ixindip_redmiddle
comb = ixindip_redmiddle;
[T, Bag, textlen, tokdoc, s, helpfulness, ...
         lengthSummary, lengthReview,exclam] = WordFreq_doc2(comb,7,Tsize);     
%figure(3)
%wordcloud(Bag)
%title('red middle group') 
save T1000middle T Bag tokdoc textlen s helpfulness lengthSummary lengthReview exclam



clear all
Tsize=1000;

load ixindip_redright
comb = ixindip_redright;
[T, Bag, textlen, tokdoc, s, helpfulness, ...
         lengthSummary, lengthReview,exclam] = WordFreq_doc2(comb,7,Tsize);     
%figure(2)
%wordcloud(Bag)
%title('red right group') 
save T1000right T Bag tokdoc textlen s helpfulness lengthSummary lengthReview exclam
