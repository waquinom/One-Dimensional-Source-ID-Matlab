function varargout = GuiDriver(varargin)
% GUIDRIVER MATLAB code for GuiDriver.fig
%      GUIDRIVER, by itself, creates a new GUIDRIVER or raises the existing
%      singleton*.
%
%      H = GUIDRIVER returns the handle to a new GUIDRIVER or the handle to
%      the existing singleton*.
%
%      GUIDRIVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDRIVER.M with the given input arguments.
%
%      GUIDRIVER('Property','Value',...) creates a new GUIDRIVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GuiDriver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GuiDriver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GuiDriver

% Last Modified by GUIDE v2.5 22-Mar-2018 14:47:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GuiDriver_OpeningFcn, ...
                   'gui_OutputFcn',  @GuiDriver_OutputFcn, ...
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

% --- Executes just before GuiDriver is made visible.
function GuiDriver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GuiDriver (see VARARGIN)

% Choose default command line output for GuiDriver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GuiDriver wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GuiDriver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function SolutionMethod_Callback(hObject, eventdata, handles)
% hObject    handle to SolutionMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SolutionMethod as text
%        str2double(get(hObject,'String')) returns contents of SolutionMethod as a double


% --- Executes during object creation, after setting all properties.
function SolutionMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SolutionMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global L A E freqs rho  constraints ...
 meaLocations nelemns forceGenerator noiselevel eigenvalsFrac...
 solutionMethod pcgIters ...
 pcgTol tikhonovPar regularizationOperator sourceElements

hold off

setInputParameters();

solutionMethod =  handles.SolutionMethod;
regularizationOperator = handles.regularizationOperator;
noiselevel = handles.nlevel;
tikhonovPar = handles.TikParam;
nelemns = handles.NoElements;
sourceElements = handles.NoForceBasis;
eigenvalsFrac = handles.NoModesSVD;
noMeasurements = handles.Measurements;
if (noMeasurements > (nelemns + 1))
    noMeasurements = nelemns  + 1;
end
meaLocations =randperm( nelemns + 1,noMeasurements);

[x, xsol, fsol, ftrue, usol, utrue] = sourceIDDriverForGui();

axes(handles.axes2);
plot(x, ftrue);
hold on
%PLotting the inverse problem solution
plot(xsol, fsol, '--');

set(gca, 'fontsize', 18, 'fontWeight','bold');
xlabel('X', 'fontsize', 18, 'fontWeight','bold')
ylabel('Force', 'fontsize', 18,'fontWeight', 'bold');
le=legend('Target Function', 'Inverse Solution');
set(le, 'fontsize', 18, 'fontWeight','bold')

%%Plot displacements
hold off
axes(handles.Displacements);
 plot(x, abs(usol(:,1)),'o');
 hold on
% xd = x(meaLocations);
 plot(x , abs(utrue));
 set(gca, 'fontsize', 18, 'fontWeight','bold');
xlabel('X', 'fontsize', 18, 'fontWeight','bold')
ylabel('Disp Magnitude', 'fontsize', 18,'fontWeight', 'bold');
le=legend('Estimated', 'Truth');
set(le, 'fontsize', 18, 'fontWeight','bold')

% --- Executes on selection change in SolMethod.
function SolMethod_Callback(hObject, eventdata, handles)
% hObject    handle to SolMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SolMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SolMethod
str = get(hObject,'String');
val = get(hObject,'Value');
switch(str{val})
    case 'LS'
        handles.SolutionMethod = 'ls';
    case 'pcg'
        handles.SolutionMethod = 'pcg';
    case 'SVD'
        handles.SolutionMethod = 'svd';
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function SolMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SolMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: place code in OpeningFcn to populate axes2



function tikParam_Callback(hObject, eventdata, handles)
% hObject    handle to tikParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tikParam as text
%        str2double(get(hObject,'String')) returns contents of tikParam as a double

