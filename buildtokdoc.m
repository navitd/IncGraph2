function [tokdoc,timedoc] = buildtokdoc(ERT,col);
tic
Rt = string(ERT(:,col));
Rt = lower(Rt);
Rt = tokenizedDocument(Rt);
%Rt = erasePunctuation(Rt);
Rt = removeWords(Rt,stopWords);
Rt = removeShortWords(Rt,2); %removes words equal/shorter than 2
Rt = removeLongWords(Rt,15);
%itemRt = addPartOfSpeechDetails(itemRt);
tokdoc = normalizeWords(Rt); %,'Style','lemma'); 
% words are normalized - inflections removed
% bag of words model
timedoc = toc