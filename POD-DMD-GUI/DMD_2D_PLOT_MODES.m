%% DMD_2D_PLOT_MODES function =======================================
% This function plots the .png file of the modes of the approximation
% ===================================================================

function DMD_2D_PLOT_MODES(r, Phi_U, Phi_V, T_modesU, T_modesV,lambda_r,lambda_i, V, X, Y, dt, bD,Curr_Dir);

% Definition of time span:
n_t = size(V,2);
t = [0:1:n_t-1]*dt;

% Definition of space:
SPACE_X = X;
SPACE_Y = Y;
n_Y = length(SPACE_Y);
n_X = length(SPACE_X);

% Taking real values of the modes:
Phi_U = real(Phi_U);
Phi_V = real(Phi_V);
T_modesU = imag(T_modesU);
% T_modesV = real(T_modesV);

%% Plotting spatial structures:
hfig1 = figure(1);
% Extract single columns representing a single spatial structure:
U_extr = Phi_U(:,r);
V_extr = Phi_V(:,r);

% Prepare the velocity components for plotting:
U_vel = zeros(n_Y, n_X);
V_vel = zeros(n_Y, n_X);

% Re-structuring the matrix U_vel for the purpose of plotting:
for j = 1:1:n_X
    U_vel(:,j) = U_extr(((j-1)*n_Y+1):1:((j)*n_Y), :);
    V_vel(:,j) = V_extr(((j-1)*n_Y+1):1:((j)*n_Y), :);
end

MODE = sqrt(U_vel.^2 + V_vel.^2);
MODE = MODE/(max(max(abs(MODE))));
MODE(MODE == 0) = NaN;

% Spatial structures:
pcolor(SPACE_X, SPACE_Y, MODE);
[M] = AXIS(12);
set(gcf, 'color', 'w');
shading interp
colorbar
axis equal
grid off
daspect([1 1 1])
title(['DMD spatial mode for r = ', num2str(r)]);
ylim([min(SPACE_Y) max(SPACE_Y)]);
xlim([min(SPACE_X) max(SPACE_X)]);
[M] = AXIS(12);
set(gcf, 'color', 'w');
    
cd(Curr_Dir);
print(hfig1 ,'-dpng', '-r500', ['Spatial_Modes_2D_DMD_r', ...
    num2str(r), '.png'])
cd ..
pause
%% Plotting temporal structures:
hfig2 = figure(2);
temp_mode = T_modesU(r,:);
temp_mode = temp_mode/(max(max(abs(temp_mode))));

plot(t, temp_mode, 'k-')
[M] = AXIS(12);
set(gcf, 'color', 'w');
title(['DMD temporal mode for r = ', num2str(r)]);
ylim([min(temp_mode) max(temp_mode)]);
xlim([min(t) max(t)]);

cd(Curr_Dir);
print(hfig2,'-dpng', '-r500', ['Temp_Modes_2D_DMD_r', ...
    num2str(r), '.png'])
cd ..
pause



hfig3 = figure(3);

% Definition of the circle in a complex plane:
radius = 1; z_Circle = radius * exp((0:0.1:(2*pi)) * sqrt(-1));
MAX_B = max(real(abs(bD)));
% Eigenvalues and complex circle:
stem3(lambda_r, lambda_i, real(abs(bD))/MAX_B, 'o', 'Markersize', 5, 'color', [0 0 0], 'LineWidth', 1.5);
hold on
plot(real(z_Circle), imag(z_Circle), 'k-', 'LineWidth', 1)
stem3(lambda_r(r), lambda_i(r), real(abs(bD(r)))/MAX_B, 'o', 'Markersize', 9, 'color', [1 0 0], 'LineWidth', 1.5);

[M] = AXIS(14);
set(gcf, 'color', 'w');
xlim([-1.1 1.1])
ylim([-1.2 1.1])
%title(['Eigenvalues circle for DMD with r = ', num2str(r)]);

% Save the plot:
print(hfig3,'-dpng', '-r500', 'Eigenvalues_circle.png')
pause
close(3)



close(hfig1)
close(hfig2)