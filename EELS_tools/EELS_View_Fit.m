function varargout = EELS_View_Fit(varargin)
% EELS_VIEW_FIT MATLAB code for EELS_View_Fit.fig
%      EELS_VIEW_FIT, by itself, creates a new EELS_VIEW_FIT or raises the existing
%      singleton*.
%
%      H = EELS_VIEW_FIT returns the handle to a new EELS_VIEW_FIT or the handle to
%      the existing singleton*.
%
%      EELS_VIEW_FIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EELS_VIEW_FIT.M with the given input arguments.
%
%      EELS_VIEW_FIT('Property','Value',...) creates a new EELS_VIEW_FIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EELS_View_Fit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EELS_View_Fit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EELS_View_Fit

% Last Modified by GUIDE v2.5 08-Jul-2016 12:28:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EELS_View_Fit_OpeningFcn, ...
                   'gui_OutputFcn',  @EELS_View_Fit_OutputFcn, ...
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


% --- Executes just before EELS_View_Fit is made visible.
function EELS_View_Fit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EELS_View_Fit (see VARARGIN)

% Choose default command line output for EELS_View_Fit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%these were saved by the intro page. 
si = getappdata(0, 'SI');
zlp = getappdata(0, 'ZLP');
dump = getappdata(0, 'Dump');

%initialize the log
dump.txt = strcat('EELS data processing log for dataset: ', si.filename);

setappdata(0,'Dump', dump);

% initialize the screen with sum under plasmon loss peak displayed
cell_data = si.SIcell;
cellsize = size(cell_data);
plasmon_range_image = zeros(cellsize);
min_ev = str2double(handles.plasmon_min_edit.String);
max_ev = str2double(handles.plasmon_max_edit.String);
for r = 1:cellsize(1)
    for c = 1: cellsize(2)
        dataXY = cell_data{r,c};
        dataX = dataXY(:,1);
        dataY = dataXY(:,2);
        plasmon_range_image(r,c)=sum( ((dataX>min_ev).*(dataX<max_ev)).*dataY);     
    end
end
si.processedSIcell = si.SIcell; % initialize the "processed cell, which keeps getting updated"
setappdata(0,'SI', si);
setappdata(0,'Plasmon_Range_Image', plasmon_range_image);
display_image = plasmon_range_image;
setappdata(0,'Display_Image', display_image);
axes(handles.axes1);
imagesc(getappdata(0,'Display_Image'));
axis image;
% UIWAIT makes EELS_View_Fit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EELS_View_Fit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in shiftZLP_pushbtn.
function shiftZLP_pushbtn_Callback(hObject, eventdata, handles)
% hObject    handle to shiftZLP_pushbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
si = getappdata(0, 'SI');
celldata = si.processedSIcell;
zlpmin = str2double(handles.ZLP_min_edit.String);
zlpmax = str2double(handles.ZLP_max_edit.String);
si.processedSIcell = shift_SI_cell(celldata,zlpmin, zlpmax);
setappdata(0, 'SI', si);
%Update dump
process_string =strcat('Shift SI fitting ZLP to Gaussian, using data withing range',num2str(zlpmin),'eV to',num2str(zlpmax),'eV.');
d = getappdata(0,'Dump');
dtxt = d.txt;
dtxt = strvcat(dtxt, process_string);
d.txt = dtxt;
setappdata(0, 'Dump', d);


% --- Executes on button press in fit_plasmon_pushbtn.
function fit_plasmon_pushbtn_Callback(hObject, eventdata, handles)
% hObject    handle to fit_plasmon_pushbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
si = getappdata(0, 'SI');
d = getappdata(0, 'Dump');
shftd_si_cell = si.processedSIcell;
min_ev = str2double(handles.plasmon_min_edit.String);
max_ev = str2double(handles.plasmon_max_edit.String);
%Dump update
dtxt = d.txt;
fit_string = strcat('Plasmons fit to Drude Model, using the range : ', ...
    handles.plasmon_min_edit.String, ' eV and', handles.plasmon_max_edit.String, ' eV.');
dtxt = strvcat(dtxt, fit_string);
d.txt = dtxt;
setappdata(0, 'Dump', d);
%Dump update end

[drudefit, drudegof] = fit_plasmon(shftd_si_cell,min_ev,max_ev,'Drude', handles.axes2);
si.DrudeFitCell = drudefit;
si.DrudeGofCell = drudegof;

setappdata(0,'SI', si);

