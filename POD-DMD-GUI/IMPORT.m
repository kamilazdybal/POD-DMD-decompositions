function varargout = IMPORT(varargin)
% IMPORT MATLAB code for IMPORT.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IMPORT_OpeningFcn, ...
                   'gui_OutputFcn',  @IMPORT_OutputFcn, ...
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

% --- Executes just before IMPORT is made visible.
function IMPORT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IMPORT (see VARARGIN)

% Choose default command line output for IMPORT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IMPORT wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = IMPORT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in OFFiles.
function OFFiles_Callback(hObject, eventdata, handles)
% hObject    handle to OFFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp(['Importing OpenFOAM files.'])

Main()

close(IMPORT)

% --- Executes on button press in TXTFILES.
function TXTFILES_Callback(hObject, eventdata, handles)
% hObject    handle to TXTFILES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp(['Importing TXT files will be added later!'])

close(IMPORT)

% --- Executes on button press in MATFILES.
function MATFILES_Callback(hObject, eventdata, handles)
% hObject    handle to MATFILES (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

String_Dec_Type = getappdata(0,'String_Dec_Type');
String_An_Type = getappdata(0,'String_An_Type');

if String_An_Type == '1DS'

    if String_Dec_Type == 'DMD'
        disp(['For 1D scalar DMD: import data as D.mat, y.mat'])
        [FileName, PathName] = uigetfile('*.mat', 'Select the DMD MATLAB files',...
             'MultiSelect', 'on');
         try
            D = cell2mat(struct2cell(load([PathName, filesep, 'D.mat'])));
            y = cell2mat(struct2cell(load([PathName, filesep, 'y.mat'])));
            setappdata(0,'D',D);
            setappdata(0,'y',y);
        catch
            disp(['Wrong matrix filenames. They should be: D.mat, y.mat'])
        end

    elseif String_Dec_Type == 'POD'
        disp(['For 1D scalar POD: import data as D.mat, y.mat'])
        [FileName, PathName] = uigetfile('*.mat', 'Select the POD MATLAB files',...
             'MultiSelect', 'on');
        try
            D = cell2mat(struct2cell(load([PathName, filesep, 'D.mat'])));
            y = cell2mat(struct2cell(load([PathName, filesep, 'y.mat'])));
            setappdata(0,'D',D);
            setappdata(0,'y',y);
        catch
            disp(['Wrong matrix filenames. They should be: D.mat, y.mat'])  
        end

    else
        disp(['Specify the decomposition method DMD or POD!'])
    end    

elseif String_An_Type == '2DS'

    if String_Dec_Type == 'DMD'
        disp(['For 2D scalar DMD: import data as U.mat, X.mat, Y.mat'])
        [FileName, PathName] = uigetfile('*.mat', 'Select the DMD MATLAB files',...
             'MultiSelect', 'on');

        try
            U = cell2mat(struct2cell(load([PathName, filesep, 'U.mat'])));          
            X = cell2mat(struct2cell(load([PathName, filesep, 'X.mat'])));
            Y = cell2mat(struct2cell(load([PathName, filesep, 'Y.mat'])));

            setappdata(0,'U',U);           
            setappdata(0,'X',X);
            setappdata(0,'Y', Y);
            
        catch
            disp(['Wrong matrix filenames. They should be: U.mat, V.mat, X.mat, Y.mat.'])
        end
        
    elseif String_Dec_Type == 'POD'
        disp(['For 2D scalar POD: import data as U.mat, X.mat, Y.mat'])
        [FileName, PathName] = uigetfile('*.mat', 'Select the POD MATLAB files',...
             'MultiSelect', 'on');

        try
            U = cell2mat(struct2cell(load([PathName, filesep, 'U.mat'])));          
            X = cell2mat(struct2cell(load([PathName, filesep, 'X.mat'])));
            Y = cell2mat(struct2cell(load([PathName, filesep, 'Y.mat'])));

            setappdata(0,'U',U);           
            setappdata(0,'X',X);
            setappdata(0,'Y', Y);
        catch
            disp(['Wrong matrix filenames. They should be: U.mat, V.mat, X.mat. Ymat.'])
        end

    else
        disp(['Specify the decomposition method DMD or POD!'])
    end

elseif String_An_Type == '2DV'
    
   
    if String_Dec_Type == 'DMD'
        disp(['For 2D scalar DMD: import data as U.mat, V.mat, X.mat, Y.mat'])
        [FileName, PathName] = uigetfile('*.mat', 'Select the DMD MATLAB files',...
             'MultiSelect', 'on');

        try
            U = cell2mat(struct2cell(load([PathName, filesep, 'U.mat'])));
            V = cell2mat(struct2cell(load([PathName, filesep, 'V.mat'])));
            X = cell2mat(struct2cell(load([PathName, filesep, 'X.mat'])));
            Y = cell2mat(struct2cell(load([PathName, filesep, 'Y.mat'])));

            setappdata(0,'U',U);
            setappdata(0,'V',V);
            setappdata(0,'X',X);
            setappdata(0,'Y', Y);
            
        catch
            disp(['Wrong matrix filenames. They should be: U.mat, V.mat, X.mat, Y.mat.'])
        end
        
    elseif String_Dec_Type == 'POD'
        disp(['For 2D scalar POD: import data as U.mat, V.mat, X.mat, Y.mat'])
        [FileName, PathName] = uigetfile('*.mat', 'Select the POD MATLAB files',...
             'MultiSelect', 'on');

        try
            U = cell2mat(struct2cell(load([PathName, filesep, 'U.mat'])));
            V = cell2mat(struct2cell(load([PathName, filesep, 'V.mat'])));
            X = cell2mat(struct2cell(load([PathName, filesep, 'X.mat'])));
            Y = cell2mat(struct2cell(load([PathName, filesep, 'Y.mat'])));

            setappdata(0,'U',U);
            setappdata(0,'V',V);
            setappdata(0,'X',X);
            setappdata(0,'Y', Y);
        catch
            disp(['Wrong matrix filenames. They should be: U.mat, V.mat, X.mat. Ymat.'])
        end

    else
        disp(['Specify the decomposition method DMD or POD!'])
    end

    
else
    
	disp(['Specify the dimension of the analysis!'])
    
end

close(IMPORT)
