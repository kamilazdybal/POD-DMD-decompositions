%% Pulsating Poiseuille flow
clc
clear

%% Initial data
% USER INPUT ---------------------------------------------------------------------
TIME = 10;   % Total time of the animation
MODES = 3; % Number of modes in eigenfunction approximation
RANK = 3;   % Number of modes in POD approximation (equal to rank of the matrix)
nm = 3;     % Number of first modes to draw (eigenfunction and POD)
W = 10;     % Womersley number (Case C2 by default)
Pa = 60;    % Dimensionless pressure coefficient (Case C2 by default)
FONT = 10;  % Fontsize for graphs
% END OF USER INPUT --------------------------------------------------------------

%% Analytical result from asymptotic complex solution
dt = 0.05; t = [0:dt:TIME]; n_t = length(t);    % Time discretization
dy = 0.05; y = [-1:dy:1]; n_y = length(y);      % Space discretization
u_A_r = zeros(n_y, n_t);    % Initialize solution

% Construct real and imaginary parts
for k = 1:length(t)
    Y = (1 - cosh(W*sqrt(1i).*y)./(cosh(W*sqrt(1i))))*1i*Pa/W.^2;   % Complex basis Y
    u_A_r(:,k) = real(Y.*exp(1i*t(k))); % Real part at time tk
end

% Adding back the mean component
u_Mb = (1 - y.^2)*0.5;
u_M = repmat(u_Mb, length(t), 1);   % Repeat it to obtain a matrix
u_A_R = u_M' + u_A_r;               % Real solution

%% Eigenfunction approximation
u_T_extend = zeros(n_y,MODES*n_t); % Extended solution matrix (for plotting)

% Calculate the solution matrix for each mode (MODES times)
for Mo = 1:1:MODES
n = [1:1:Mo]; % Matrix of modes to include in the summation
% Initialize Matrices
Y = zeros(n_y, Mo);     % Initialize spacial basis
A_n = zeros(Mo, Mo);    % Initialize amplitude matrix
T = zeros(n_t, Mo);     % Initialize temporal basis
U_A = zeros(n_t, n_y);  % Initialize PDE solution

% Construct Spatial Basis
for i = 1:1:length(n)
    N = 2*n(i) - 1; % Odd number in the series
    Y(:,i) = cos(N*pi*y/2);
end

% Construct the Amplitudes
for i = 1:1:length(n)
    N = 2*n(i) - 1; % Odd number in the series
    A_n(i,i) = (16*Pa) / (N*pi*sqrt((2*W)^4 + N^4*pi^4));
end

% Construct the Temporal Modes
for i = 1:1:length(n)
    N = 2*n(i) - 1; % Odd number in the series
    T(:,i) = (-1)^(n(i)) * cos(t - atan((4*W^2) / (N^2*pi^2)));
end

% Assembly solution
U_A  = Y * A_n * T';    % n_y x n_t matrix
% Recreate the complete solution adding back the mean flow
u_Mb = (1 - y.^2) * 0.5;
u_M = repmat(u_Mb, length(t), 1);
u_T = U_A + u_M';
u_T_extend(:,((Mo-1)*n_t + 1):1:(Mo*n_t)) = u_T;
end

sigma_A_n = diag(A_n); % diagonalize the eigenvalues matrix

%% Orthogonality check
% Check for spatial matrix Y
dot(Y(:,1),Y(:,2));
% Check for temporal matrix T
dot(T(:,1),T(:,2));

%% POD Approximation
% SVD of original solution matrix
[U_POD, S_POD, V_POD] = svd(u_A_R);
% Approximate the original matrix with lower rank matrices:
U_POD_approx = zeros(length(y),length(t));
sigma_POD = diag(S_POD);

%% Plot for first few spatial and temporal modes for both approximations
hfig1 = figure(1);
set(hfig1,'units','normalized','outerposition',[0 0 1 1]);
LABEL = {'Eigenfunction...', 'POD'};
% Plot for modes from eigenfunction expansion:
% Spatial
for i = 1:1:nm
        subplot(2,nm,i);
        plot(y,Y(:,i)/norm(Y),'r-');
        hold on
        [M] = AXIS(FONT);
        set(gcf,'color','w');
        title(['\phi_', num2str(i)]);
