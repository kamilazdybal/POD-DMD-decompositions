%% POD_2D_PLOT_GIF function =========================================
% This function plots the .gif file of the approximation
% ===================================================================

function POD_2D_PLOT_GIF(U_POD, V_POD, rank_POD, X, Y, dt, Curr_Dir)

% Definition of time span:
n_t = size(U_POD,2);
t = [0:1:n_t-1]*dt;

SPACE_X = X;
SPACE_Y = Y;
n_X = length(SPACE_X);
n_Y = length(SPACE_Y);

filename = (['GIF_2D_POD_r', num2str(rank_POD) '.gif']);

% Limit on the time of simulation:
if length(t) <=30
    sim_t = length(t);
else
    sim_t = 30;
end


V_M=sqrt(U_POD.^2+V_POD.^2);


c_min=min(V_M(:));
c_max=max(V_M(:));

prompt = {'c min:','c max'};
dlg_title = 'Plot Axes';
num_lines = 1;
defaultans = {num2str(c_min),num2str(c_max)};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
c_min=str2num(answer{1});
c_max=str2num(answer{2});







% .gif of a pulsating velocity profile with approximations: =========
for i = 1:1:sim_t
    
    % Extract i-th column from U_DMD and V_DMD:
    U_extr = U_POD(:,i);
    V_extr = V_POD(:,i);
    
     
    % Prepare the velocity components for plotting:
    
    U_vel=reshape(U_extr,n_Y,n_X);
    V_vel=reshape(V_extr,n_Y,n_X);
    [Xg Yg]=meshgrid(SPACE_X,SPACE_Y);
   
    VELOCITY = sqrt(U_vel.^2 + V_vel.^2);
    VELOCITY(VELOCITY == 0) = NaN;

    % Plotting the colour plot:
    hfig1 = figure(1);
    pcolor(SPACE_X, SPACE_Y, VELOCITY);
    [M] = AXIS(12);
    set(gcf, 'color', 'w');    
    shading interp
    colorbar
    axis equal
    grid off
    daspect([1 1 1])
    caxis([c_min c_max])
    title(['POD approximation with r = ', num2str(rank_POD)]);
    ylim([min(SPACE_Y) max(SPACE_Y)]);
    xlim([min(SPACE_X) max(SPACE_X)]);
    [M] = AXIS(12);
    set(gcf, 'color', 'w');
    drawnow
    hold off
    
    % Save the gif:
    cd(Curr_Dir);
    frame = getframe(1);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);

    if i == 1;
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', ...
            'append', 'DelayTime', 0.1);
    end
        cd ..
end

close(hfig1)
