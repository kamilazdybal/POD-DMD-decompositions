function varargout = POD_DMD_beta_1(varargin)
% POD_DMD_BETA_1 MATLAB code for POD_DMD_beta_1.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @POD_DMD_beta_1_OpeningFcn, ...
                   'gui_OutputFcn',  @POD_DMD_beta_1_OutputFcn, ...
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

% --- Executes just before POD_DMD_beta_1 is made visible.
function POD_DMD_beta_1_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for POD_DMD_beta_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = POD_DMD_beta_1_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Import_DATA.
function Import_DATA_Callback(hObject, eventdata, handles)

IMPORT

% --- Executes on button press in Decompose.
function Decompose_Callback(hObject, eventdata, handles)

% Window for including user-specified values:
prompt = {'Specify timestep dt:'};
dlg_title = 'Specify timestep';
num_lines = 1;
defaultans = {'0.01'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

dt = str2num(char(answer{1}));
setappdata(0,'dt',dt);

% Read user's choices:
String_Dec_Type = getappdata(0,'String_Dec_Type');
String_An_Type = getappdata(0,'String_An_Type');

% Checks if he's got all the info he needs for specified dimension:
if String_An_Type == '1DS'

    try
    dt = getappdata(0,'dt');
    D = getappdata(0,'D');
    y = getappdata(0,'y');
    
    disp([' ']);
    disp(['Timestep: ', num2str(dt)])
    disp([' ']);
    disp(['Size of matrix D: ', num2str(size(D,1)), ' x ', num2str(size(D,2))])
    disp([' ']);
    disp(['Size of matrix y: ', num2str(size(y,1)), ' x ', num2str(size(y,2))])
    ERROR = 0;
    
    catch
    errorstring='Wrong data for 1D scalar.';
    dlgname='Error 1DS';
    h = errordlg(errorstring,dlgname);
    end
    
    if ERROR == 0 & String_Dec_Type == 'POD'
        POD_CRITERIA
    elseif ERROR == 0 & String_Dec_Type == 'DMD'
        DMD_CRITERIA
    else
        disp(['Unknown decomposition type.'])
    end

elseif String_An_Type == '2DS'
    
    try

    dt = getappdata(0,'dt');
    U = getappdata(0,'U');   
    X = getappdata(0,'X');
    Y = getappdata(0,'Y');
    
    disp([' ']);
    disp(['Timestep: ', num2str(dt)])
    disp([' ']);
    disp(['Size of matrix U: ', num2str(size(U,1)), ' x ', num2str(size(U,2))])
    disp([' ']);   
    disp(['Size of matrix X: ', num2str(size(X,1)), ' x ', num2str(size(X,2))])
    disp([' ']);
    disp(['Size of matrix Y: ', num2str(size(Y,1)), ' x ', num2str(size(Y,2))])
    ERROR = 0;

    catch
    errorstring='Wrong data for 2D scalar.';
    dlgname='Error 2DS';
    h = errordlg(errorstring,dlgname);
    end
    
    if ERROR == 0 & String_Dec_Type == 'POD'
        POD_CRITERIA
    elseif ERROR == 0 & String_Dec_Type == 'DMD'
        DMD_CRITERIA
    else
        disp(['Unknown decomposition type.'])
    end
    
elseif String_An_Type == '2DV'
    
    try

    dt = getappdata(0,'dt');
    U = getappdata(0,'U');
    V = getappdata(0,'V');
    X = getappdata(0,'X');
    Y = getappdata(0,'Y');
    
    disp([' ']);
    disp(['Timestep: ', num2str(dt)])
    disp([' ']);
    disp(['Size of matrix U: ', num2str(size(U,1)), ' x ', num2str(size(U,2))])
    disp([' ']);
    disp(['Size of matrix V: ', num2str(size(V,1)), ' x ', num2str(size(V,2))])
    disp([' ']);
    disp(['Size of matrix X: ', num2str(size(X,1)), ' x ', num2str(size(X,2))])
    disp([' ']);
    disp(['Size of matrix Y: ', num2str(size(Y,1)), ' x ', num2str(size(Y,2))])
    ERROR = 0;

    catch
    errorstring='Wrong data for 2D Vector.';
    dlgname='Error 2DV';
    h = errordlg(errorstring,dlgname);
    end
    
    if ERROR == 0 & String_Dec_Type == 'POD'
        POD_CRITERIA
    elseif ERROR == 0 & String_Dec_Type == 'DMD'
        DMD_CRITERIA
    else
        disp(['Unknown decomposition type.'])
    end
end

% --- Executes on button press in export_results.
function export_results_Callback(hObject, eventdata, handles)

EXPORT_DATA

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)

disp([' ']);
disp(['================']);
disp(['GUI closed.'])
disp(['================']);

close(POD_DMD_beta_1)
