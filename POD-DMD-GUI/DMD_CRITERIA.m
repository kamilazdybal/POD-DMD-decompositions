function varargout = DMD_CRITERIA(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DMD_CRITERIA_OpeningFcn, ...
                   'gui_OutputFcn',  @DMD_CRITERIA_OutputFcn, ...
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

% --- Executes just before DMD_CRITERIA is made visible.
function DMD_CRITERIA_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for DMD_CRITERIA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = DMD_CRITERIA_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in DMD_POD_Preprocessed.
function DMD_POD_Preprocessed_Callback(hObject, eventdata, handles)

String_An_Type = getappdata(0, 'String_An_Type');

if String_An_Type == '1DS'

    % Prepare input for the 1D DMD function:
    D = getappdata(0, 'D');
    y = getappdata(0, 'y');
    dt = getappdata(0, 'dt');
    r = getappdata(0, 'rank_DMD');

    % Run the 1D DMD function:
    [lambda_r, lambda_i, D_DMD_extend, bD, Phi_extend, T_modes_extend] = DMD_1D(D, y, dt);

    % Save function outputs for later:
    setappdata(0, 'lambda_r', lambda_r);
    setappdata(0, 'lambda_i', lambda_i);
    setappdata(0, 'D_DMD_extend', D_DMD_extend);
    setappdata(0, 'bD', bD);
    setappdata(0, 'Phi_extend', Phi_extend);
    setappdata(0, 'T_modes_extend', T_modes_extend);

elseif String_An_Type == '2DS'

    % Prepare input for the 2D DMD function:
    U = getappdata(0, 'U');
    V = getappdata(0, 'V');
    X = getappdata(0, 'X');
    Y = getappdata(0, 'Y');
    dt = getappdata(0, 'dt');
    
    % Run the 2D DMD function:
    [lambdaU_r, lambdaU_i, lambdaV_r, lambdaV_i, U_DMD, ...
            V_DMD, bU, bV, Phi_U, Phi_V, T_modesU, T_modesV] = DMD_2D(U, V, X, Y, dt);
        
    % Save function outputs for later:
    setappdata(0, 'lambdaU_r', lambdaU_r);
    setappdata(0, 'lambdaU_i', lambdaU_i);
    setappdata(0, 'lambdaV_r', lambdaV_r);
    setappdata(0, 'lambdaV_i', lambdaV_i);    
    setappdata(0, 'U_DMD', U_DMD);
    setappdata(0, 'V_DMD', V_DMD);
    setappdata(0, 'bU', bU);
    setappdata(0, 'bV', bV);
    setappdata(0, 'Phi_U', Phi_U);
    setappdata(0, 'Phi_V', Phi_V);
    setappdata(0, 'T_modesU', T_modesU);
    setappdata(0, 'T_modesV', T_modesV);

elseif String_An_Type == '2DV'
    
    % Prepare input for the 2D DMD function:
    U = getappdata(0, 'U');
    V = getappdata(0, 'V');
    X = getappdata(0, 'X');
    Y = getappdata(0, 'Y');
    dt = getappdata(0, 'dt');
    
    % Run the 2D DMD function:
[r,lambdaU_r, lambdaU_i, U_DMD, bU,Phi_U, T_modesU] = DMD_2D(U, V, X, Y, dt);
        
    % Save function outputs for later:
    
    setappdata(0, 'rank_DMD', r);
    setappdata(0, 'lambdaU_r', lambdaU_r);
    setappdata(0, 'lambdaU_i', lambdaU_i);
    setappdata(0, 'U_DMD', U_DMD);    
    setappdata(0, 'bU', bU);   
    setappdata(0, 'Phi_U', Phi_U);    
    setappdata(0, 'T_modesU', T_modesU);

end

close(DMD_CRITERIA)

% --- Executes on button press in DMD_Circle_Based.
function DMD_Circle_Based_Callback(hObject, eventdata, handles)

DMD_Auto_Circle = 1;
setappdata(0, 'DMD_Auto_Circle', DMD_Auto_Circle);
disp([' ']);
disp(['You have chosen the automatic circle based.'])

close(DMD_CRITERIA)
