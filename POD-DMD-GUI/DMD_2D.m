%% DMD_2D function ==================================================
% DMD done on a 2D data set created by:
% - matrix U
% - matrix V
% - vector X
% - vector Y
% ===================================================================

function [r,lambdaU_r, lambdaU_i, U_DMD, bU,Phi_U, T_modesU] ...
            = DMD_2D(U, V, X, Y, dt, r)
        
%% Check the sizes of matrices U, V, X and Y: =======================
len_U = size(U,1);
len_V = size(V,1);
wid_U = size(U,2);
wid_V = size(V,2);
len_X = length(X);
len_Y = length(Y);

if len_U == len_V && len_U == len_X * len_Y && wid_U == wid_V
    
%% Initial definitions: =============================================
% Changing NaN to zeros for the solid parts:
V(isnan(V)) = 0;
U(isnan(U)) = 0;

SPACE_X = X;                % extracting space X-coordinates
SPACE_Y = Y;                % extracting space Y-coordinates
n_x = length(SPACE_X);      % number of X-coordinates
n_y = length(SPACE_Y);      % number of Y-coordinates
n_t = size(V,2);            % number of time steps

D=[U;V];

%% User choice for rank: ============================================
[DU_POD, DS_POD, DV_POD] = svd(D, 'econ');

HFIG=figure(1);
stem(diag(DS_POD))
pause

% Window for including user-specified values:
prompt = {'Specify rank r:'};
dlg_title = 'Specify rank';
num_lines = 1;
defaultans = {'1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans)
rank_POD = str2num(char(answer{1}));
setappdata(0,'rank_POD',rank_POD);
r = getappdata(0, 'rank_POD');
disp([' ']);
disp(['Rank chosen for POD analysis: ', num2str(rank_POD)])
close (1)

%% DMD approximation: ===============================================
% Construct data sets X1 and X2:
X1U = D(:, 1:end - 1); X2U = D(:, 2:end);

% Compute the POD (SVD) of X1:
[UU, SigmaU, VU] = svd(X1U, 'econ');

% Approximate matrix X1 keeping only r elements of the sum:
UUn = UU(:, 1:1:r);          % filter: retain only r modes in U
SigmaUn = SigmaU(1:r, 1:r);  % filter: retain only r modes in Sigma
VUn = VU(:, 1:1:r);          % filter: retain only r modes in V

% Construct the propagator S:
SU = UUn' * X2U * VUn * inv(SigmaUn);

% Compute eigenvalues and eigenvectors of the matrix S:
[PHIU, MUU] = eig(SU);

% Extract frequencies:
muU = diag(MUU);

% Extract real and imaginary parts of frequencies:
lambdaU_r = real(muU);
lambdaU_i = imag(muU);

% Frequency in terms of pulsation:
omegaU = log(muU)/dt;     % computing natural log

% Compute DMD spatial modes:
Phi_U = UUn * PHIU;

% Compute DMD amplitudes with the least-squares method:
bU = inv(Phi_U' * Phi_U) * Phi_U' * X1U(:,1);

% Define temporal behaviour:
TIME = [0:1:n_t - 1] * dt;

% Initialize temporal modes matrix:
T_modesU = zeros(r, n_t);

% Compute DMD temporal modes:
for i = 1:length(TIME)
    T_modesU(:,i) = bU .* exp(omegaU * TIME(i));
end

% Get the real part of the DMD reconstruction:
U_DMD = real(Phi_U * T_modesU);

% Change zeros to NaN to re-create solid parts:
U_DMD(U_DMD == 0) = NaN;

else
    disp(['Wrong matrix dimensions.'])
    
    lambdaU_r = NaN; lambdaU_i = NaN; lambdaV_r = NaN; ...
	lambdaV_i = NaN; U_DMD = NaN; V_DMD = NaN; bU = NaN; ...
    bV = NaN; Phi_U = NaN; Phi_V = NaN; T_modesU = NaN; ...
    T_modesV = NaN;
end