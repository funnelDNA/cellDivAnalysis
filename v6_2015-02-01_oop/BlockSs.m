classdef BlockSs% < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        blockSs
        stitchedLine
        peakHeightMin = 150; % 300 for B subtilis
    end
    
    methods
        function BL = BlockSs(cellType)
            switch cellType
                case 'B'
                    BL.peakHeightMin = 300; % 800 for B.Subtilis
                case 'C'
                    BL.peakHeightMin = 150; % 800 for B.Subtilis
                otherwise
                    fprintf ('unknown cell type!');
                    pause;
            end
        end
        function BS = StitchBlocks (BS)
            cells = BS.blockSs;
            line = [];
            for ii = 1:length(cells)
                if cells(ii).isSkip == 0
                    cells(ii).block.stitchS = length(line)+1;
                    line = [line smooth(cells(ii).block.profile,5)'];
                end
            end
            BS.stitchedLine = line;
            BS.blockSs = cells;            
        end
    end    
end

