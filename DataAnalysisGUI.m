function varargout = DataAnalysisGUI(varargin)
% DATAANALYSISGUI MATLAB code for DataAnalysisGUI.fig
%      DATAANALYSISGUI, by itself, creates a new DATAANALYSISGUI or raises the existing
%      singleton*.
%
%      H = DATAANALYSISGUI returns the handle to a new DATAANALYSISGUI or the handle to
%      the existing singleton*.
%
%      DATAANALYSISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAANALYSISGUI.M with the given input arguments.
%
%      DATAANALYSISGUI('Property','Value',...) creates a new DATAANALYSISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataAnalysisGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataAnalysisGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataAnalysisGUI

% Last Modified by GUIDE v2.5 11-Apr-2017 10:45:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DataAnalysisGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DataAnalysisGUI_OutputFcn, ...
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


% --- Executes just before DataAnalysisGUI is made visible.
function DataAnalysisGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataAnalysisGUI (see VARARGIN)

% Choose default command line output for DataAnalysisGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DataAnalysisGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DataAnalysisGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sliderPosition = round(get(hObject, 'Value'));
selectedValues = get(handles.edit1, 'value');
if (size(selectedValues, 2)>1 && max(selectedValues) > sliderPosition)
    sliderPosition = max(selectedValues);
    set(hObject, 'Value', sliderPosition);
