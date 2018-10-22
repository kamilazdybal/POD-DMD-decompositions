function varargout = EXPORT_DATA(varargin)
%% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @EXPORT_DATA_OpeningFcn, ...
                       'gui_OutputFcn',  @EXPORT_DATA_OutputFcn, ...
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

function EXPORT_DATA_OpeningFcn(hObject, eventdata, handles, varargin)
%% --- Executes just before EXPORT_DATA is made visible.
    % Choose default command line output for EXPORT_DATA
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

function varargout = EXPORT_DATA_OutputFcn(hObject, eventdata, handles) 
%% --- Outputs from this function are returned to the command line.
    % Get default command line output from handles structure
    varargout{1} = handles.output;

function case_name_Callback(hObject, eventdata, handles)
%% Specify case name:
    String_An_Type = getappdata(0, 'String_An_Type');
    String_Dec_Type = getappdata(0, 'String_Dec_Type');
    prompt = {'Name for your case:'};
    dlg_title = 'Case_Name';
    num_lines = 1;
    defaultans = {'Default_Name'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    Case_Name = char(answer{1});
    setappdata(0, 'Case_Name', Case_Name);
    eval(['mkdir(''', String_An_Type, '_', String_Dec_Type, '_', Case_Name, ''');'])
    eval(['cd(''', String_An_Type, '_', String_Dec_Type, '_', Case_Name, ''');'])
    Curr_Dir = pwd;
    setappdata(0, 'Curr_Dir', Curr_Dir);
    cd ..
    disp([' ']);
    disp(['Your case name is: ', Case_Name]);

function Approximation_Callback(hObject, eventdata, handles)
%% --- Executes on button press in Approximation.
    String_An_Type = getappdata(0, 'String_An_Type');
    String_Dec_Type = getappdata(0, 'String_Dec_Type');
    Curr_Dir = getappdata(0, 'Curr_Dir');

    if String_An_Type == '1DS'
        cd(Curr_Dir);
        if String_Dec_Type == 'DMD'
            D_DMD = getappdata(0, 'D_DMD');
            save('D_DMD.mat', 'D_DMD');
            cd ..
        elseif String_Dec_Type == 'POD'
            D_POD = getappdata(0, 'D_POD');
            save('D_POD.mat', 'D_POD');
            cd ..
        end

    elseif String_An_Type == '2DS'
        cd(Curr_Dir);
        if String_Dec_Type == 'DMD'
            U_DMD = getappdata(0, 'U_DMD');
            save('U_DMD.mat', 'U_DMD');
            cd ..
        elseif String_Dec_Type == 'POD'
            U_POD = getappdata(0, 'U_POD');
            save('U_POD.mat', 'U_POD');
            cd ..       
        end

    elseif String_An_Type == '2DV'
        cd(Curr_Dir);
        if String_Dec_Type == 'DMD'
            D_DMD=getappdata(0, 'U_DMD');
            [ns nt]=size(D_DMD);
            n_h=ns/2;
            U_DMD = D_DMD(1:1:n_h,:);
            V_DMD = D_DMD(n_h+1:1:end,:);
            save('U_DMD.mat', 'D_DMD');
            save('V_DMD.mat', 'D_DMD');
            cd ..
        elseif String_Dec_Type == 'POD'
            D_POD = getappdata(0, 'D_POD');
            [ns nt]=size(D_POD);
            n_h=ns/2;
            U_POD = D_POD(1:1:n_h,:);
            V_POD = D_POD(n_h+1:1:end,:);
            save('U_POD.mat', 'U_POD');
            save('V_POD.mat', 'V_POD');
            cd ..       
        end  
    end
    disp([' ']);
    disp(['The approximation of the results has been exported.'])

function gif_Callback(hObject, eventdata, handles)
%% --- Executes on button press in gif.
    String_An_Type = getappdata(0, 'String_An_Type');
    String_Dec_Type = getappdata(0, 'String_Dec_Type');
    Curr_Dir = getappdata(0, 'Curr_Dir');

    if String_An_Type == '1DS'
        if String_Dec_Type == 'DMD'
            D_DMD = getappdata(0, 'D_DMD');
            D = getappdata(0, 'D');
            rank_DMD = getappdata(0, 'rank_DMD');
            D_DMD_extend = getappdata(0, 'D_DMD_extend');
            y = getappdata(0, 'y');
            dt = getappdata(0, 'dt');
            DMD_1D_PLOT_GIF(D, rank_DMD, D_DMD_extend, y, dt, Curr_Dir)
        elseif String_Dec_Type == 'POD'
            D_POD = getappdata(0, 'D_POD');
            D = getappdata(0, 'D');
            rank_POD = getappdata(0, 'rank_POD');
            U_POD = getappdata(0, 'U_POD');
            S_POD = getappdata(0, 'S_POD');
            V_POD = getappdata(0, 'V_POD');
            dt = getappdata(0, 'dt');
            y = getappdata(0, 'y');
            POD_1D_PLOT_GIF(D, rank_POD, U_POD, S_POD, V_POD, y, dt, Curr_Dir);
        end

    elseif String_An_Type == '2DV'
        if String_Dec_Type == 'DMD'
            D_DMD=getappdata(0, 'U_DMD');
            [ns nt]=size(D_DMD);
            n_h=ns/2;
            U_DMD = D_DMD(1:1:n_h,:);
            V_DMD = D_DMD(n_h+1:1:end,:);
            rank_DMD = getappdata(0, 'rank_DMD');
            X = getappdata(0, 'X');
            Y = getappdata(0, 'Y');
            dt = getappdata(0, 'dt');
            DMD_2D_PLOT_GIF(U_DMD, V_DMD, rank_DMD, X, Y, dt, Curr_Dir)
        elseif String_Dec_Type == 'POD'
            D_POD=getappdata(0, 'D_POD');
            [ns nt]=size(D_POD);
            n_h=ns/2;
            U_POD = D_POD(1:1:n_h,:);
            V_POD = D_POD(n_h+1:1:end,:);
            rank_POD = getappdata(0, 'rank_POD');
            X = getappdata(0, 'X');
            Y = getappdata(0, 'Y');
            dt = getappdata(0, 'dt');
            POD_2D_PLOT_GIF(U_POD, V_POD, rank_POD, X, Y, dt, Curr_Dir)
        end

    elseif String_An_Type == '2DS'
        D_POD = getappdata(0, 'D_POD');
        [ns nt]=size(D_POD);
        U_POD = D_POD(1:1:ns/2,:);    
        V_POD = D_POD(ns/2+1:1:end,:);
        rank_POD = getappdata(0, 'rank_POD');
        X = getappdata(0, 'X');
        Y = getappdata(0, 'Y');
        dt = getappdata(0, 'dt');
        POD_2D_PLOT_GIF(U_POD, V_POD, rank_POD, X, Y, dt, Curr_Dir)
    end

    disp([' ']);
    disp(['The .gif file is saved.'])

function Modes_Callback(hObject, eventdata, handles)
%% --- Executes on button press in Modes.
    String_An_Type = getappdata(0, 'String_An_Type');
    String_Dec_Type = getappdata(0, 'String_Dec_Type');
    Curr_Dir = getappdata(0, 'Curr_Dir');

    if String_An_Type == '1DS'
        if String_Dec_Type == 'POD'
            D = getappdata(0, 'D');
            rank_POD = getappdata(0, 'rank_POD');
            U_POD = getappdata(0, 'U_POD');
            S_POD = getappdata(0, 'S_POD');
            V_POD = getappdata(0, 'V_POD');
            dt = getappdata(0, 'dt');
            y = getappdata(0, 'y');
            close(EXPORT_DATA)
            POD_1D_PLOT_MODES(D, rank_POD, U_POD, S_POD, V_POD, y, dt, Curr_Dir);
        elseif String_Dec_Type == 'DMD'
            D = getappdata(0, 'D');
            rank_DMD = getappdata(0, 'rank_DMD');
            Phi_extend = getappdata(0, 'Phi_extend');
            T_modes_extend = getappdata(0, 'T_modes_extend');
            dt = getappdata(0, 'dt');
            y = getappdata(0, 'y');
            close(EXPORT_DATA)
            DMD_1D_PLOT_MODES(D, rank_DMD, Phi_extend, ...
            T_modes_extend, y, dt, Curr_Dir)
        end
    
    elseif String_An_Type == '2DV'
        if String_Dec_Type == 'POD'
            r = getappdata(0, 'rank_POD');
            D_POD = getappdata(0, 'D_POD');
            U_POD = getappdata(0, 'DU_POD');
            V_POD = getappdata(0, 'DV_POD');
            X = getappdata(0, 'X');
            Y = getappdata(0, 'Y');
            dt = getappdata(0, 'dt');
            prompt = {'Export Mode:'};
            dlg_title = 'Select Mode';
            num_lines = 1;
            defaultans = {'1'};
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
            j = str2num(char(answer{1}));
            if j<=r                
                    POD_2D_PLOT_MODES(j, U_POD, V_POD,X, Y, dt, Curr_Dir);
            elseif j>r;
                disp('This mode does not exist.')
            end
        elseif String_Dec_Type == 'DMD'
            r = getappdata(0, 'rank_DMD');
            Help = getappdata(0, 'Phi_U');
            [ns nt]=size(Help);
            nh=ns/2;
            Phi_V = Help(nh+1:end,:);
            Phi_U=Help(1:1:nh,:);
            T_modesU = getappdata(0, 'T_modesU');
            bD=getappdata(0,'bU');
            lambda_i=getappdata(0, 'lambdaU_i');
            lambda_r=getappdata(0, 'lambdaU_r');
            V = getappdata(0, 'V');
            X = getappdata(0, 'X');
            Y = getappdata(0, 'Y');
            dt = getappdata(0, 'dt');        
            prompt = {'Export Mode:'};
            dlg_title = 'Select Mode';
            num_lines = 1;
            defaultans = {'1'};
            answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

            j = str2num(char(answer{1}));
            if j<=r                
                    DMD_2D_PLOT_MODES(j, Phi_U, Phi_V, T_modesU, T_modesU,lambda_r,lambda_i, V, X, Y, dt, bD,Curr_Dir);
            elseif j>r;
                disp('No Good Mode')

            end
        end
    end

    disp([' ']);
    disp(['Mode Exported.'])
