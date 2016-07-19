function varargout = EELS_IntroPage(varargin)
% EELS_INTROPAGE MATLAB code for EELS_IntroPage.fig
%      EELS_INTROPAGE, by itself, creates a new EELS_INTROPAGE or raises the existing
%      singleton*.
%
%      H = EELS_INTROPAGE returns the handle to a new EELS_INTROPAGE or the handle to
%      the existing singleton*.
%
%      EELS_INTROPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EELS_INTROPAGE.M with the given input arguments.
%
%      EELS_INTROPAGE('Property','Value',...) creates a new EELS_INTROPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EELS_IntroPage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EELS_IntroPage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EELS_IntroPage

% Last Modified by GUIDE v2.5 24-Jun-2016 10:59:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EELS_IntroPage_OpeningFcn, ...
                   'gui_OutputFcn',  @EELS_IntroPage_OutputFcn, ...
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


% --- Executes just before EELS_IntroPage is made visible.
function EELS_IntroPage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EELS_IntroPage (see VARARGIN)

%clear all;
% Choose default command line output for EELS_IntroPage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
setappdata(0, 'hEELS_IntroPage', gcf);
% UIWAIT makes EELS_IntroPage wait for user response (see UIRESUME)
% uiwait(handles.intro_figure);


% --- Outputs from this function are returned to the command line.
function varargout = EELS_IntroPage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectSI_pushbutton.
function selectSI_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to selectSI_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname, fdir] = uigetfile('*.dm3', 'Select DM3 Spectrum Image');
handles.SI_textbox.String = strcat(fdir, fname); %To update the textbox display
si_info.filename = handles.SI_textbox.String; 
si_info.dir = fdir;
setappdata(0, 'SI', si_info);%handles.SI contains spectrum image info.


% --- Executes on button press in selectZLP_pushbutton.
function selectZLP_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to selectZLP_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[zlpfname, zlpfdir] = uigetfile('*.dm3', 'Select ZLP Spectrum'); 
handles.ZLP_textbox.String = strcat(zlpfdir, zlpfname);% update the text box
zlp_info.filename = zlpfname;
zlp_info.dir = zlpfdir;
setappdata(0, 'ZLP' ,zlp_info);


% --- Executes on button press in selectDump_pushbutton.
function selectDump_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to selectDump_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Dump_textbox.String = uigetdir();
dump.dir = handles.Dump_textbox.String;
dump.txt = strcat('Chosen Dump Folder =', dump.dir);
setappdata(0, 'Dump', dump);

% --- Executes on button press in LaunchEELS_pushbutton.
function LaunchEELS_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to LaunchEELS_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Here we should do the following:
%       1- Check if file paths and names entered are OK.
%       2- Start SpectrumViewer.
si_info = getappdata(0,'SI');
zlp_info = getappdata(0,'ZLP');
dump_info = getappdata(0, 'Dump');
si_object = DM3Import(si_info.filename);

error =0;
%Now look at different errors:
if ~strcmp(si_object.zaxis.units , 'eV') 
    errordlg('Not a Spectrum Image');
    dumptxt = dump_info.txt;
    dumptxt = strvcat(dumptxt, 'Error: Chosen SI is not a Spectrum Image');
    dump_info.txt = dumptxt;
    setappdata(0, 'Dump', dump_info);
    error =1;
end
%
%....... make more error cases, check ZLP and dimensions and such
%

if error == 0 %No error exists
    [sicell, errm] = make_SI_cell(si_object);
    si_info.SIcell = sicell;
    setappdata(0, 'SI', si_info);
    close;
    EELS_View_Fit();
end