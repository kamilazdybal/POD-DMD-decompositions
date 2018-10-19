function varargout = POD_OR_DMD(varargin)
%% POD_OR_DMD MATLAB code for POD_OR_DMD.fig
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @POD_OR_DMD_OpeningFcn, ...
                       'gui_OutputFcn',  @POD_OR_DMD_OutputFcn, ...
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


% --- Executes just before POD_OR_DMD is made visible.
function POD_OR_DMD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to POD_OR_DMD (see VARARGIN)

% Choose default command line output for POD_OR_DMD
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes POD_OR_DMD wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = POD_OR_DMD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in DMD.
function DMD_Callback(hObject, eventdata, handles)
% hObject    handle to DMD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
POD_DMD_beta_1
disp(['You have chosen DMD.'])
disp([' ']);
String_Dec_Type = 'DMD';
setappdata(0,'String_Dec_Type',String_Dec_Type);
close(POD_OR_DMD)

% --- Executes on button press in POD.
function POD_Callback(hObject, eventdata, handles)
% hObject    handle to POD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
POD_DMD_beta_1
disp(['You have chosen POD.'])
disp([' ']);
String_Dec_Type = 'POD';
setappdata(0,'String_Dec_Type',String_Dec_Type);
close(POD_OR_DMD)
