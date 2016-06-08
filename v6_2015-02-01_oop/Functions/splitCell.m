function [ output_args ] = splitCell( allFr, kthFr, kthCell, varargin )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
searchWd = 5;

cells = allFr(kthFr).cells.cells;
% update cell id
for ii = length(cells)+1:-1:kthCell+1
    cells(ii) = cells(ii-1);
end
% update kthFr - 1
km1thCell = cells(kthCell).mLink;
if ~isempty (km1thCell)
    c1 = allFr(kthFr-1).cells.cells;
    for ii = km1thCell+1:length(c1)
        c1(ii).dLink = c1(ii).dLink + 1;
    end
    if 1%km1thCell+1 <= length(c1) && c1(km1thCell+1).dLink == kthCell
        %c1(km1thCell(1)).dLink = [c1(km1thCell).dLink c1(km1thCell).dLink(end)+1];
        %c1(km1thCell+1).dLink = [c1(km1thCell+1).dLink+1];
    else
        c1(km1thCell).dLink = [c1(km1thCell).dLink c1(km1thCell).dLink(end)+1];
    end
    allFr(kthFr-1).cells.cells = c1;
end
% search newE
profile = cells(kthCell).block.profile;
midP = length(profile)/2;
[minH newE] = min(profile(midP-searchWd:midP+searchWd));
newE = (newE + midP-searchWd - 1) + cells(kthCell).block.blockS - 1;
% update kthFr, kthCell, with known newE
cells(kthCell).block.blockE = newE-1;
cells(kthCell).block.length = newE - cells(kthCell).block.blockS;
cells(kthCell).block.profile = allFr(kthFr).lineProfile(cells(kthCell).block.blockS:cells(kthCell).block.blockE);
cells(kthCell).block.body    = allFr(kthFr).channel(:,cells(kthCell).block.blockS:cells(kthCell).block.blockE);

cells(kthCell+1).block.blockS = newE;
cells(kthCell+1).block.length = cells(kthCell+1).block.blockE - cells(kthCell+1).block.blockS + 1;
cells(kthCell+1).block.profile = allFr(kthFr).lineProfile(cells(kthCell+1).block.blockS:cells(kthCell+1).block.blockE);
cells(kthCell+1).block.body    = allFr(kthFr).channel(:,cells(kthCell+1).block.blockS:cells(kthCell+1).block.blockE);
% update kthFr + 1
switch length(cells(kthCell).dLink)
    case 2
        cells(kthCell+1).dLink = cells(kthCell).dLink(2);
        cells(kthCell).dLink(2) = [];
        allFr(kthFr+1).cells.cells(cells(kthCell+1).dLink).mLink = kthCell + 1;
    case 1
        disp('illegal split!');
        cells(kthCell+1).dLink = cells(kthCell).dLink;
        %allFr(kthFr+1).cells.cells(cells(kthCell+1).dLink).mLink = [kthCell kthCell + 1];
end


allFr(kthFr).cells.cells = cells;



end

