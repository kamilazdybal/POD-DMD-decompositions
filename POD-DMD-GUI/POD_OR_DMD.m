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

function POD_OR_DMD_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before POD_OR_DMD is made visible.
    % Choose default command line output for POD_OR_DMD
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

function varargout = POD_OR_DMD_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
    % Get default command line output from handles structure
    varargout{1} = handles.output;

function DMD_Callback(hObject, eventdata, handles)
%% --- Executes on button press in DMD.
    POD_DMD_beta_1
    disp(['You have chosen DMD.'])
    disp([' ']);
    String_Dec_Type = 'DMD';
    setappdata(0,'String_Dec_Type',String_Dec_Type);
    close(POD_OR_DMD)

function POD_Callback(hObject, eventdata, handles)
%% --- Executes on button press in POD.
    POD_DMD_beta_1
    disp(['You have chosen POD.'])
    disp([' ']);
    String_Dec_Type = 'POD';
    setappdata(0,'String_Dec_Type',String_Dec_Type);
    close(POD_OR_DMD)
