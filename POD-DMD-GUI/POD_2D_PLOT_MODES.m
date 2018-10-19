%% POD_2D_PLOT_MODES function =======================================
% This function plots the .png file of the modes of the approximation
% ===================================================================

function POD_2D_PLOT_MODESPOD_2D_PLOT_MODES(r,U_POD, V_POD,X, Y, dt, Curr_Dir);

% Definition of time span:
n_t = size(V_POD,2);
t = [0:1:n_t-1]*dt;

% Definition of space:
SPACE_X = X;
SPACE_Y = Y;
n_Y = length(SPACE_Y);
n_X = length(SPACE_X);

%% Plotting spatial structures:
hfig1 = figure(1);
n_s=size(U_POD,1)/2
% Extract single columns representing a single spatial structure:
U_extr = U_POD(1:n_s,r);
V_extr = U_POD(n_s+1:end,r);

% Prepare the velocity components for plotting:
U_vel = reshape(U_extr ,n_Y, n_X);
V_vel = reshape(V_extr ,n_Y, n_X);


MODE = sqrt(U_vel.^2 + V_vel.^2);
MODE = MODE/(max(max(abs(MODE))));
MODE(MODE == 0) = NaN;
Hfig=figure(1)
% Spatial structures:
pcolor(SPACE_X, SPACE_Y, MODE);
[M] = AXIS(12);
set(gcf, 'color', 'w');
shading interp
colorbar
axis equal
grid off
daspect([1 1 1])
title(['POD spatial mode for r = ', num2str(r)]);
ylim([min(SPACE_Y) max(SPACE_Y)]);
xlim([min(SPACE_X) max(SPACE_X)]);
[M] = AXIS(12);
set(gcf, 'color', 'w');
    
cd(Curr_Dir);
print(Hfig,'-dpng', '-r500', ['Spatial_Modes_2D_POD_r', ...
    num2str(r), '.png'])
cd ..
pause
%% Plotting temporal structures:
hfig2 = figure(2);
temp_mode = V_POD(:,r);
temp_mode = temp_mode/(max(max(abs(temp_mode))));

plot(t, temp_mode, 'k-')
[M] = AXIS(12);
set(gcf, 'color', 'w');
title(['POD temporal mode for r = ', num2str(r)]);
ylim([min(temp_mode) max(temp_mode)]);
xlim([min(t) max(t)]);

cd(Curr_Dir);
print(hfig2 ,'-dpng', '-r500', ['Temp_Modes_2D_POD_r', ...
    num2str(r), '.png'])
cd ..


close(hfig2)






