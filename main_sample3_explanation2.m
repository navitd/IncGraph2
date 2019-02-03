%% initially I read only 3 parameters per review: asin, avg. score and date
% data from http://jmcauley.ucsd.edu/data/amazon/
% there are 1,689,188 reviews
% reading Amazon data and saving cell with asin, Score and Time
clear all
close all

FileName='Electronics_5.txt';
fid = fopen(FileName, 'r');

% for i = 1:3
%     Rv = fgets(fid)
% end
maxBlocks    = 1,689,188;        % Number of reviews is given
countRv = zeros(7050,1);         % number of items 
ERT       = cell( maxBlocks, 3);
item       = 0;
Keya = '"asin": ';
KeyS = '"overall": ';
KeyD = '"unixReviewTime": ';
previd = 'a';
iid=0;

while ~feof(fid)
   item = item+1;
   singleRv = fgets(fid);  %all infromation about a single review
   if ~ischar(singleRv)
      break;
   end
   %% reading Review asin
   Indexasin = strfind( singleRv, Keya )+length(Keya)+1;
   asinstr = singleRv(Indexasin:Indexasin+9);
   ERT{item,1}=asinstr;
   %% reading Review date and score
   IndexS = strfind( singleRv, KeyS )+length(KeyS);
   score = str2num(singleRv(IndexS:IndexS+3));
   ERT{item,2} = score;
   
   IndexD = strfind( singleRv, KeyD )+length(KeyD);
   chi=0;
   Dstr='';
   ch=singleRv(IndexD);
   while ch~=','
        chi=chi+1;
        Dstr=strcat(Dstr,ch);
        ch = singleRv(IndexD+chi);
   end
   ERT{item,3} = str2num(Dstr);
   %% how many Reviews per item?
   id = asinstr;
   if strcmp(id,previd)
       countRv(iid) = countRv(iid)+1;
   else
       iid=iid+1;
       countRv(iid) = countRv(iid)+1;
   end
   previd = id;
end
Nitem=length(countRv);
fclose(fid); 
%save ElectronicRT

%% within item check
[itemCell] = buildItemCell(ERT,countRv);
%%%%%%%%%%%
%%%%%%%%%%%
s0 = 4;         % choose subgroup around s0 
deltas = 1;   
sa = s0-deltas;  
sb = s0+deltas;
%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%
hdip = -1.5;      % define dip
w=20;

%% statistics of occurances
gCell=cell(Nitem,2);
Sall = [];
rowIngCell = 1;
for item = 1:Nitem
    %what is average score?
    if itemCell{item,4}>=sa & itemCell{item,4}<sb
        gCell(rowIngCell,1) = itemCell(item,1);
        ZeroMeanS = cell2mat( itemCell(item,2) ) - cell2mat( itemCell(item,4) );
        gCell{rowIngCell,2}(:) = ZeroMeanS;
        % column 2 is zero-mean score
        Sall = cat(1,Sall,ZeroMeanS);
        rowIngCell = rowIngCell+1;
    end
end

Ning = rowIngCell-1;
dipix = cell(Ning,1);
countdip=1;
for item = 1:Ning
    rv = cell2mat(gCell(item,2));
    ix = find(rv<=hdip);
    dipix{item,1} = ix;
    if ~isempty(ix) & ix(end)+w<=length(rv)
        for iii = 1:length(ix)
            dip(countdip,1) = item;
            dip(countdip,2) = ix(iii);
            wS1(countdip) = mean( rv( ix(iii):ix(iii)+w ));
            countdip = countdip+1;
        end
    end
end
Ndip = length(wS1);



%% Histogram analysis
Nhistbin = 30;
mark = floor(Nhistbin/3);
Nhistitr=1;

edgess1 = linspace(min(wS1),max(wS1),Nhistbin);
edgesgen = edgess1;
[counts1,inds1] = histc(wS1,edgess1);
counts1norm = counts1/sum(counts1);    %area under graph normalized to 1
redarea  = counts1norm(1:mark)*(edgess1(2:mark+1)'-edgess1(1:mark)');
NIdip1   = sum(counts1(1:mark));
for itr = 1:Nhistitr
    [bmean] = meanBootStrap(w,Sall,10^5); % mean in shuffled window
    [countgen,indgen] = histc(bmean,edgesgen);
    countgennorm = countgen/sum(countgen); %area under graph normalized to 
    %% blue area under line smaller than mark
    bluearea(itr) = countgennorm(1:mark)*(edgesgen(2:mark+1)'-edgesgen(1:mark)');
    rat(itr)      = bluearea(itr)/redarea;
end 
area_ratio = mean(rat)
std_area_ratio = std(rat)


