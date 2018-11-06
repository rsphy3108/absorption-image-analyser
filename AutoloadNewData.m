function varargout = AutoloadNewData(varargin)
% AutoloadNewData MATLAB code for AutoloadNewData.fig
%      AutoloadNewData, by itself, creates a new AutoloadNewData or raises the existing
%      singleton*.
%
%      H = AutoloadNewData returns the handle to a new AutoloadNewData or the handle to
%      the existing singleton*.
%
%      AutoloadNewData('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AutoloadNewData.M with the given input arguments.
%
%      AutoloadNewData('Property','Value',...) creates a new AutoloadNewData or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AutoloadNewData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AutoloadNewData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AutoloadNewData

% Last Modified by GUIDE v2.5 06-Nov-2018 13:57:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AutoloadNewData_OpeningFcn, ...
                   'gui_OutputFcn',  @AutoloadNewData_OutputFcn, ...
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


% --- Executes just before AutoloadNewData is made visible.
function AutoloadNewData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AutoloadNewData (see VARARGIN)

% Choose default command line output for AutoloadNewData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AutoloadNewData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AutoloadNewData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_start_autoload.
function pushbutton_start_autoload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start_autoload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_stop_autoload, 'userdata', 0);
autoload_newdatamenu_cont;


% --- Executes on button press in pushbutton_stop_autoload.
function pushbutton_stop_autoload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_stop_autoload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton_stop_autoload,'userdata',1)
