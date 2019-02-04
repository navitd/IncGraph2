
clear all
close all

Nwords = 12;
features = zeros(Nwords+4,3);

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
features(1,:) = [mean(s(1:Nleft)),mean(s(Nleft+1:2*Nleft)),mean(s(2*Nleft+1:3*Nleft))];
features(2,:) = [mean(helpfulness(1:Nleft)),mean(helpfulness(Nleft+1:2*Nleft)),mean(helpfulness(2*Nleft+1:3*Nleft))];
features(3,:) = [mean(textlen(1:Nleft)),mean(textlen(Nleft+1:2*Nleft)),mean(textlen(2*Nleft+1:3*Nleft))];
features(4,:) = [mean(exclam(1:Nleft)),mean(exclam(Nleft+1:2*Nleft)),mean(exclam(2*Nleft+1:3*Nleft))];

features(3,:) = features(3,:)/features(3,1);

% Mtfidf = cat(1,ml,mm);
% Mtfidf = cat(1,Mtfidf,mr);
% 
% [vec_left,vec_middle,vec_right] = group_Mtfidf(idx,ixindip_redleft,ixsamp_middle,ixsamp_right);
% vocall = BagAllsamp.Vocabulary;
% 
% num_maxw = 5;
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
    features(i+4,1) = mean(ml(:,col_ix(i)));
    features(i+4,2) = mean(mm(:,col_ix(i)));
    features(i+4,3) = mean(mr(:,col_ix(i)));
end
%%
labels= cell(Nwords+4,1);
labels{1} = 'Score';
labels{2} = 'Helpfulness';
labels{3} = 'Text length';
labels{4} = '"!" frequncy';
labels(5:end) = str_lCell;


%category_name = categorical(labels);
present_vec = 1:4;
close all
figure(1)
bar( features(present_vec,:) )
%labels1 = [{'Score'},{'Helpfulness'},{'Text Length';'(normalized)'},...
%    {'"!" frequency'}]
%xticklabels(labels1)

xticks(present_vec)
xticklabels(labels(present_vec))
%xtickangle(45)
legend('Reviews with low window-score ("sticky")','Reviews with moderate windwo-score',...
    'Reviews with high window-score')
set(gca,'FontSize',12)

%{'hello';'there'}











% coeff = pca(Mtfidf);
% 
% point1 = Mtfidf*coeff(:,1);
% point2 = Mtfidf*coeff(:,2);

%[fig] = drawPCAword_samp(fig,idx,ixindip_redleft,ixsamp_middle,ixsamp_right,point1,point2);

% % find outliers
% ixout1 = find(point1>5);
% ixout2 = find(point2>10);
% ixout = [ixout1;ixout2];
% Mtfidf_clean = Mtfidf;
% Mtfidf_clean(ixout,:) = [];
% 
% 
% smallMtfidf = Mtfidf_clean(:,1:100);
% coeff_small = pca(smallMtfidf);
% 
% point1 = smallMtfidf*coeff_small(:,1);
% point2 = smallMtfidf*coeff_small(:,2);
% point3 = smallMtfidf*coeff_small(:,3);
% 
% [fig] = drawPCA3word_samp(fig,ixout,ixindip_redleft,ixsamp_middle,...
%              ixsamp_right,point1,point2,point3);
% 
% 
% [fig] = drawPCAword_samp(fig,ixout,ixindip_redleft,ixsamp_middle,ixsamp_right,point1,point2);
