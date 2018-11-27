clc
clear
close all
fnts = 4;
u = cell2mat(struct2cell(load('../../datasets/2D_Vector_Data_Reduced/U.mat')));
v = cell2mat(struct2cell(load('../../datasets/2D_Vector_Data_Reduced/V.mat')));
v(isnan(v)) = 0;
u(isnan(u)) = 0;
x = cell2mat(struct2cell(load('../../datasets/2D_Vector_Data_Reduced/X.mat')));
y = cell2mat(struct2cell(load('../../datasets/2D_Vector_Data_Reduced/Y.mat')));
[x, y] = meshgrid(x,y);
x = reshape(x, [1476,1]);
y = reshape(y, [1476,1]);
D = [u; v];
r = 4;
dt = 0.1;
n_s = 1476;
n_t = 128;

%% DMD approximation: ===============================================
% Construct data sets X1 and X2:
X1U = D(:,1:end-1); X2U = D(:,2:end);

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

%% Two equivalent computations (they are the same effectively):
% Compute DMD temporal modes:
for i = 1:length(TIME)
    T_modesU(:,i) = bU .* exp(omegaU * TIME(i));
end

% Compute DMD temporal modes:
for i = 1:length(TIME)
    T_modes_tryout(:,i) = bU .* muU.^(i-1);
end

% Get the real part of the DMD reconstruction:
U_DMD = real(Phi_U * T_modesU);
