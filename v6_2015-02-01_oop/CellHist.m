classdef CellHist
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        id = 0
        frLocs = []; % [frame# cell;frame cell#;frame# cell#;...]
        mLink = []
        dLink = []
        sister = 0
        lastFrIntCh1 = 0; % first fluorescence channel
        lastFrInt = 0; % second fluorescence channel
        lastFrIntNor = 0;
        grLength = 0
        grArea = 0
        endFrPos = 0% relative
        divT = 0
        generation = -1;
        age = -1; % stalk cells
        isComplete = false;
        leftPole = -1; % -1:unknown; 0: old; 1:new
        rightPole = -1;
        cellType = -1; % -1:unknown; 0:stalk; 1:swarmer
    end
    
    methods
        
    end
    
end