end
setappdata(0, 'sliderPosition', sliderPosition);
set(handles.edit1, 'value', sliderPosition);
updateGraph(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
set(hObject, 'position', [-0.167 0 5.5 40]);  % expand the listbox when selected
maxValue = max(get(hObject, 'Value'));
set(handles.slider1, 'Value', maxValue);
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Channel2Flip.
function Channel2Flip_Callback(hObject, eventdata, handles)
% hObject    handle to Channel2Flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Channel2Flip
data = getappdata(0, 'rawdata');
nChannels = getappdata(0, 'nChannels');
if nChannels == 2
    data = [data(1,:,:); data(2,:,:)*-1];
elseif nChannels == 3
    data = [data(1,:,:); data(2,:,:)*-1; data(3,:,:)];
else % must be 4 channels then
    data = [data(1,:,:); data(2,:,:)*-1; data(3:4,:,:)];
end
setappdata(0, 'rawdata', data);
setappdata(0, 'currentdata', data);
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes on button press in Channel2ColorPicker.
function Channel2ColorPicker_Callback(hObject, eventdata, handles)
% hObject    handle to Channel2ColorPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor([0.8 0.8 0.8],'Select a color');
if length(c)>1 
    set(handles.Channel2ColorPicker, 'BackgroundColor', c);
end
updateGraph(hObject, handles);


function Channel2Title_Callback(hObject, eventdata, handles)
% hObject    handle to Channel2Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Channel2Title as text
%        str2double(get(hObject,'String')) returns contents of Channel2Title as a double
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Channel2Title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channel2Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Channel3Title_Callback(hObject, eventdata, handles)
% hObject    handle to Channel3Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Channel3Title as text
%        str2double(get(hObject,'String')) returns contents of Channel3Title as a double
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Channel3Title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channel3Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Channel4Title_Callback(hObject, eventdata, handles)
% hObject    handle to Channel4Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Channel4Title as text
%        str2double(get(hObject,'String')) returns contents of Channel4Title as a double
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Channel4Title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channel4Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Channel1Flip.
function Channel1Flip_Callback(hObject, eventdata, handles)
% hObject    handle to Channel1Flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Channel1Flip
data = getappdata(0, 'rawdata');
nChannels = getappdata(0, 'nChannels');
data = [data(1,:,:)*-1; data(2:nChannels,:,:)];
setappdata(0, 'rawdata', data);
setappdata(0, 'currentdata', data);
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

function Channel1Title_Callback(hObject, eventdata, handles)
% hObject    handle to Channel1Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Channel1Title as text
%        str2double(get(hObject,'String')) returns contents of Channel1Title as a double
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Channel1Title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channel1Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Channel1ColorPicker.
function Channel1ColorPicker_Callback(hObject, eventdata, handles)
% hObject    handle to Channel1ColorPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor([1 0 0],'Select a color');
if length(c)>1 
    set(handles.Channel1ColorPicker, 'BackgroundColor', c);
end
updateGraph(hObject, handles);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Channel3Flip.
function Channel3Flip_Callback(hObject, eventdata, handles)
% hObject    handle to Channel3Flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Channel3Flip
data = getappdata(0, 'rawdata');
nChannels = getappdata(0, 'nChannels');
if nChannels == 3
    data = [data(1:2,:,:); data(3,:,:)*-1];
else % must be 4 channels then
    data = [data(1:2,:,:); data(3,:,:)*-1; data(4,:,:)];
end
setappdata(0, 'rawdata', data);
setappdata(0, 'currentdata', data);
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes on button press in Channel3ColorPicker.
function Channel3ColorPicker_Callback(hObject, eventdata, handles)
% hObject    handle to Channel3ColorPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor([0 0 0],'Select a color');
if length(c)>1 
    set(handles.Channel3ColorPicker, 'BackgroundColor', c);
end
updateGraph(hObject, handles);

% --- Executes on button press in Channel4Flip.
function Channel4Flip_Callback(hObject, eventdata, handles)
% hObject    handle to Channel4Flip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Channel4Flip
data = getappdata(0, 'rawdata');
nChannels = getappdata(0, 'nChannels');
data = [data(1:3,:,:); data(4,:,:)*-1];
setappdata(0, 'rawdata', data);
setappdata(0, 'currentdata', data);
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes on button press in Channel4ColorPicker.
function Channel4ColorPicker_Callback(hObject, eventdata, handles)
% hObject    handle to Channel4ColorPicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = uisetcolor([1 0.843 0],'Select a color');
if length(c)>1 
    set(handles.Channel4ColorPicker, 'BackgroundColor', c);
end
updateGraph(hObject, handles);


% --------------------------------------------------------------------
function saveButton_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ax = handles.axes1;
export_fig(['PlotSaveNumber', num2str(getappdata(0, 'sliderPosition'))], ax);

% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try % see if there is a saved default file selected
    load('saveddatafile.mat');
    [chosenfile, chosendirectory] = uigetfile(fullchosenfile);
catch % if not, then let the user choose a file
    [chosenfile, chosendirectory] = uigetfile('*.csv');
end
if length(chosenfile)>1 % if user didn't cancel, length of chosenfile is > 1
    fullchosenfile = [chosendirectory chosenfile];
    
    [~,~,ext] = fileparts(fullchosenfile); % get extension of chosenfile
    if ~strcmp(ext, '.csv') && ~strcmp(ext, '.CSV') % make sure it is .csv file
        h = warndlg('Unable to open selected file. You did not select a .csv file.','Wrong File Type Selected');
        fullchosenfile = [];
    else
        try % try to read the .csv file
            rawdata = csvread(fullchosenfile);
            save('saveddatafile.mat', 'fullchosenfile', 'chosendirectory', 'chosenfile');
            prompt = {'How many channels?'};
            dlg_title = 'Enter Number of Channels';
            num_lines = 1;
            defaultans = {'3'};
            nChannels = inputdlg(prompt,dlg_title,num_lines,defaultans);
            nChannels = str2num(cell2mat(nChannels));
            t = rawdata(:,1:2*nChannels:end);
            [dataRows, dataCols] = size(rawdata);
            ch = zeros(nChannels, dataRows, dataCols/(2*nChannels));
            for i = 1:nChannels
                ch(i,:,:) = rawdata(:,2*i:2*nChannels:end);
                eval(['set(handles.Channel', int2str(i), 'Flip, ''visible'', ''on'');']);
                eval(['set(handles.Channel', int2str(i), 'ColorPicker, ''visible'', ''on'');']);
                eval(['set(handles.Channel', int2str(i), 'Title, ''visible'', ''on'');']);
            end
            numSaves = dataCols/(2*nChannels);
            set(handles.slider1, 'visible', 'on');
            set(handles.slider1, 'value', 1);
            set(handles.slider1, 'Min', 1);
            set(handles.slider1, 'Max', numSaves);
            set(handles.slider1, 'SliderStep', [1/(dataCols/(2*nChannels)), 1/(dataCols/(2*nChannels))]);
            set(handles.edit1, 'visible', 'on');
            listBoxText = strread(int2str(1:numSaves),'%s');
            set(handles.edit1, 'string', listBoxText);
            setappdata(0, 'sliderPosition', 1);
            setappdata(0, 'nChannels', nChannels);
            setappdata(0, 't', t);
            setappdata(0, 'rawdata', ch);
            setappdata(0, 'currentdata', ch);
            
            % Create the empty N1 and P2 variables to store the data in
            setappdata(0, 'N1Amp', zeros(numSaves, 1));
            setappdata(0, 'N1Lat', zeros(numSaves, 1));
            setappdata(0, 'P2Amp', zeros(numSaves, 1));
            setappdata(0, 'P2Lat', zeros(numSaves, 1));
            setappdata(0, 'noiseAmp', zeros(numSaves, 1));
            setappdata(0, 'noiseMean', zeros(numSaves, 1));
            setappdata(0, 'noiseSD', zeros(numSaves, 1));
            
            updateGraph(hObject, handles); % plot first save
        catch
            h = warndlg('Error parsing .csv file.  Are you sure you first selected just the numeric values of the channels and saved it in a separate file?', 'Error Parsing File');
        end    
    end
end


% --- Executes on button press in normalizeCheckBox.
function normalizeCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to normalizeCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of normalizeCheckBox
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes on button press in detrendCheckBox.
function detrendCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to detrendCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of detrendCheckBox
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);


