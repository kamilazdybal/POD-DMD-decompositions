%% Pulsating Poiseuille Flow ========================================
% Approximating the velocity profile with eigenfunction expansion, 
% POD and DMD.
% ===================================================================
clc
clear
close all

%% Initial data: ====================================================
% USER INPUT ========================================================
TIME = 20;	% total time of the animation
W = 10;     % Womersley number
Pa = 60;    % dimensionless pressure coefficient
FONT = 16;  % fontsize for graphs
modes = 20;  % number of modes for all approximations (max 7)
dt = 0.05;  % time step
dy = 0.05;  % space step
% END OF USER INPUT =================================================
MODES = modes;	% number of modes in eigenfunction approximation
RANK = modes;   % number of modes in POD approximation
r = modes;      % number of modes in DMD approximation
nm = modes;     % number of first modes to draw

% Definition of colours for plotting:
red = [236 68 28] ./ 255;	% used for eigenfunction
blue = [3 105 172] ./ 255;	% used for POD
green = [34 139 34] ./ 255;	% used for DMD

% Initialize error matrices:
ERROR_EIG = zeros(MODES, 1);
ERROR_POD = zeros(RANK, 1);
ERROR_DMD = zeros(r, 1);

%% Analytical result from asymptotic complex solution: ==============
t = [0:dt:TIME]; n_t = length(t);    % time discretization
y = [-1:dy:1]; n_y = length(y);      % space discretization
u_A_r = zeros(n_y, n_t);             % initialize solution

% Construct real and imaginary parts:
for j = 1:length(t)
    
    Y = (1 - cosh(W*sqrt(1i).*y)./(cosh(W*sqrt(1i))))*1i*Pa/W.^2;
    u_A_r(:,j) = real(Y.*exp(1i*t(j)));
end

% Adding the mean flow component:
u_Mb = (1 - y.^2)*0.5;              % mean flow
u_M = repmat(u_Mb, length(t), 1);   % repeat solution
u_A_R = u_M' + u_A_r;               % real analytical solution

%% Eigenfunction approximation: =====================================
% Extended solution matrix (for plotting):
u_T_extend = zeros(n_y, MODES*n_t);

% Calculate the solution matrix for each mode:
for j = 1:1:MODES
    
n = [1:1:j]; % matrix of modes to include in the summation

% Initialize matrices:
Y = zeros(n_y, j);      % initialize spacial basis
A_n = zeros(j,j);       % initialize amplitude matrix
T = zeros(n_t, j);      % initialize temporal basis
U_A = zeros(n_t, n_y);	% initialize PDE solution

% Construct spatial basis:
for i = 1:1:length(n)
    
    N = 2*n(i) - 1;     % odd number in the series
    Y(:,i) = cos(N*pi*y/2);
end

% Construct the amplitudes:
for i = 1:1:length(n)
    
    N = 2*n(i) - 1;     % odd number in the series
    A_n(i,i) = (16*Pa) / (N*pi*sqrt((2*W)^4 + N^4*pi^4));
end

% Construct the temporal modes:
for i = 1:1:length(n)
    
    N = 2*n(i) - 1;     % odd number in the series
    T(:,i) = (-1)^(n(i)) * cos(t - atan((4*W^2) / (N^2*pi^2)));
end

% Assembly solution:
U_A  = Y * A_n * T';

% Adding the mean flow component:
u_Mb = (1 - y.^2) * 0.5;            % mean flow
u_M = repmat(u_Mb, length(t), 1);   % repeat solution
u_T = U_A + u_M';                   % eigenfunction solution

% Paste solution to the large matrix (for plotting):
u_T_extend(:, ((j - 1)*n_t + 1):1:(j*n_t)) = u_T;

% Compute the error of the current approximation:
ERROR_EIG(j) = abs(norm(u_T - u_A_R));
end

% Obtain elements from the diagonal:
sigma_A_n = diag(A_n); 

%% POD approximation: ===============================================
% SVD of the original solution matrix:
[U_POD, S_POD, V_POD] = svd(u_A_R);

for j = 1:1:RANK
    
    % Create a POD approximation:
    U_POD_approx = U_POD(:, 1:1:j) * ...
        S_POD(1:1:j, 1:1:j) * V_POD(:, 1:1:j)';
    % Compute the error of the current approximation:
    ERROR_POD(j) = abs(norm(U_POD_approx - u_A_R));
end

% Obtain elements from the diagonal:
sigma_POD = diag(S_POD);

%% DMD approximation: ===============================================
% Extended solution matrix (for plotting):
U_DMD_extend = zeros(n_y, r*n_t);
B = zeros(r,1);

% Calculate the solution matrix for each mode:
for j = 1:1:r
    
    % Define matrix D:
    D = u_A_R;
    
    % Construct data sets X1 and X2:
    X1 = D(:, 1:end-1); X2 = D(:, 2:end);
    
    % Compute the POD (SVD) of X1:
    [U, Sigma, V] = svd(X1, 'econ'); 
    
    % Approximate matrix X1 keeping only r elements of the sum:
    U = U(:, 1:1:j);            % retain only r modes in U
    Sigma = Sigma(1:j, 1:j);    % retain only r modes in Sigma
    V = V(:, 1:1:j);            % retain only r modes in V

    % Construct the propagator S:
    S = U' * X2 * V * inv(Sigma); 
    
    % Compute eigenvalues and eigenvectors of the matrix S:
    [PHI, MU] = eig(S); 
    
    % Extract frequencies from the diagonal:
    mu = diag(MU); 
    
    % Extract real and imaginary parts of frequencies:
    lambda_r = real(mu); lambda_i = imag(mu); 
    
    % Frequency in terms of pulsation:
    omega = log(mu)/dt;

    % Compute the DMD spatial modes:
    Phi = U * PHI;
    
    % Compute amplitudes with the least-squares method:
    b2 = inv(Phi' * Phi) * Phi' * X1(:,1);

    % Compute the DMD temporal modes:
    T_modes = zeros(j, n_t); 
        for i = 1:length(t)
            
            T_modes(:,i) = b2 .* exp(omega * t(i));
        end
        
    % Get the full DMD reconstruction:
    U_DMD = real(Phi * T_modes);

    % Paste solution to the large matrix (for plotting):
    U_DMD_extend(:, ((j - 1)*n_t + 1):1:(j*n_t)) = U_DMD;
    
    % Compute the error of the current approximation:
    ERROR_DMD(j) = abs(norm(U_DMD - u_A_R));

end


%% Plot of the eigenvalues circle: ==================================
hfig3 = figure(3);

% Definition of the circle in a complex plane:
radius = 1; z_Circle = radius * exp((0:0.1:(2*pi)) * sqrt(-1));
MAX_B = max(real(abs(b2)));
% Eigenvalues and complex circle:
stem3(lambda_r, lambda_i, real(abs(b2))/MAX_B, 'o', 'Markersize', 5, 'color', green, 'LineWidth', 1.5);
hold on
plot(real(z_Circle), imag(z_Circle), 'k-', 'LineWidth', 1)
[M] = AXIS(FONT);
set(gcf, 'color', 'w');
%title(['Eigenvalues circle for DMD with r = ', num2str(r)]);

% Save the plot:
print('-dpng', '-r500', 'Eigenvalues_circle.png')

%% Ending: ==========================================================
close all
%clc