str=get(hObject,'String');
handles.TikParam=str2double(str);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function tikParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tikParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Regularizer.
function Regularizer_Callback(hObject, eventdata, handles)
% hObject    handle to Regularizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Regularizer contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Regularizer
str = get(hObject,'String');
val = get(hObject,'Value');
switch(str{val})
    case 'H1'
        handles.regularizationOperator = 'H1';
    case 'L2'
        handles.regularizationOperator = 'L2';
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Regularizer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Regularizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NoiseLevel_Callback(hObject, eventdata, handles)
% hObject    handle to NoiseLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NoiseLevel as text
%        str2double(get(hObject,'String')) returns contents of NoiseLevel as a double
str=get(hObject,'String');
handles.nlevel = str2double(str);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function NoiseLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NoiseLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NoElements_Callback(hObject, eventdata, handles)
% hObject    handle to NoElements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NoElements as text
%        str2double(get(hObject,'String')) returns contents of NoElements as a double

str=get(hObject,'String');
handles.NoElements = str2double(str);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function NoElements_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NoElements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ForceMesh_Callback(hObject, eventdata, handles)
% hObject    handle to ForceMesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ForceMesh as text
%        str2double(get(hObject,'String')) returns contents of ForceMesh as a double


str=get(hObject,'String');
handles.NoForceBasis = str2double(str);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function ForceMesh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ForceMesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TSVDModes_Callback(hObject, eventdata, handles)
% hObject    handle to TSVDModes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TSVDModes as text
%        str2double(get(hObject,'String')) returns contents of TSVDModes as a double

str=get(hObject,'String');
handles.NoModesSVD = str2double(str);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function TSVDModes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TSVDModes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meatext_Callback(hObject, eventdata, handles)
% hObject    handle to meatext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meatext as text
%        str2double(get(hObject,'String')) returns contents of meatext as a double



% --- Executes during object creation, after setting all properties.
function meatext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meatext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function measurements_Callback(hObject, eventdata, handles)
% hObject    handle to measurements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of measurements as text
%        str2double(get(hObject,'String')) returns contents of measurements as a double

str=get(hObject,'String');
handles.Measurements = str2double(str);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function measurements_CreateFcn(hObject, eventdata, handles)
% hObject    handle to measurements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DPTag.
function DPTag_Callback(hObject, eventdata, handles)
% hObject    handle to DPTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global L A E freqs rho  constraints ...
 meaLocations nelemns forceGenerator noiselevel eigenvalsFrac...
 solutionMethod pcgIters ...
 pcgTol tikhonovPar regularizationOperator sourceElements

hold off

setInputParameters();

solutionMethod =  'ls';
regularizationOperator = handles.regularizationOperator;
noiselevel = handles.nlevel;
if (noiselevel<= 0)
    disp('Noise Level is Zero. Enter a value > 0')
    return;
end
nelemns = handles.NoElements;
sourceElements = handles.NoForceBasis;
noMeasurements = handles.Measurements;
if (noMeasurements > (nelemns + 1))
    noMeasurements = nelemns  + 1;
end
meaLocations =randperm( nelemns + 1,noMeasurements);

[x, xsol, fsol, ftrue, usol, utrue, alpha] = discrepanyPrinciple();

axes(handles.axes2);
plot(x, ftrue);
hold on
%PLotting the inverse problem solution
plot(xsol, fsol, '--');

set(gca, 'fontsize', 18, 'fontWeight','bold');
xlabel('X', 'fontsize', 18, 'fontWeight','bold')
ylabel('Force', 'fontsize', 18,'fontWeight', 'bold');
le=legend('Target Function', 'Inverse Solution');
set(le, 'fontsize', 18, 'fontWeight','bold');


%%Plot displacements
hold off
axes(handles.Displacements);
 plot(x, abs(usol(:,1)),'o');
 hold on
% xd = x(meaLocations);
 plot(x , abs(utrue));
 set(gca, 'fontsize', 18, 'fontWeight','bold');
xlabel('X', 'fontsize', 18, 'fontWeight','bold')
ylabel('Disp Magnitude', 'fontsize', 18,'fontWeight', 'bold');
le=legend('Estimated', 'Truth');
set(le, 'fontsize', 18, 'fontWeight','bold')

txt = ['Tikhonov Parameter = ',num2str(alpha)];
title(handles.Displacements,txt);

% --- Executes during object creation, after setting all properties.
function DPTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DPTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
