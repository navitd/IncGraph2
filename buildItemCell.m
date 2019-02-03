% building item cell similar to r100, but
% each row is a different item.
% Electronics: 2679 items

clear all
close all

load ../Electronics3/ElectronicRT

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
itemCell = cell(Nitem,6);
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
    itemCell{i,5} = [Bix1, Bix2]; %num reviws: Bix2-Bix1+1
    itemCell{i,6} = rvDorder;
end
save EitemCell