%% plotting histogram
figure(fig), fig = fig+1;
plot(edgesgen+s0,countgennorm,'o-','LineWidth',1.4), hold all 
plot(edgess1+s0,counts1norm,'o-','LineWidth',1.4)
legend('general (shuffled)','High Impact Reviews')
hold off
title(['Histogram of mean score in window, w=',num2str(w)])
xlabel('Score')
ylabel('Frequency')
set(gca,'FontSize',14)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                end of Graph1 analysis                             % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% read text again: this time with all reviews detail
FileName='Electronics_5.txt';
fid = fopen(FileName, 'r');
Nrvtot = 1689188;   % Number of reviews are given
%chunkLen = 100000;
ERT       = cell(Nrvtot,7); %cell( Nrvtot, 7);
item       = 0;
Keya       = '"asin": ';
KeyD       = '"unixReviewTime": ';
KeyS       = '"overall": ';
KeyH       = '"helpful": [';
KeyPID     = '"reviewerID": ';
KeyPname   = '"reviewerName": ';
KeySummary = '"summary": '; 
KeyRt      = '"reviewText": ';
flagbrack  = 0;
previd     = 'a';
iid=0;

for item = 1:Nrvtot
    tic
   %item = item+1;
   singleRv = fgets(fid);  %all infromation about a single review
   if ~ischar(singleRv)
      break;
   end
   %% reading Review asin
   Indexasin = strfind( singleRv, Keya )+length(Keya)+1;
   asinstr = singleRv(Indexasin:Indexasin+9);
   ERT{item,1}=asinstr;
   %% Reading review Date
   [Dstr] = ReadUntilch(singleRv,KeyD,',');
   ERT{item,2} = str2num(Dstr);
   %% reading Review score
   IndexS = strfind( singleRv, KeyS )+length(KeyS);
   score = str2num(singleRv(IndexS:IndexS+3));
   ERT{item,3} = score;
   %% reading Review helpfulness
   [Hstr] = ReadUntilch(singleRv,KeyH,']');
   Hstr = ['[',Hstr,']'];
   ERT{item,4} = str2num(Hstr);
   %% reading Reviewer ID and Name
   [PIDstr] = ReadUntilch(singleRv,KeyPID,',');
   ERT{item,5}=PIDstr;
   [Pnamestr] = ReadUntilch(singleRv,KeyPname,',');
   ERT{item,5}=Pnamestr;
   %% reading Review summary
   %read until " if character befor eis not \
   [Summarystr] = ReadUntilBrack(singleRv,KeySummary,flagbrack);
   ERT{item,6}=Summarystr;
   [Rtstr] = ReadUntilBrack(singleRv,KeyRt,flagbrack);
   ERT{item,7}=Rtstr;
   timeRed(item) = toc;
   if mod(item,100000)==0
       item
   end
end
fclose(fid); 

Nchunk = 500000;
ERT500_1 = ERT(1:chunk,:);
ERT500_2 = ERT(chunk+1:2*chunk,:);
ERT500_3 = ERT(2*chunk+1:3*chunk,:);
ERT500_4 = ERT(3*chunk+1:Nrvtot,:);
save ERT500_1 ERT500_1
save ERT500_2 ERT500_2
save ERT500_3 ERT500_3
save ERT500_4 ERT500_4







%% build gERT from the ERTn - all parameters - of only a subgroup
subgroup: number of reviews >100

filename = ['../Electronics4/ERTn500_1' 
            '../Electronics4/ERTn500_2'
            '../Electronics4/ERTn500_3'
            '../Electronics4/ERTn500_4'];
gERT = cell(2679,9);
Nchunk = [500000, 500000, 500000,189188];
nrv0=100;
gitem = 1;
for chunk = 1:4
    load(filename(chunk,:))
    for item = 1:Nchunk(chunk)
        if eval(['ERT500_',num2str(chunk),'{item,8} >= nrv0'])
            eval(['gERT(gitem,:) = ERT500_',num2str(chunk),'(item,:);']);
            gitem = gitem+1;
        end
    end
    eval(['clear ERT500_',num2str(chunk)])
end
save gERT



%% plotting Graph2A
%gERT is a cell with all reviews data
% contains only reviews with numbre of reviews >100
%% features of left (high impact), middle and right groups

Nwords = 12;
features = zeros(Nwords+4,3);

load ixindip_redleft   %indices of the left group: high impact group
load ixindip_redright  %indices of dip with medium window score
load ixindip_redmiddle %indices of dip with high windwo score
Nleft             = length(ixindip_redleft);
Nmiddle           = length(ixindip_redmiddle);
Nright            = length(ixindip_redright);
ixsamp_middle     = ixindip_redmiddle( ceil( rand(Nleft,1)*Nmiddle) );
ixsamp_right      = ixindip_redright( ceil( rand(Nleft,1)*Nright) );

comb = [ixindip_redleft,ixsamp_middle,ixsamp_right];
Tsize=100;
[Rt,T100Allsamp, BagAllsamp, idx, textlen, tokdocAllsamp, s, helpfulness, ...
         lengthSummary, lengthReview, exclam] = WordFreq_doc2(comb,7,Tsize,gERT,diprowIngERT);
