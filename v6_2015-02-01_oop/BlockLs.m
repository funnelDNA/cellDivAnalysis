classdef BlockLs% < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        blockLs
        stitchedLine
        peakHeightMin = 350; % 800 for B.Subtilis
    end
    
    methods
        function BL = BlockLs(cellType)
            switch cellType
                case 'B'
                    BL.peakHeightMin = 900; % 800 for B.Subtilis
                case 'C'
                    BL.peakHeightMin = 350; % 800 for B.Subtilis
                otherwise
                    fprintf ('unknown cell type!');
                    pause;
            end
        end
        %function stitch_cells (results, kthFrame, varargin)
        function BL = StitchBlocks (BL)
            cells = BL.blockLs;
            line = [];
            lineP = [];
            channel = [];
            for ii = 1:length(cells)
                %results(kthFrame).cells(ii).sS = length(line)+1;
                if cells(ii).isSkip == 0
                    cells(ii).block.stitchS = length(line)+1;
                    line = [line smooth(cells(ii).block.profile,5)'];
                end                
                %lineP = [lineP cells(ii).newS:cells(ii).newE];
                %channel = [channel results(kthFrame).channel(:,cells(ii).newS:cells(ii).newE)];
            end
            %results(kthFrame).cells = cells;
%             results(kthFrame).stitchedLine = line;
%             results(kthFrame).stitchedCh = channel;
%             results(kthFrame).stitchedLine_Loc = lineP;
            BL.stitchedLine = line;
            BL.blockLs = cells;            
        end
    end    
end

