function [ output_args ] = combineCellManual( allFr, kthFr, kthCell, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% combine cells
allFr(kthFr).cells.cells(kthCell).block.blockE = allFr(kthFr).cells.cells(kthCell+1).block.blockE;
allFr(kthFr).cells.cells(kthCell).block.length = allFr(kthFr).cells.cells(kthCell).block.blockE - allFr(kthFr).cells.cells(kthCell).block.blockS + 1;
allFr(kthFr).cells.cells(kthCell).block.profile = [allFr(kthFr).cells.cells(kthCell).block.profile allFr(kthFr).cells.cells(kthCell+1).block.profile];
allFr(kthFr).cells.cells(kthCell).block.body = [allFr(kthFr).cells.cells(kthCell).block.body allFr(kthFr).cells.cells(kthCell+1).block.body];

if ~isempty (allFr(kthFr).cells.cells(kthCell+1).mLink) && ~isempty(allFr(kthFr).cells.cells(kthCell).mLink) && allFr(kthFr).cells.cells(kthCell+1).mLink(1) == allFr(kthFr).cells.cells(kthCell).mLink(1)
    startCell = allFr(kthFr).cells.cells(kthCell+1).mLink(1)+1;
    allFr(kthFr-1).cells.cells(startCell-1).dLink(end) = [];
else
    startCell = allFr(kthFr).cells.cells(kthCell+1).mLink(1);
end

for ii = startCell:length(allFr(kthFr-1).cells.cells)
    allFr(kthFr-1).cells.cells(ii).dLink = allFr(kthFr-1).cells.cells(ii).dLink - 1;
end
for ii = allFr(kthFr).cells.cells(kthCell+1).dLink:length(allFr(kthFr+1).cells.cells)
    allFr(kthFr+1).cells.cells(ii).mLink = allFr(kthFr+1).cells.cells(ii).mLink - 1;
end

allFr(kthFr).cells.cells(kthCell).mLink = unique([allFr(kthFr).cells.cells(kthCell).mLink allFr(kthFr).cells.cells(kthCell+1).mLink]);
allFr(kthFr).cells.cells(kthCell).dLink = unique([allFr(kthFr).cells.cells(kthCell).dLink allFr(kthFr).cells.cells(kthCell+1).dLink]);
allFr(kthFr).cells.cells(kthCell).lLink = unique([allFr(kthFr).cells.cells(kthCell).lLink allFr(kthFr).cells.cells(kthCell+1).lLink]);

allFr(kthFr).cells.cells(kthCell+1) = [];
end

