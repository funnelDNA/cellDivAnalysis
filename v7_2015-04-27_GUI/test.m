function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 21-Jan-2016 14:22:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)
%% set datatip mode
dcm_obj = datacursormode(gcf);
set(dcm_obj,'DisplayStyle','datatip');
%%
x = 1:100;
y = 1:100;plot(x,y);
mouseExample;
handles.allData = varargin{1};
allFr = handles.allData.allFr;
%imagesc(newIm,'ydata',((1:size(newIm,1))+channelW/2+10)/(channelW + 10)+startFr-1);
newIm = handles.allData.newIm;
newIm = [];
newIm = handles.allData.linkedIm;
handles.allData.newIm = newIm;
% for kthFrame = handles.allData.startFr:length(handles.allData.allFr)-1
%     
%     b = allFr(kthFrame);
%     
% %    c = Frame1Ch(results,kthFrame + 1);
%     c = allFr(kthFrame+1);
%     
%     d = TwoFrame1Ch;
%     d.frameNum = b.frameNum;
%     d.fr1 = b;
%     d.fr2 = c;
%     d.constructIm;
%     newIm = [newIm; b.newIm];
% end
% 




%imagesc(newIm(1:180,:));

channelW = handles.allData.channelW;
startFr  = handles.allData.startFr;
f = imagesc(newIm,'ydata',((1:size(newIm,1))+channelW/2+10)/(channelW + 10)+startFr-1);

set(gca,'fontsize',20);
set(gcf,'paperpositionmode','auto')

set(f, 'ButtonDownFcn',@buttonDownCallback)
    
% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end
% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = (handles);
end
% --- Executes on button press in TestClick.
function TestClick_Callback(hObject, eventdata, handles)
% hObject    handle to TestClick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p = get(gca,'CurrentPoint');
p = p(1,1:2);
disp(p);
disp('aa');
dcm_obj = datacursormode(gcf);
o = getCursorInfo(dcm_obj)

end
% --------------------------------------------------------------------
function uitoggletool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function uitoggletool7_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function uitoggletool7_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
print('test');
end

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)

end
% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

end
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        p = get(gca,'CurrentPoint');
        p = p(1,1:2);
        title( sprintf('(%g,%g)',p) )
        disp(p);
end


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        p = get(gca,'CurrentPoint');
        p = p(1,1:2);
        title( sprintf('(%g,%g)',p) )
        disp(p);
end

function buttonDownCallback(o,e)
        p = get(gca,'CurrentPoint');
        p = p(1,1:2);
        title( sprintf('(%g,%g)',p) )
        disp(p);
        
end