end
% Temporal
for i = 1:1:nm
        subplot(2,nm,i+nm);
        plot(t,T(:,i)/norm(T),'r-');
        hold on
        [M] = AXIS(FONT);
        set(gcf,'color','w');
        title(['\psi_', num2str(i)]);
end

% Plot for modes from POD:
% Spatial
for i = 1:1:nm
    subplot(2,nm,i);
    plot(y, U_POD(:,i), 'b-')
    [M] = AXIS(FONT);
    set(gcf,'color','w');
%    legend(LABEL)
end

%Temporal
for i = 1:1:nm
    subplot(2,nm,i+nm);
    plot(t, V_POD(:,i), 'b-')
    [M] = AXIS(FONT);
    set(gcf,'color','w');
%    legend(LABEL)
end

% print to .png here
print('-dpng','-r500',['Modes_T', num2str(TIME), '.png'])

%% Plot for amplitude decay for both approximations
hfig2 = figure(2);
set(hfig2, 'units', 'normalized', 'outerposition', [0 0 1 1]);
LABEL = {'Eigenfunction...', 'POD'};
MARKER = {'o', 's'};
% Getting the first element to normalize the plot later
norm_POD = sigma_POD(1);
norm_EIG = sigma_A_n(1);
% Use only MODES number of terms from the diagonal
Line_POD = sigma_POD(1:MODES)/norm_POD;
Line_A_n = sigma_A_n(1:MODES)/norm_EIG;

for Mo = 1:1:MODES
    % Plot for eigenfunction amplitude decay
    plot(Mo, sigma_A_n(Mo)/norm_EIG, MARKER{1}, 'color', 'r'); % Normalized plot
    [M] = AXIS(FONT);
    set(gcf,'color','w');
    hold on
    % Plot for POD amplitude decay
    plot(Mo, sigma_POD(Mo)/norm_POD, MARKER{2}, 'color', 'b'); % Normalized plot
    [M] = AXIS(FONT);
    set(gcf,'color','w');
    legend(LABEL);
    line([1:MODES],[Line_A_n], 'color', 'r');
    line([1:MODES], [Line_POD], 'color', 'b');
    title(['Amplitude decay rate (normalized)']);
end

% print to .png here
%print('-dpng', '-r500', 'Amplitude_decay.png')

%% Movie of a pulsating velocity profile for original solution and two approximations
filename = 'Movie_Modes.gif';  % Save file

MARKER = {':', '--', '-.'};
LABEL = {'Original..', 'U_1', 'U_2', 'U_3'};

for i = 1:1:length(t)
    hold off
    hfig3 = figure(3);
    % Plot for Eigenfunction Approximation
    subplot(1,2,1)
    ORIGINAL = u_A_R(:,i);
    plot(y, ORIGINAL, 'k-', 'linewidth', 1);
    [M] = AXIS(FONT);
    set(gcf,'color','w');
    hold on
    for Mo = 1:1:MODES
        EIGEN = u_T_extend(:,(n_t*(Mo-1)+i));
        plot(y, EIGEN, MARKER{Mo}, 'color', 'r');
        [M] = AXIS(FONT);
        set(gcf,'color','w');
    end
    title(['Eigenfunction approximation']);
    legend(LABEL);
    ylim([-0.5 1.5]);
    xlim([-1 1]);
    hold off
    % Plot for POD Approximation
    subplot(1,2,2)
    plot(y, ORIGINAL, 'k-', 'linewidth', 1);
    [M] = AXIS(FONT);
    set(gcf,'color','w');
    hold on
    for j = 1:1:RANK
        U_POD_approx = U_POD(:,1:1:j) * S_POD(1:1:j,1:1:j) * V_POD(:,1:1:j)';
        POD = U_POD_approx(:,i);
        plot(y, POD, MARKER{j}, 'color', 'b');
        [M] = AXIS(FONT);
        set(gcf,'color','w');
    end
    title(['POD approximation']);
    legend(LABEL);
    ylim([-0.5 1.5]);
    xlim([-1 1]);
    drawnow
%    print('-dpng', '-r500', 'Snapshot2.png')
    frame = getframe(3);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if i == 1;
        imwrite(imind, cm ,filename, 'gif', 'Loopcount', inf);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
    end
end