% --- Executes on button press in save_pushbtn.
function save_pushbtn_Callback(hObject, eventdata, handles)
% hObject    handle to save_pushbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
d = getappdata(0, 'Dump');
si = getappdata(0,'SI');
dfolder = d.dir;
%now save the classes, SI, and  Dump 
fname_SI =strcat(d.dir,'/Spectrum Image Data.mat');
fname_Dump = strcat(d.dir,'/Dump Data.mat');
save(fname_SI , 'si', '-v7.3');
save(fname_Dump, 'd', '-v7.3');


function plasmon_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to plasmon_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plasmon_min_edit as text
%        str2double(get(hObject,'String')) returns contents of plasmon_min_edit as a double
gatherAndUpdate(handles);


% --- Executes during object creation, after setting all properties.
function plasmon_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plasmon_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function plasmon_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to plasmon_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of plasmon_max_edit as text
%        str2double(get(hObject,'String')) returns contents of plasmon_max_edit as a double
gatherAndUpdate(handles);


% --- Executes during object creation, after setting all properties.
function plasmon_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plasmon_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ZLP_min_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ZLP_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ZLP_min_edit as text
%        str2double(get(hObject,'String')) returns contents of ZLP_min_edit as a double
gatherAndUpdate(handles);

% --- Executes during object creation, after setting all properties.
function ZLP_min_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZLP_min_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ZLP_max_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ZLP_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ZLP_max_edit as text
%        str2double(get(hObject,'String')) returns contents of ZLP_max_edit as a double
gatherAndUpdate(handles);

% --- Executes during object creation, after setting all properties.
function ZLP_max_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZLP_max_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in height_chkbox.
function height_chkbox_Callback(hObject, eventdata, handles)
% hObject    handle to height_chkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of height_chkbox


% --- Executes on button press in background_chkbox.
function background_chkbox_Callback(hObject, eventdata, handles)
% hObject    handle to background_chkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of background_chkbox


% --- Executes on button press in gamma_chkbox.
function gamma_chkbox_Callback(hObject, eventdata, handles)
% hObject    handle to gamma_chkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gamma_chkbox


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in deconvolve_pushbtn.
function deconvolve_pushbtn_Callback(hObject, eventdata, handles)
% hObject    handle to deconvolve_pushbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in subZLP_pushbtn.
function subZLP_pushbtn_Callback(hObject, eventdata, handles)
% hObject    handle to subZLP_pushbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function gatherAndUpdate(handles)
%MAYBE NEED TO MAKE THIS FUNCTION!
si = getappdata(0, 'SI');
zlp = getappdata(0, 'ZLP');
dump = getappdata(0, 'Dump');
cell_data = si.SIcell;
cellsize = size(cell_data);
plasmon_range_image = zeros(cellsize);

min_ev = str2double(handles.plasmon_min_edit.String);
max_ev = str2double(handles.plasmon_max_edit.String);
for r = 1:cellsize(1)
    for c = 1: cellsize(2)
        dataXY = cell_data{r,c};
        dataX = dataXY(:,1);
        dataY = dataXY(:,2);
        plasmon_range_image(r,c)=sum( ((dataX>min_ev).*(dataX<max_ev)).*dataY);          
    end
end

setappdata(0,'Plasmon_Range_Image', plasmon_range_image);
%Modify the following 2 lines to indicate chosen view graph.
display_image = plasmon_range_image;
setappdata(0,'Display_Image', display_image);

%Update the display image
axes(handles.axes1);
imagesc(getappdata(0,'Display_Image'));
axis image;


% --- Executes on button press in fit_lorentz_pushbtn.
function fit_lorentz_pushbtn_Callback(hObject, eventdata, handles)
% hObject    handle to fit_lorentz_pushbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
si = getappdata(0, 'SI');

%Update dump
process_string =strcat('Fit SI to a Lorentz peak within the range',...
    handles.plasmon_min_edit.String,' eV to',...
    handles.plasmon_max_edit.String,' eV.');

d = getappdata(0,'Dump');
dtxt = d.txt;
dtxt = strvcat(dtxt, process_string);
d.txt = dtxt;
setappdata(0, 'Dump', d);

%End update dump.
shftd_si_cell = si.processedSIcell;
min_ev = str2double(handles.plasmon_min_edit.String);
max_ev = str2double(handles.plasmon_max_edit.String);
%
% Replace this section, so you can live update axes2.
[lorentzfit, lorentzgof] = fit_plasmon(shftd_si_cell,min_ev,max_ev,'Lorentz', handles.axes2);
%
si.LorentzFitCell = lorentzfit;
si.LorentzGofCell = lorentzgof;
setappdata(0,'SI', si);
