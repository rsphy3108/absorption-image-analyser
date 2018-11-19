function varargout = OfflineImageAnalyser(varargin)
% OFFLINEIMAGEANALYSER MATLAB code for OfflineImageAnalyser.fig
%      OFFLINEIMAGEANALYSER, by itself, creates a new OFFLINEIMAGEANALYSER or raises the existing
%      singleton*.
%
%      H = OFFLINEIMAGEANALYSER returns the handle to a new OFFLINEIMAGEANALYSER or the handle to
%      the existing singleton*.
%
%      OFFLINEIMAGEANALYSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OFFLINEIMAGEANALYSER.M with the given input arguments.
%
%      OFFLINEIMAGEANALYSER('Property','Value',...) creates a new OFFLINEIMAGEANALYSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OfflineImageAnalyser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OfflineImageAnalyser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OfflineImageAnalyser

% Last Modified by GUIDE v2.5 19-Nov-2018 12:45:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OfflineImageAnalyser_OpeningFcn, ...
                   'gui_OutputFcn',  @OfflineImageAnalyser_OutputFcn, ...
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


% --- Executes just before OfflineImageAnalyser is made visible.
function OfflineImageAnalyser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OfflineImageAnalyser (see VARARGIN)

% Choose default command line output for configfileeditor
handles.output = hObject;

guidata(hObject, handles);

%defaultconfig
guidata(hObject, handles);

% Initialise .mat storage file if it doesn't exist already
if ~exist('offlineconfigdata.mat') 
    
    dummy = 0;
    save('offlineconfigdata','dummy');
    
else
    
    load offlineconfigdata.mat
    
end

% Detect OS type
windows = ispc; % Needed for filepath construction: \ for Windows, / for Mac and Linux
handles.OStype = windows;
save('offlineconfigdata','windows','-append');

%loadConfigState(handles);   % Loads previous state of config file

% imagePath = handles.imagePath;
% storagePath = handles.storagePath;
% logPath = handles.logPath;

%save('configdata','imagePath','storagePath','logPath','windows','-append');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OfflineImageAnalyser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OfflineImageAnalyser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_variable_file.
function pushbutton_variable_file_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_variable_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[varfilename,varpathname] = uigetfile('*.txt','Select the configuration file.');

handles.varPath = varpathname;
handles.varFilename = varfilename;

%set(handles.varFilename,'String',handles.varFilename);
offlinevarPath = handles.varPath;
offlinevarFilename = handles.varFilename;
save('offlineconfigdata','offlinevarPath','offlinevarFilename','-append');


% --- Executes on button press in pushbutton_image_folder.
function pushbutton_image_folder_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_image_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[IFname IFpath] = uigetfile('*.asc','Select image file');
handles.IFpath = IFpath;
handles.IFname = IFname;

ifpath = handles.IFpath;
ifname = handles.IFname;

save('offlineconfigdata','ifname','ifpath','-append');
guidata(hObject, handles);

