function varargout = Main_MENU(varargin)
%% Main_MENU MATLAB code for Main_MENU.fig
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Main_MENU_OpeningFcn, ...
                       'gui_OutputFcn',  @Main_MENU_OutputFcn, ...
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

function Main_MENU_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before Main_MENU is made visible.

    % Choose default command line output for Main_MENU
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

function varargout = Main_MENU_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.

    % Get default command line output from handles structure
    varargout{1} = handles.output;

%% OPTIONS:
%{
--- 1D Scalar (OneDScalar)
--- 2D Scalar (TwoDScalar)
--- 2D Vector (TwoDVector)
%}

function OneDScalar_Callback(hObject, eventdata, handles)
%% --- Executes on button press in OneDScalar.
    clc

	% Open choice window POD/DMD:
	POD_OR_DMD

	% Saves your choice of 1DS:
	disp(['You have chosen 1D scalar.']); % display message
	disp([' ']);
	String_An_Type = '1DS'; % create variable
	setappdata(0, 'String_An_Type', String_An_Type); % store under root

	% Close Main_MENU
	close(Main_MENU)

function TwoDScalar_Callback(hObject, eventdata, handles)
%% --- Executes on button press in TwoDScalar.
    clc

	% Open choice window POD/DMD:
	POD_OR_DMD

	% Saves your choice of 2DS:
	disp(['You have chosen 2D scalar.']); % display message
	disp([' ']);
	String_An_Type = '2DS'; % create variable
	setappdata(0, 'String_An_Type', String_An_Type); % store under root

	% Close Main_MENU
	close(Main_MENU)

function TwoDVector_Callback(hObject, eventdata, handles)
%% --- Executes on button press in TwoDVector.
    clc

	% Open choice window POD/DMD:
	POD_OR_DMD

	% Saves your choice of 2DV:
	disp(['You have chosen 2D vector.']); % display message
	disp([' ']);
	String_An_Type = '2DV'; % create variable
	setappdata(0, 'String_An_Type', String_An_Type); % store under root

	% Close Main_MENU
	close(Main_MENU)