% --- Executes on button press in smoothCheckBox.
function smoothCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to smoothCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of smoothCheckBox
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);


function kEditor_Callback(hObject, eventdata, handles)
% hObject    handle to kEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kEditor as text
%        str2double(get(hObject,'String')) returns contents of kEditor as a double


% --- Executes during object creation, after setting all properties.
function kEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fEditor_Callback(hObject, eventdata, handles)
% hObject    handle to fEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fEditor as text
%        str2double(get(hObject,'String')) returns contents of fEditor as a double
if (mod(str2num(get(handles.fEditor, 'String')), 2))
    updateAnalysis(hObject, handles);
    updateGraph(hObject, handles);
else
    h = warndlg('Reminder: Frame Length (F) must be odd.', 'Invalid F');
end

% --- Executes during object creation, after setting all properties.
function fEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xMaxEditor_Callback(hObject, eventdata, handles)
% hObject    handle to xMaxEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xMaxEditor as text
%        str2double(get(hObject,'String')) returns contents of xMaxEditor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function xMaxEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xMaxEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yMinEditor_Callback(hObject, eventdata, handles)
% hObject    handle to yMinEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yMinEditor as text
%        str2double(get(hObject,'String')) returns contents of yMinEditor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function yMinEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yMinEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yMaxEditor_Callback(hObject, eventdata, handles)
% hObject    handle to yMaxEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yMaxEditor as text
%        str2double(get(hObject,'String')) returns contents of yMaxEditor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function yMaxEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yMaxEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autoscaleCheckBox.
function autoscaleCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to autoscaleCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoscaleCheckBox
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function normalizeCheckBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to normalizeCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in findN1CheckBox.
function findN1CheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to findN1CheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of findN1CheckBox
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes on button press in findP1CheckBox.
function findP1CheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to findP1CheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of findP1CheckBox
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);


