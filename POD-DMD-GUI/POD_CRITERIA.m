function varargout = POD_CRITERIA(varargin)
%% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @POD_CRITERIA_OpeningFcn, ...
                       'gui_OutputFcn',  @POD_CRITERIA_OutputFcn, ...
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

function POD_CRITERIA_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before POD_CRITERIA is made visible.
    % Choose default command line output for POD_CRITERIA
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

function varargout = POD_CRITERIA_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
    % Get default command line output from handles structure
    varargout{1} = handles.output;

function POD_Manual_Callback(hObject, eventdata, handles)
%% --- Executes on button press in POD_Manual.
    String_An_Type = getappdata(0, 'String_An_Type');

    if String_An_Type == '1DS'
        % Prepare input for the 1D POD function:
        D = getappdata(0, 'D');   
        y = getappdata(0, 'y');
        r = getappdata(0, 'rank_POD');

        % Run the 2D POD function:
        [U_POD, UU_POD, UV_POD, US_POD] = POD_1D_S(D, y);

        % Save function outputs for later:
        setappdata(0, 'D_POD', D_POD);
        setappdata(0, 'U_POD', U_POD);
        setappdata(0, 'S_POD', S_POD);
        setappdata(0, 'V_POD', V_POD);

    elseif String_An_Type == '2DS'
        % Prepare input for the 2D POD function:
        U = getappdata(0, 'U');
        X = getappdata(0, 'X');
        Y = getappdata(0, 'Y');
        r = getappdata(0, 'rank_POD');

        % Run the 2D POD function:
        [U_POD, UU_POD, UV_POD, US_POD] = POD_2D_S(U, X, Y);

        % Save function outputs for later:
        setappdata(0, 'U_POD', U_POD);
        setappdata(0, 'UU_POD', UU_POD);
        setappdata(0, 'UV_POD', UV_POD);
        setappdata(0, 'US_POD', US_POD);
    
    elseif String_An_Type == '2DV'
        % Prepare input for the 2D DMD function:
        U = getappdata(0, 'U');
        V = getappdata(0, 'V');
        X = getappdata(0, 'X');
        Y = getappdata(0, 'Y');
        r = getappdata(0, 'rank_POD');

        % Run the 2D DMD function:
        [D_POD, DU_POD, DS_POD, DV_POD] = POD_2D_V(U, V, X, Y);

        % Save function outputs for later:
        setappdata(0, 'D_POD', D_POD);
        setappdata(0, 'DU_POD', DU_POD);
        setappdata(0, 'DS_POD', DS_POD);
        setappdata(0, 'DV_POD', DV_POD);
    end
    close(POD_CRITERIA)

function POD_Automatic_Slope_Callback(hObject, eventdata, handles)
%% --- Executes on button press in POD_Automatic_Slope.
% TO BE ADDED IN THE FUTURE
    POD_Auto_Slope = 1;
    POD_Auto_Sigma = 0;
    setappdata(0,'POD_Auto_Slope',POD_Auto_Slope);
    setappdata(0,'POD_Auto_Sigma',POD_Auto_Sigma);
    disp([' ']);
    disp(['You have chosen the automatic slope.']);
    close(POD_CRITERIA)

function POD_Automatic_Sigma_Callback(hObject, eventdata, handles)
%% --- Executes on button press in POD_Automatic_Sigma.
% TO BE ADDED IN THE FUTURE
    POD_Auto_Slope = 0;
    POD_Auto_Sigma = 1;
    setappdata(0,'POD_Auto_Slope',POD_Auto_Slope);
    setappdata(0,'POD_Auto_Sigma',POD_Auto_Sigma);
    disp([' ']);
    disp(['You have chosen the automatic sigma min.']);
    close(POD_CRITERIA)