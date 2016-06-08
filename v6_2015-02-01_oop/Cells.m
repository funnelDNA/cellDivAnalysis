classdef Cells% < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cells
        stitchedLine
        peakHeightMin% = 500; %should be exactly the same number as in BlockLs
    end
    
    methods
        function CS = Cells(cellType)
            a = BlockLs(cellType);
            CS.peakHeightMin = a.peakHeightMin;
        end
        function CS = StitchBlocks (CS)
            cells1 = CS.cells;
            line = [];
            for ii = 1:length(cells1)
                if cells1(ii).block.isSkip == 0
                    cells1(ii).block.stitchS = length(line)+1;
                    line = [line smooth(cells1(ii).block.profile,5)'];
                end
            end
            CS.stitchedLine = line;
            CS.cells = cells1;            
        end
    end
end

