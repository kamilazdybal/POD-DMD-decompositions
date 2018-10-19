%% DMD_1D function ==================================================
% DMD done on a 1D data set created by:
% - matrix D
% - vector y
% ===================================================================

function [lambda_r, lambda_i, D_DMD_extend, bD, Phi_extend, ...
        T_modes_extend] = DMD_1D(D, y, dt)

%% Check the sizes of matrices D and y: =============================
len_D = size(D,1);
len_y = length(y);

if len_D == len_y
%% Initial definitions: =============================================
n_t = size(D,2);	% number of time steps
n_y = size(D,1);    % number of space y-coordinates


%% DMD approximation: ===============================================
% Construct data sets X1 and X2:
X1 = D(:, 1:end - 1); X2 = D(:, 2:end);



[UD, SigmaD, VD] = svd(X1, 'econ');

HFIG=figure(1)
stem(diag(SigmaD))

pause



% Window for including user-specified values:
prompt = {'Specify rank r:'};
dlg_title = 'Specify rank';
num_lines = 1;
defaultans = {'1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

rank_DMD = str2num(char(answer{1}));
setappdata(0, 'rank_DMD', rank_DMD);

disp([' ']);
disp(['Rank chosen for DMD analysis: ', num2str(rank_DMD)])

close(1)
r=rank_DMD;

%% Create extended output matrices to containt all ranks ============
% approximations up to r:
D_DMD_extend = zeros(n_y, r*n_t); % solution
T_modes_extend = zeros((1+r)*r/2, n_t); % temporal structures
Phi_extend = zeros(n_y, (1+r)*r/2); % spatial structures
start = 1;




for i = 1:1:r
% Compute the POD (SVD) of X1:
[UD, SigmaD, VD] = svd(X1, 'econ');

% Approximate matrix X1 keeping only r elements of the sum:
UD = UD(:, 1:1:i);          % filter: retain only r modes in U
SigmaD = SigmaD(1:1:i, 1:1:i); % filter: retain only r modes in Sigma
VD = VD(:, 1:1:i);          % filter: retain only r modes in V

% Construct the propagator S:
S = UD' * X2 * VD * inv(SigmaD);

% Compute eigenvalues and eigenvectors of the matrix S:
[PHI, MU] = eig(S); % eigenvalue decomposition of matrix S

% Extract frequencies:
mu = diag(MU);

% Extract real and imaginary parts of frequencies:
lambda_r = real(mu); lambda_i = imag(mu);

% Frequency in terms of pulsation:
omega = log(mu)/dt;	% computing natural log

% Compute DMD spatial modes:
Phi = UD * PHI;

% Compute DMD amplitudes with the least-squares method:
bD = inv(Phi' * Phi) * Phi' * X1(:,1);

% Define temporal behaviour:
TIME = [0:1:n_t - 1] * dt;

% Initialize temporal modes matrix:
T_modes = zeros(i, n_t);

% Compute DMD temporal modes:
for j = 1:length(TIME)
    T_modes(:,j) = bD .* exp(omega * TIME(j));
end

% Get the real part of the DMD reconstruction:
D_DMD = real(Phi * T_modes);

% Paste current solutions into the right place in extended matrices:
D_DMD_extend(:, ((i - 1)*n_t + 1):1:(i*n_t)) = D_DMD;
start = start + (i-1);
T_modes_extend((start:1:start+(i-1)), :) = real(T_modes);
Phi_extend(:, (start:1:start+(i-1))) = real(Phi);
end

else
    disp(['Wrong matrix dimensions.'])
    
    lambda_r = NaN; lambda_i = NaN; D_DMD = NaN; bD = NaN;
end