features(1,:) = [mean(s(1:Nleft)),mean(s(Nleft+1:2*Nleft)),mean(s(2*Nleft+1:3*Nleft))];
features(2,:) = [mean(helpfulness(1:Nleft)),mean(helpfulness(Nleft+1:2*Nleft)),mean(helpfulness(2*Nleft+1:3*Nleft))];
features(3,:) = [mean(textlen(1:Nleft)),mean(textlen(Nleft+1:2*Nleft)),mean(textlen(2*Nleft+1:3*Nleft))];
features(4,:) = [mean(exclam(1:Nleft)),mean(exclam(Nleft+1:2*Nleft)),mean(exclam(2*Nleft+1:3*Nleft))];
features(3,:) = features(3,:)/features(3,1); % normalize text length

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
 % mean of features (scores and word frequancy)
 col_ix = [col_ixl',col_ixm',col_ixr'];
for i = 1:Nwords
    str_lCell{i} = words(i);
    features(i+4,1) = mean(ml(:,col_ix(i)));
    features(i+4,2) = mean(mm(:,col_ix(i)));
    features(i+4,3) = mean(mr(:,col_ix(i)));
end

labels= cell(Nwords+4,1);
labels{1} = 'Score';
labels{2} = 'Helpfulness';
labels{3} = 'Text length';
labels{4} = '"!" frequncy';
labels(5:end) = str_lCell;
present_vec = 1:Nwords+4;
close all
figure(1)
bar( features(present_vec,:) )

xticks(present_vec)
xticklabels(labels(present_vec))
legend('Blue: high impact reveiws','red: average window score is moderate',...
    'yello: average windwo score is high')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     start functions                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     functions for Graph1                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%

function [itemCell] = buildItemCell(ERT,countRv);
% building item cell similar to r100, but
% each row is a different item.
% Electronics: 2679 items

asinVec = string(ERT(:,1));
asinVec_u = unique(asinVec);
countRv2 = countRv;
clear countRv
countRv=countRv2(1:length(asinVec_u)); %deleting zeros at the end

nrv0 = 100;    % limiting data to reviews with at least nrv0 reviews

%% part A: choose subgroup r100
r100ix_u = find( countRv >= nrv0 ); % these are r100 subgroup indices in countRv

%% calculating place of item in ERT Cell:
rowInB1(1)=1;
for i = 1:length(countRv)
    rowInB1(i+1) = sum(countRv(1:i))+1; %first row of this item in ERT
end

%% build itemCell
Nitem = length(r100ix_u); 
itemCell = cell(Nitem,4);
for i = 1:Nitem
    Bix1 = rowInB1( r100ix_u(i) ); %this is the row of the r100ix_u
    Bix2 = Bix1+countRv(r100ix_u(i))-1;
    itemCell(i,1) = ERT( Bix1, 1 );
    
    rvS = cell2mat( ERT( Bix1:Bix2, 2) ); % Score within item
    rvD = cell2mat( ERT( Bix1:Bix2, 3) ); % Date within item
    [rvDsort,rvDorder]=sort(rvD); %Get the order of rvD
    rvSsort=rvS(rvDorder);
    itemCell(i,2) = num2cell( rvSsort,1 );
    itemCell(i,3) = num2cell( rvDsort,1 );
    sv=cell2mat( ERT( Bix1:Bix2, 2 ) );
    itemCell{i,4} = mean(sv);
end



function [bmean] = meanBootStrap(w,vec,Nitr)
% not [bootstrapmean] = meanBootStrap(w,vec,Nitr)
%w=20;
%Nitr = length(ixdip1);
%vec = pSall;

for i = 1:Nitr
    ix = ceil(rand(w,1)*length(vec)); %rand vec
    bmean(i) = mean(vec(ix));
end








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     functions for Graph12                         % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%  

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
        rrv_gERT = row+order(review)-1;
        break
    end
end




function [Rt,T, Bag, idx, textlen, tokdoc, s, helpfulness, ...
         lengthSummary, lengthReview, exclam] = WordFreq_doc2(comb,col,Tsize,gERT,diprowIngERT);
% comb is indices in dip to be analysed
% col is the column in gERT to be analysed
ERTalldip = gERT(diprowIngERT,:);
%% collect scoare, helpfullness, text length before cleaning
[s,helpfulness,lengthSummary,lengthReview,exclam] = buildx(comb,ERTalldip);

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
tokdoc = normalizeWords(Rt); 
Bag = bagOfWords(tokdoc);
Bag = removeInfrequentWords(Bag,2);
[Bag,idx] = removeEmptyDocuments(Bag);
T = topkwords(Bag,Tsize);


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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5%%%%%%%
% short script to save vector converting from dip to gERT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

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