function findN1FromEditor_Callback(hObject, eventdata, handles)
% hObject    handle to findN1FromEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of findN1FromEditor as text
%        str2double(get(hObject,'String')) returns contents of findN1FromEditor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function findN1FromEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to findN1FromEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function findN1ToEditor_Callback(hObject, eventdata, handles)
% hObject    handle to findN1ToEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of findN1ToEditor as text
%        str2double(get(hObject,'String')) returns contents of findN1ToEditor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function findN1ToEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to findN1ToEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function findP1FromEditor_Callback(hObject, eventdata, handles)
% hObject    handle to findP1FromEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of findP1FromEditor as text
%        str2double(get(hObject,'String')) returns contents of findP1FromEditor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function findP1FromEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to findP1FromEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function findP1ToEditor_Callback(hObject, eventdata, handles)
% hObject    handle to findP1ToEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of findP1ToEditor as text
%        str2double(get(hObject,'String')) returns contents of findP1ToEditor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function findP1ToEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to findP1ToEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function distanceN1Editor_Callback(hObject, eventdata, handles)
% hObject    handle to distanceN1Editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distanceN1Editor as text
%        str2double(get(hObject,'String')) returns contents of distanceN1Editor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function distanceN1Editor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceN1Editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function heightN1Editor_Callback(hObject, eventdata, handles)
% hObject    handle to heightN1Editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of heightN1Editor as text
%        str2double(get(hObject,'String')) returns contents of heightN1Editor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function heightN1Editor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heightN1Editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function distanceP1Editor_Callback(hObject, eventdata, handles)
% hObject    handle to distanceP1Editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distanceP1Editor as text
%        str2double(get(hObject,'String')) returns contents of distanceP1Editor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function distanceP1Editor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceP1Editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function heightP1Editor_Callback(hObject, eventdata, handles)
% hObject    handle to heightP1Editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of heightP1Editor as text
%        str2double(get(hObject,'String')) returns contents of heightP1Editor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function heightP1Editor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heightP1Editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function findN1ChannelEditor_Callback(hObject, eventdata, handles)
% hObject    handle to findN1ChannelEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of findN1ChannelEditor as text
%        str2double(get(hObject,'String')) returns contents of findN1ChannelEditor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function findN1ChannelEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to findN1ChannelEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function findP1ChannelEditor_Callback(hObject, eventdata, handles)
% hObject    handle to findP1ChannelEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of findP1ChannelEditor as text
%        str2double(get(hObject,'String')) returns contents of findP1ChannelEditor as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function findP1ChannelEditor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to findP1ChannelEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in overlayButton.
function overlayButton_Callback(hObject, eventdata, handles)
% hObject    handle to overlayButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% when the overlayButton calls the updateGraph function, it plots on the
% overlayAxis instead
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);


% --- Executes on button press in autoP1MinCheckBox.
function autoP1MinCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to autoP1MinCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autoP1MinCheckBox
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit1.
function edit1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject, 'position', [-0.167 5.231 5.5 1.692]);  % collapse the listbox when right-clicked


% --- Executes on button press in PlotDiffCheckbox.
function PlotDiffCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PlotDiffCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PlotDiffCheckbox
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);


function PlotDiffChA_Callback(hObject, eventdata, handles)
% hObject    handle to PlotDiffChA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotDiffChA as text
%        str2double(get(hObject,'String')) returns contents of PlotDiffChA as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PlotDiffChA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotDiffChA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PlotDiffChB_Callback(hObject, eventdata, handles)
% hObject    handle to PlotDiffChB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlotDiffChB as text
%        str2double(get(hObject,'String')) returns contents of PlotDiffChB as a double
updateAnalysis(hObject, handles);
updateGraph(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PlotDiffChB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotDiffChB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RecordN1P2.
function RecordN1P2_Callback(hObject, eventdata, handles)
% hObject    handle to RecordN1P2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectedValues = get(handles.edit1, 'value');
    N1A = getappdata(0, 'N1Amp');
    N1L = getappdata(0, 'N1Lat');
    P2A = getappdata(0, 'P2Amp');
    P2L = getappdata(0, 'P2Lat');
    NAmp = getappdata(0, 'noiseAmp');
    NMean = getappdata(0, 'noiseMean');
    NSD = getappdata(0, 'noiseSD');
    
    % Save the N1 and P2 values to local variables
    N1A(selectedValues) = str2double(get(handles.amplitudeN1TextBox, 'String'));
    N1L(selectedValues) = str2double(get(handles.latencyN1TextBox, 'String'));
    P2A(selectedValues) = str2double(get(handles.amplitudeP1TextBox, 'String'));
    P2L(selectedValues) = str2double(get(handles.latencyP1TextBox, 'String'));
    NAmp(selectedValues) = str2double(get(handles.noiseAmpTag, 'String'));
    NMean(selectedValues) = str2double(get(handles.noiseMeanTag, 'String'));
    NSD(selectedValues) = str2double(get(handles.noiseSDTag, 'String'));
    
    setappdata(0, 'N1Amp', N1A);
    setappdata(0, 'N1Lat', N1L);
    setappdata(0, 'P2Amp', P2A);
    setappdata(0, 'P2Lat', P2L);
    setappdata(0, 'noiseAmp', NAmp);
    setappdata(0, 'noiseMean', NMean);
    setappdata(0, 'noiseSD', NSD);
    
    csvwrite('N1P2Data.csv', [N1A, N1L, P2A, P2L, NAmp, NMean, NSD]);