% --- Executes on button press in pushbutton_final_dat_folder.
function pushbutton_final_dat_folder_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_final_dat_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FDFpath = uigetdir('\Windows Path\');
%[FDFname FDFpath] = uigetfile('*.asc','Select image file');
handles.FDFpath = FDFpath;
fdfPath = handles.FDFpath;
save('offlineconfigdata','fdfPath','-append');
guidata(hObject, handles);


function edit_ROI_xmin_sp1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ROI_xmin_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ROI_xmin_sp1 as text
%        str2double(get(hObject,'String')) returns contents of edit_ROI_xmin_sp1 as a double
ROI_xmin_sp1 = str2double(get(hObject,'String'));
handles.edit_ROI_xmin_sp1 = ROI_xmin_sp1;
save('offlineconfigdata','ROI_xmin_sp1','-append');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ROI_xmin_sp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ROI_xmin_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ROI_xmax_sp1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ROI_xmax_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ROI_xmax_sp1 as text
%        str2double(get(hObject,'String')) returns contents of edit_ROI_xmax_sp1 as a double
ROI_xmax_sp1 = str2double(get(hObject,'String'));
handles.edit_ROI_xmax_sp1 = ROI_xmax_sp1;
save('offlineconfigdata','ROI_xmax_sp1','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ROI_xmax_sp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ROI_xmax_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ROI_zmin_sp1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ROI_zmin_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ROI_zmin_sp1 as text
%        str2double(get(hObject,'String')) returns contents of edit_ROI_zmin_sp1 as a double
ROI_zmin_sp1 = str2double(get(hObject,'String'));
handles.edit_ROI_zmin_sp1 = ROI_zmin_sp1;
save('offlineconfigdata','ROI_zmin_sp1','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ROI_zmin_sp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ROI_zmin_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ROI_zmax_sp1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ROI_zmax_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ROI_zmax_sp1 as text
%        str2double(get(hObject,'String')) returns contents of edit_ROI_zmax_sp1 as a double
ROI_zmax_sp1 = str2double(get(hObject,'String'));
handles.edit_ROI_zmax_sp1 = ROI_zmax_sp1;
save('offlineconfigdata','ROI_zmax_sp1','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ROI_zmax_sp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ROI_zmax_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ROI_xmin_sp2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ROI_xmin_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ROI_xmin_sp2 as text
%        str2double(get(hObject,'String')) returns contents of edit_ROI_xmin_sp2 as a double
ROI_xmin_sp2 = str2double(get(hObject,'String'));
handles.edit_ROI_xmin_sp2 = ROI_xmin_sp2;
save('offlineconfigdata','ROI_xmin_sp2','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ROI_xmin_sp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ROI_xmin_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ROI_xmax_sp2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ROI_xmax_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ROI_xmax_sp2 as text
%        str2double(get(hObject,'String')) returns contents of edit_ROI_xmax_sp2 as a double
ROI_xmax_sp2 = str2double(get(hObject,'String'));
handles.edit_ROI_xmax_sp2 = ROI_xmax_sp2;
save('offlineconfigdata','ROI_xmax_sp2','-append');

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit_ROI_xmax_sp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ROI_xmax_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ROI_zmin_sp2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ROI_zmin_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ROI_zmin_sp2 as text
%        str2double(get(hObject,'String')) returns contents of edit_ROI_zmin_sp2 as a double
ROI_zmin_sp2 = str2double(get(hObject,'String'));
handles.edit_ROI_zmin_sp2 = ROI_zmin_sp2;
save('offlineconfigdata','ROI_zmin_sp2','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ROI_zmin_sp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ROI_zmin_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ROI_zmax_sp2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ROI_zmax_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ROI_zmax_sp2 as text
%        str2double(get(hObject,'String')) returns contents of edit_ROI_zmax_sp2 as a double
ROI_zmax_sp2 = str2double(get(hObject,'String'));
handles.edit_ROI_zmax_sp2 = ROI_zmax_sp2;
save('offlineconfigdata','ROI_zmax_sp2','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ROI_zmax_sp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ROI_zmax_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_at_xwidth_sp1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_at_xwidth_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_at_xwidth_sp1 as text
%        str2double(get(hObject,'String')) returns contents of edit_at_xwidth_sp1 as a double
at_xwidth_sp1 = str2double(get(hObject,'String'));
handles.edit_at_xwidth_sp1 = at_xwidth_sp1;
save('offlineconfigdata','at_xwidth_sp1','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_at_xwidth_sp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_at_xwidth_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_at_zwidth_sp1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_at_zwidth_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_at_zwidth_sp1 as text
%        str2double(get(hObject,'String')) returns contents of edit_at_zwidth_sp1 as a double
at_zwidth_sp1 = str2double(get(hObject,'String'));
handles.edit_at_zwidth_sp1 = at_zwidth_sp1;
save('offlineconfigdata','at_zwidth_sp1','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_at_zwidth_sp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_at_zwidth_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_at_xwidth_sp2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_at_xwidth_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_at_xwidth_sp2 as text
%        str2double(get(hObject,'String')) returns contents of edit_at_xwidth_sp2 as a double
at_xwidth_sp2 = str2double(get(hObject,'String'));
handles.edit_at_xwidth_sp2 = at_xwidth_sp2;
save('offlineconfigdata','at_xwidth_sp2','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_at_xwidth_sp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_at_xwidth_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_at_zwidth_sp2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_at_zwidth_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_at_zwidth_sp2 as text
%        str2double(get(hObject,'String')) returns contents of edit_at_zwidth_sp2 as a double
at_zwidth_sp2 = str2double(get(hObject,'String'));
handles.edit_at_zwidth_sp2 = at_zwidth_sp2;
save('offlineconfigdata','at_zwidth_sp2','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_at_zwidth_sp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_at_zwidth_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_fr_folder_offline.
function pushbutton_fr_folder_offline_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fr_folder_offline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FRname FRpath] = uigetfile('*.asc','Select file');
handles.FRpath = FRpath;
%handles.FRname = FRname;

%set(handles.text_FRpath,'String',handles.FRpath);
frPath = handles.FRpath;
%frName = handles.FRname;
%save('offlineconfigdata','frPath','frName','-append');
save('offlineconfigdata','frPath','-append');

guidata(hObject, handles);



function fr_offline_range_Callback(hObject, eventdata, handles)
% hObject    handle to fr_offline_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fr_offline_range as text
%        str2double(get(hObject,'String')) returns contents of fr_offline_range as a double
ref_files= get(handles.fr_offline_range,'String');
refnums = textscan(ref_files, '%s','delimiter',',');

refnums = refnums{1};

for count = 1:length(refnums)
    ranges{count} = textscan(refnums{count}, '%s','delimiter','-');
end

for count = 1:length(ranges)    
    lower(count) = round(str2num(ranges{count}{1}{1}));    
    if length(ranges{count}{1}) == 2        
        upper(count) = round(str2num(ranges{count}{1}{2}));        
    else        
        upper(count) = 0;        
    end    
end

refindex = [];

for count = 1:length(ranges)
    if upper(count) ~= 0
        refindex(length(refindex)+1:length(refindex)+(upper(count)-lower(count))+1) = lower(count):1:upper(count);
    else
        refindex(length(refindex)+1) = lower(count);
    end
end

save('offlineconfigdata','refindex','-append');

% --- Executes during object creation, after setting all properties.
function fr_offline_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fr_offline_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OF_filename_Callback(hObject, eventdata, handles)
% hObject    handle to OF_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OF_filename as text
%        str2double(get(hObject,'String')) returns contents of OF_filename as a double
of_filename = get(hObject,'String');
handles.of_filename = of_filename;
save('offlineconfigdata','of_filename','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function OF_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OF_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_sup_offline.
function checkbox_sup_offline_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_sup_offline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_sup_offline


% --- Executes on button press in checkbox_pca_offline.
function checkbox_pca_offline_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_pca_offline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_pca_offline


% --- Executes on button press in checkbox_fr_bg_dataset.
function checkbox_fr_bg_dataset_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_fr_bg_dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_fr_bg_dataset
if(get(hObject,'Value') == get(hObject,'Max'))
    fr_ds = 1;
else
    fr_ds = 0;
end
save('offlineconfigdata','fr_ds','-append');

% --- Executes on button press in start_offline_analysis.
function start_offline_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to start_offline_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pca_sp1 = findobj('Tag','checkbox_pca_offline');
sup_sp1 = findobj('Tag','checkbox_sup_offline');

fr_status = 0; 
handles.fr_pressed_sp1 = 1;
keepROI_option_sp1 = 0;
if(get(pca_sp1,'Value') == get(hObject,'Max') && get(sup_sp1,'Value') == get(hObject,'Max'))
    errordlg({'Slect only one of the Fringe removal methods'},'Bad thing')
elseif(get(sup_sp1,'Value') == get(hObject,'Max')) 
    fr_status = 1; 
elseif(get(pca_sp1,'Value') == get(hObject,'Max'))
    fr_status = 2;
end

save('offlineconfigdata','fr_status','-append');

offline_image_analysis;
% ii = 0;
% while(ii == 0)
%     offline_image_analysis;
% end



function fr_zwidth_Callback(hObject, eventdata, handles)
% hObject    handle to fr_zwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fr_zwidth as text
%        str2double(get(hObject,'String')) returns contents of fr_zwidth as a double
fr_zwidth = str2double(get(hObject,'String'));
handles.fr_zwidth = fr_zwidth;
save('offlineconfigdata','fr_zwidth','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function fr_zwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fr_zwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fr_xwidth_Callback(hObject, eventdata, handles)
% hObject    handle to fr_xwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fr_xwidth as text
%        str2double(get(hObject,'String')) returns contents of fr_xwidth as a double
fr_xwidth = str2double(get(hObject,'String'));
handles.fr_xwidth = fr_xwidth;
save('offlineconfigdata','fr_xwidth','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function fr_xwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fr_xwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in method_pixsum.
function method_pixsum_Callback(hObject, eventdata, handles)
% hObject    handle to method_pixsum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of method_pixsum


% --- Executes on button press in method_1Dfit.
function method_1Dfit_Callback(hObject, eventdata, handles)
% hObject    handle to method_1Dfit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of method_1Dfit
pixsum = findobj('Tag','method_pixsum');
oneDfit = findobj('Tag','method_1Dfit');

fit_method = 0; 
handles.fr_pressed_sp1 = 1;
keepROI_option_sp1 = 0;
if(get(pixsum,'Value') == get(hObject,'Max') && get(oneDfit,'Value') == get(hObject,'Max'))
    errordlg({'Slect only one of the fitting methods'},'Bad thing')
elseif(get(pixsum,'Value') == get(hObject,'Min') && get(oneDfit,'Value') == get(hObject,'Min'))
    errordlg({'Slect a fitting method'},'Bad thing')
elseif(get(pixsum,'Value') == get(hObject,'Max')) 
    fit_method = 0; 
elseif(get(oneDfit,'Value') == get(hObject,'Max'))
    fit_method = 1;
end

save('offlineconfigdata','fit_method','-append');


% --- Executes on button press in checkbox_single_species_offline.
function checkbox_single_species_offline_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_single_species_offline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_single_species_offline
if(get(hObject,'Value') == get(hObject,'Max'))
    single_species = 1;
else
    single_species = 0;
end
save('offlineconfigdata','single_species','-append');



function max_at_no_Callback(hObject, eventdata, handles)
% hObject    handle to max_at_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_at_no as text
%        str2double(get(hObject,'String')) returns contents of max_at_no as a double
atno_threshold = str2double(get(hObject,'String'));
handles.atno_threshold = atno_threshold;
save('offlineconfigdata','atno_threshold','-append');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function max_at_no_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_at_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_no_overwrite.
function checkbox_no_overwrite_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_no_overwrite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_no_overwrite
if(get(hObject,'Value') == get(hObject,'Max'))
    no_overwrite = 1;
else
    no_overwrite = 0;
end
save('offlineconfigdata','no_overwrite','-append');


% --- Executes on button press in checkbox_manual_cntr_sp1.
function checkbox_manual_cntr_sp1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_manual_cntr_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_manual_cntr_sp1
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.manual_cntr_sp1 = 1;     % Use the entered position as center for pixel sum. 
else
    handles.manual_cntr_sp1 = 0;     % Find the center automatically
end

manual_cntr_sp1 = handles.manual_cntr_sp1;

save('offlineconfigdata','manual_cntr_sp1','-append');


function edit_ctr_x_sp1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ctr_x_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ctr_x_sp1 as text
%        str2double(get(hObject,'String')) returns contents of edit_ctr_x_sp1 as a double
ctr_x_sp1 = str2double(get(hObject,'String'));
handles.ctr_x_sp1 = ctr_x_sp1;
save('offlineconfigdata','ctr_x_sp1','-append');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ctr_x_sp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ctr_x_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ctr_z_sp1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ctr_z_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ctr_z_sp1 as text
%        str2double(get(hObject,'String')) returns contents of edit_ctr_z_sp1 as a double
ctr_z_sp1 = str2double(get(hObject,'String'));
handles.ctr_z_sp1 = ctr_z_sp1;
save('offlineconfigdata','ctr_z_sp1','-append');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ctr_z_sp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ctr_z_sp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_manual_cntr_sp2.
function checkbox_manual_cntr_sp2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_manual_cntr_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_manual_cntr_sp2
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.manual_cntr_sp2 = 1;     % Use the entered position as center for pixel sum. 
else
    handles.manual_cntr_sp2 = 0;     % Find the center automatically
end

manual_cntr_sp2 = handles.manual_cntr_sp2;

save('offlineconfigdata','manual_cntr_sp2','-append');


function edit_ctr_x_sp2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ctr_x_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ctr_x_sp2 as text
%        str2double(get(hObject,'String')) returns contents of edit_ctr_x_sp2 as a double
ctr_x_sp2 = str2double(get(hObject,'String'));
handles.ctr_x_sp2 = ctr_x_sp2;
save('offlineconfigdata','ctr_x_sp2','-append');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ctr_x_sp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ctr_x_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ctr_z_sp2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ctr_z_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ctr_z_sp2 as text
%        str2double(get(hObject,'String')) returns contents of edit_ctr_z_sp2 as a double
ctr_z_sp2 = str2double(get(hObject,'String'));
handles.ctr_z_sp2 = ctr_z_sp2;
save('offlineconfigdata','ctr_z_sp2','-append');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_ctr_z_sp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ctr_z_sp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
