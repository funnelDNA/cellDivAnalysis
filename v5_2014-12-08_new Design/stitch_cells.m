function results = stitch_cells (results, kthFrame, varargin)
if length(varargin) ~= 0
    switch varargin{1}
        case 'cells'
            cells = results(kthFrame).cells;
        case 'blockS'
            cells = results(kthFrame).blockS;
        case 'blockL'
            cells = results(kthFrame).blockL;
    end
end
    
    line = [];
    lineP = [];
    channel = [];
    for ii = 1:length(cells)
        %results(kthFrame).cells(ii).sS = length(line)+1;
        cells(ii).sS = length(line)+1;
        line = [line smooth(cells(ii).profile,5)'];
        lineP = [lineP cells(ii).newS:cells(ii).newE];
        channel = [channel results(kthFrame).channel(:,cells(ii).newS:cells(ii).newE)];
    end
    %results(kthFrame).cells = cells;
    results(kthFrame).stitchedLine = line;
    results(kthFrame).stitchedCh = channel;
    results(kthFrame).stitchedLine_Loc = lineP;
if length(varargin) ~= 0
    switch varargin{1}
        case 'cells'
            results(kthFrame).cells = cells;
        case 'blockS'
            results(kthFrame).blockS = cells;
        case 'blockL'
            results(kthFrame).blockL = cells;
    end
end
end