
clear all
close all

Nwords = 600;
features = zeros(Nwords,3);

load ixindip_redleft
load ixindip_redright
load ixindip_redmiddle
Nleft             = length(ixindip_redleft);
Nmiddle           = length(ixindip_redmiddle);
Nright            = length(ixindip_redright);
ixsamp_middle     = ixindip_redmiddle( ceil( rand(Nleft,1)*Nmiddle) );
ixsamp_right      = ixindip_redright( ceil( rand(Nleft,1)*Nright) );

comb = [ixindip_redleft,ixsamp_middle,ixsamp_right];
Tsize=100;
[Rt,T100Allsamp, BagAllsamp, idx, textlen, tokdocAllsamp, s, helpfulness, ...
         lengthSummary, lengthReview, exclam] = WordFreq_doc2(comb,7,Tsize);



% 
% %[~,ixl] = maxk(Mtfidf(vec_left,:),num_maxw,2);
% %str_l= vocall(ixl(:));

M = tfidf(BagAllsamp,'TFWeight','binary'); 
Mtfidf = full(M);
ml = full(M(1:223,:));    % reviews from red left group
mm = full(M(224:446,:));  % reviews from red middle group
mr = full(M(447:end,:));  % reviews from red right group

[~,ixl] = maxk(ml(:),Nwords/3);
col_ixl = ceil(ixl/size(ml,1));
words(1:Nwords/3) = BagAllsamp.Vocabulary(col_ixl);

[~,ixm] = maxk(mm(:),Nwords/3);
col_ixm = ceil(ixm/size(mm,1));
words(Nwords/3+1:2*Nwords/3) = BagAllsamp.Vocabulary(col_ixm);

[~,ixr] = maxk(mr(:),Nwords/3);
col_ixr = ceil(ixr/size(mr,1));
words(2*Nwords/3+1:Nwords) = BagAllsamp.Vocabulary(col_ixr);


%[~,ixl] = maxk(std(ml),Nwords);
%str_l = BagAllsamp.Vocabulary(ixl);

 % mean of features (scores and word frequancy)
 col_ix = [col_ixl',col_ixm',col_ixr'];
for i = 1:Nwords
    str_lCell{i} = words(i);
    features(i,1) = mean(ml(:,col_ix(i)));
    features(i,2) = mean(mm(:,col_ix(i)));
    features(i,3) = mean(mr(:,col_ix(i)));
end

I can't do bag of words
because if I count frequency in text I return to the words that are common in the text
what I need is to translate tfidf to frequency

%% make three bags of words:
words_ills = unique(words);
docCell = doc2cell(tokdocAllsamp);
text_l = [' ']; text_m = text_l;, text_r = text_l;
for i = 1:223
    for j = 1:length(docCell{i})
       text_l = [text_l,' ',char(docCell{i}(j))];%[text_l(i),' ',string(docCell{i}(j))];
    end
    for j = 1:length(docCell{i+223})
       text_m = [text_m,' ',char(docCell{i+223}(j))];
    end
    for j = 1:length(docCell{i+446})
       text_r = [text_r,' ',char(docCell{i+446}(j))];
    end
end
    
for i = 1:length(words_ills)
    freq_l(i) = count(text_l,words_ills(i));
    freq_m(i) = count(text_m,words_ills(i));
    freq_r(i) = count(text_r,words_ills(i));
end
%%
figure(1)
Bag_l = bagOfWords(words_ills,freq_l);
wordcloud(Bag_l)
figure(2)
Bag_m = bagOfWords(words_ills,freq_m);
wordcloud(Bag_m)
figure(3)
Bag_r = bagOfWords(words_ills,freq_r);
wordcloud(Bag_r)
