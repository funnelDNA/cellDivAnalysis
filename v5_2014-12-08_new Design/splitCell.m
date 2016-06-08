function [ cells, results ] = splitCell( results, kthFrame, cells, kthCell, newE )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
for ii = length(cells)+1:-1:kthCell+1
    cells(ii) = cells(ii-1);
end
km1thCell = cells(kthCell).mLink;
c1 = results(kthFrame).cells;
for ii = km1thCell+1:length(c1)
    c1(ii).dLink = c1(ii).dLink + 1;
end
c1(km1thCell).dLink = [c1(km1thCell).dLink c1(km1thCell).dLink(end)+1];
results(kthFrame).cells = c1;
cells(kthCell).cellE = newE-1;
cells(kthCell+1).cellS = newE;
end