% --- Executes on button press in Split.
function Split_Callback(hObject, eventdata, handles)
% hObject    handle to Split (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get cell information
dcm_obj = datacursormode(gcf);
cursors = getCursorInfo(dcm_obj);
[ cells ] = cursor2Block( handles.allData.allFr, cursors, 'cell' );
% split cells
if isempty(cells)
    fprintf('no cell selected!\n');
    return;
end
allFr = handles.allData.allFr;
for ii = 1:size(cells,1)
    splitCell( allFr, cells(ii,1), cells(ii,2));
    d = TwoFrame1Ch;
    b = allFr(cells(ii,1)-1);
    c = allFr(cells(ii,1));
    d.frameNum = b.frameNum;
    d.fr1 = b;
    d.fr2 = c;
    d.constructIm;
    
    b = allFr(cells(ii,1));
    c = allFr(cells(ii,1)+1);
    d.frameNum = b.frameNum;
    d.fr1 = b;
    d.fr2 = c;
    d.constructIm;
    
% modify handles.children.children.CData
    ha = get(handles.figure1,'children');
    hp = get(ha(length(ha)),'children');
%     newIm = get(hp,'CData');
%     newIm((cells(ii,1)-3)*28+1:(cells(ii,1))*28,:) = [allFr(cells(ii,1)-2).newIm; allFr(cells(ii,1)-1).newIm; allFr(cells(ii,1)).newIm];
% %     for jj = 1:(cells(ii,1)+1)
% %         newIm ((jj-1)*28+1:jj*28,:) = allFr(jj).newIm;
% %     end
%     set(hp,'CData',newIm);
    
    newIm = [];
    for ii = 1:length(allFr)-1
        newIm = [newIm; allFr(ii).newIm];
    end
    newIm = [newIm; allFr(end).newCh];
    set(hp,'CData',newIm);
end
end

% --- Executes on button press in Combine.
function Combine_Callback(hObject, eventdata, handles)
% hObject    handle to Combine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in CellDieNextFr.
function CellDieNextFr_Callback(hObject, eventdata, handles)
% hObject    handle to CellDieNextFr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get cell information
dcm_obj = datacursormode(gcf);
cursors = getCursorInfo(dcm_obj);
% CellDieNextFr
allFr = handles.allData.allFr;
[ cells ] = cursor2Block( allFr, cursors(1,:), 'cell' );
kthFr = cells(1,1);
tempFr = copy(allFr(kthFr+1));

cellDieNextFr( allFr, cursors(1,:) );

while length(tempFr.cells.cells) ~= length(allFr(kthFr+1).cells.cells) && kthFr < length(allFr)-1
    fprintf('next frame changed! frame number = %d',kthFr + 1); % has to keep analyzing until the next fram is correct
    kthFr = kthFr + 1;
    tempFr = copy(allFr(kthFr+1));
    
        b = allFr(kthFr);
        c = allFr(kthFr+1);
        c.cells.cells = [];
        for ii = 1:length(c.blockLs.blockLs)
            c.blockLs.blockLs(ii).cLink = [];
        end
        d = TwoFrame1Ch;
        d.frameNum = b.frameNum;
        d.fr1 = b;
        d.fr2 = c;
        d.ProfileAlign;
        d.BlockAlign;
        while d.CellTransfer == 1 % triple split
            c.cells.cells = [];
            c.blockSs.blockSs = [];
            c.SearchBlock('BlockS');
            c.blockSs = c.blockSs.StitchBlocks();
            for kthBlock = 1:length(c.blockLs.blockLs)
                c.blockLs.blockLs(kthBlock).sLink = [];
                c.blockLs.blockLs(kthBlock).kp1sLink = [];
                c.blockLs.blockLs(kthBlock).cLink = [];
            end
            
            c.blockLs = c.blockLs.StitchBlocks();
            c.ProfileAlign();
            c.BlockAlign();
            d.fr2 = c;
            d.ProfileAlign;
            d.BlockAlign;
%             d.CellTransfer;
        end
        d.constructIm;
        %figure(f1); imagesc([b.newIm; c.newCh]);
        allFr(kthFr+1) = c;
end

%

for ii = 1:length(allFr(kthFr+1).cells.cells)
    allFr(kthFr+1).cells.cells(ii).dLink = tempFr.cells.cells(ii).dLink;
end    

% modify handles.children.children.CData
    ii = 1;
    ha = get(handles.figure1,'children');
    hp = get(ha(length(ha)),'children');
%     newIm = get(hp,'CData');
%     newIm((cells(ii,1)-3)*28+1:(cells(ii,1))*28,:) = [allFr(cells(ii,1)-2).newIm; allFr(cells(ii,1)-1).newIm; allFr(cells(ii,1)).newIm];

    newIm = [];
    for ii = 1:length(allFr)-1
        newIm = [newIm; allFr(ii).newIm];
    end
    newIm = [newIm; allFr(end).newCh];
    set(hp,'CData',newIm);
end

% --- Executes on button press in ExportData.
function ExportData_Callback(hObject, eventdata, handles)
% hObject    handle to ExportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in SplitManual.
function SplitManual_Callback(hObject, eventdata, handles)
% hObject    handle to SplitManual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get cell information
dcm_obj = datacursormode(gcf);
cursors = getCursorInfo(dcm_obj);
end

% --- Executes on button press in CombineManual.
function CombineManual_Callback(hObject, eventdata, handles)
% hObject    handle to CombineManual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %% get cell information
    dcm_obj = datacursormode(gcf);
    cursors = getCursorInfo(dcm_obj);
    [ cells ] = cursor2Block( handles.allData.allFr, cursors, 'cell' );
    %% combine    
    allFr = handles.allData.allFr;
    for ii = 1:size(cells,1)
        combineCellManual( allFr, cells(ii,1), cells(ii,2));
        d = TwoFrame1Ch;
        d.fr1 = allFr(cells(ii,1)-1);
        d.fr2 = allFr(cells(ii,1));
        d.constructIm;
        %allFr(cells(ii,1)-1) = d.fr1;
        d = TwoFrame1Ch;
        d.fr1 = allFr(cells(ii,1));
        d.fr2 = allFr(cells(ii,1)+1);
        d.constructIm;
        %allFr(cells(ii,1)) = d.fr1;
    end
    %% update image
    ha = get(handles.figure1,'children');
   hp = get(ha(length(ha)),'children');
    newIm = [];
    for ii = 1:length(allFr)-1
        newIm = [newIm; allFr(ii).newIm];
    end
    newIm = [newIm; allFr(end).newCh];
    set(hp,'CData',newIm);
end

% --- Executes on button press in DelCellManual.
function DelCellManual_Callback(hObject, eventdata, handles)
% hObject    handle to DelCellManual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in LinkCell.
function LinkCell_Callback(hObject, eventdata, handles)
% hObject    handle to LinkCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %% get cell information
    dcm_obj = datacursormode(gcf);
    cursors = getCursorInfo(dcm_obj);
    [ cells ] = cursor2Block( handles.allData.allFr, cursors, 'cell' );
    %% link
    allFr = handles.allData.allFr;
    if size(cells,1)~= 2 || abs(cells(1,1) - cells(2,1))~=1
        fprintf('have to be two cells! and they have to differ 1 frame!');
        return;
    end
    if cells(1,1) < cells(2,1)
        fr1 = cells(1,1);   cell1 = cells(1,2);
        fr2 = cells(2,1);   cell2 = cells(2,2);
    else
        fr1 = cells(2,1);   cell1 = cells(2,2);
        fr2 = cells(1,1);   cell2 = cells(1,2);
    end
    allFr(fr1).cells.cells(cell1).dLink = unique([allFr(fr1).cells.cells(cell1).dLink cell2]);
    allFr(fr2).cells.cells(cell2).mLink = unique([allFr(fr2).cells.cells(cell2).mLink cell1]);
    
    d = TwoFrame1Ch;
    d.fr1 = allFr(fr1);
    d.fr2 = allFr(fr2);
    d.constructIm;
    
    %% update image
    ha = get(handles.figure1,'children');
    hp = get(ha(length(ha)),'children');
    newIm = [];
    for ii = 1:length(allFr)-1
        newIm = [newIm; allFr(ii).newIm];
    end
    newIm = [newIm; allFr(end).newCh];
    set(hp,'CData',newIm);
end

% --- Executes on button press in DelLink.
function DelLink_Callback(hObject, eventdata, handles)
% hObject    handle to DelLink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %% get cell information
    dcm_obj = datacursormode(gcf);
    cursors = getCursorInfo(dcm_obj);
    [ cells ] = cursor2Block( handles.allData.allFr, cursors, 'cell' );
    %% link
    allFr = handles.allData.allFr;
    if size(cells,1)~= 2 || abs(cells(1,1) - cells(2,1))~=1
        fprintf('have to be two cells! and they have to differ 1 frame!');
        return;
    end
    if cells(1,1) < cells(2,1)
        fr1 = cells(1,1);   cell1 = cells(1,2);
        fr2 = cells(2,1);   cell2 = cells(2,2);
    else
        fr1 = cells(2,1);   cell1 = cells(2,2);
        fr2 = cells(1,1);   cell2 = cells(1,2);
    end
    allFr(fr1).cells.cells(cell1).dLink(allFr(fr1).cells.cells(cell1).dLink == cell2) = [];
    allFr(fr2).cells.cells(cell2).mLink(allFr(fr2).cells.cells(cell2).mLink == cell1) = [];
    
    d = TwoFrame1Ch;
    d.fr1 = allFr(fr1);
    d.fr2 = allFr(fr2);
    d.constructIm;
    
    %% update image
    ha = get(handles.figure1,'children');
    hp = get(ha(length(ha)),'children');
    newIm = [];
    for ii = 1:length(allFr)-1
        newIm = [newIm; allFr(ii).newIm];
    end
    newIm = [newIm; allFr(end).newCh];
    set(hp,'CData',newIm);
end


% --- Executes on button press in SkipFrame.
function SkipFrame_Callback(hObject, eventdata, handles)
% hObject    handle to SkipFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% get cell information
    dcm_obj = datacursormode(gcf);
    cursors = getCursorInfo(dcm_obj);
    [ cells ] = cursor2Block( handles.allData.allFr, cursors, 'cell' );
%% 
    allFr = handles.allData.allFr;
    if size(cells,1)~= 1 || cells(1,1) < 3 || cells(1,1) == length(allFr)
        fprintf('Please skip one frame at a time! and pick and appropriate frame');
        return;
    end
    fr2Mod = cells(1,1);
    startFr = fr2Mod - 1;
    endFr = fr2Mod;
    
    %% clean kthFrame - 1
    for ii = 1:length(allFr(fr2Mod-1).blockLs.blockLs)
        allFr(fr2Mod-1).blockLs.blockLs(ii).kp1sLink = [];
    end
    for ii = 1:length(allFr(fr2Mod-1).cells.cells)
        allFr(fr2Mod-1).cells.cells(ii).dLink = [];
    end
    %% clean kthFrame + 1
    for ii = 1:length(allFr(fr2Mod+1).blockSs.blockSs)
        allFr(fr2Mod+1).blockSs.blockSs(ii).km1lLink = [];
    end
    for ii = 1:length(allFr(fr2Mod+1).cells.cells)
        allFr(fr2Mod+1).cells.cells(ii).mLink = [];
        allFr(fr2Mod+1).cells.cells(ii).lLink = [];
        %allFr(fr2Mod+1).cells.cells = [];
    end
    allFr(fr2Mod) = copy(allFr(fr2Mod-1));
    allFr(fr2Mod).frameNum = allFr(fr2Mod).frameNum + 1;
    for ii = 1:length(allFr(fr2Mod).blockLs.blockLs)
        allFr(fr2Mod).blockLs.blockLs(ii).cLink = [];
    end
    for ii = 1:length(allFr(fr2Mod).blockSs.blockSs)
        allFr(fr2Mod).blockSs.blockSs(ii).km1lLink = [];
    end
    %for ii = 1:length(allFr(fr2Mod).cells.cells)
%         allFr(fr2Mod).cells.cells(ii).mLink = [];
%         allFr(fr2Mod).cells.cells(ii).lLink = [];
        allFr(fr2Mod).cells.cells = [];
    %end
    
    for kthFrame = startFr:endFr-1
        b = allFr(kthFrame);
        c = allFr(kthFrame + 1);
%         c.SearchBlock('BlockL');
%         c.blockLs = c.blockLs.StitchBlocks();
%         c.SearchBlock('BlockS');
%         c.blockSs = c.blockSs.StitchBlocks();
%         c.ProfileAlign('bright');
%         %c.ProfileAlign();
%         c.BlockAlign();

        d = TwoFrame1Ch;
        d.frameNum = b.frameNum;
        d.fr1 = b;
        d.fr2 = c;

        d.ProfileAlign();
        d.BlockAlign;

        while d.CellTransfer == 1 % triple split
            c.cells.cells = [];
            c.blockSs.blockSs = [];
            c.SearchBlock('BlockS');
            c.blockSs = c.blockSs.StitchBlocks();
            for kthBlock = 1:length(c.blockLs.blockLs)
                c.blockLs.blockLs(kthBlock).sLink = [];
                c.blockLs.blockLs(kthBlock).kp1sLink = [];
                c.blockLs.blockLs(kthBlock).cLink = [];
            end

            c.blockLs = c.blockLs.StitchBlocks();
            c.ProfileAlign();
            c.BlockAlign();
            d.fr2 = c;
            d.ProfileAlign;
            d.BlockAlign;
%             d.CellTransfer;
        end
        d.constructIm;

        allFr(kthFrame+1) = c;
    end
    
    %% update image
    ha = get(handles.figure1,'children');
    hp = get(ha(length(ha)),'children');
    handles.allData.allFr = allFr;
    newIm = handles.allData.linkedIm;
    set(hp,'CData',newIm);
    

end


% --- Executes on button press in ReAnalyzeFollowingFrames.
function ReAnalyzeFollowingFrames_Callback(hObject, eventdata, handles)
% hObject    handle to ReAnalyzeFollowingFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% get cell information
    dcm_obj = datacursormode(gcf);
    cursors = getCursorInfo(dcm_obj);
    [ cells ] = cursor2Block( handles.allData.allFr, cursors, 'cell' );
%% 
    allFr = handles.allData.allFr;
    if size(cells,1)~= 1 || cells(1,1) < 1 || cells(1,1) == length(allFr)
        fprintf('Please skip one frame at a time! and pick and appropriate frame');
        return;
    end
    fr2Mod = cells(1,1);
    startFr = fr2Mod;
    endFr = length(allFr);
            
    for kthFrame = startFr:endFr-1

%         c.SearchBlock('BlockL');
%         c.blockLs = c.blockLs.StitchBlocks();
%         c.SearchBlock('BlockS');
%         c.blockSs = c.blockSs.StitchBlocks();
%         c.ProfileAlign('bright');
%         %c.ProfileAlign();
%         c.BlockAlign();
        fprintf('Analyzing Frame = %d\n', kthFrame);
        %% clean kthFrame
        for ii = 1:length(allFr(kthFrame).blockLs.blockLs)
            allFr(kthFrame).blockLs.blockLs(ii).kp1sLink = [];
        end
        for ii = 1:length(allFr(kthFrame).cells.cells)
            allFr(kthFrame).cells.cells(ii).dLink = [];
        end
        %% clean kthFrame + 1
        for ii = 1:length(allFr(kthFrame+1).blockLs.blockLs)
            allFr(kthFrame+1).blockLs.blockLs(ii).cLink = [];
        end
        for ii = 1:length(allFr(kthFrame+1).blockSs.blockSs)
            allFr(kthFrame+1).blockSs.blockSs(ii).km1lLink = [];
        end
        for ii = 1:length(allFr(kthFrame+1).cells.cells)
            allFr(kthFrame+1).cells.cells = [];
        end
        
        b = allFr(kthFrame);
        c = allFr(kthFrame + 1);

        d = TwoFrame1Ch;
        d.frameNum = b.frameNum;
        d.fr1 = b;
        d.fr2 = c;

        d.ProfileAlign();
        d.BlockAlign;

        while d.CellTransfer == 1 % triple split
            c.cells.cells = [];
            c.blockSs.blockSs = [];
            c.SearchBlock('BlockS');
            c.blockSs = c.blockSs.StitchBlocks();
            for kthBlock = 1:length(c.blockLs.blockLs)
                c.blockLs.blockLs(kthBlock).sLink = [];
                c.blockLs.blockLs(kthBlock).kp1sLink = [];
                c.blockLs.blockLs(kthBlock).cLink = [];
            end

            c.blockLs = c.blockLs.StitchBlocks();
            c.ProfileAlign();
            c.BlockAlign();
            d.fr2 = c;
            d.ProfileAlign;
            d.BlockAlign;
%             d.CellTransfer;
        end
        d.constructIm;

        allFr(kthFrame+1) = c;
    end
    
    %% update image
    ha = get(handles.figure1,'children');
    hp = get(ha(length(ha)),'children');
    handles.allData.allFr = allFr;
    newIm = handles.allData.linkedIm;
    set(hp,'CData',newIm);
    

end
