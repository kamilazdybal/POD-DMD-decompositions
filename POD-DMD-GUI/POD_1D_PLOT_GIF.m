%% POD_1D_PLOT_GIF function =========================================
% This function plots the .gif file of the approximation
% ===================================================================

function POD_1D_PLOT_GIF(D, rank_POD, U_POD, S_POD, V_POD, ...
        y, dt, Curr_Dir)
hfig1 = figure(1);
MARKER = {':', '--', '-.', '--', '--'};
LABEL = {'Original..', 'U_1', 'U_2', 'U_3', 'U_4', 'U_5'};

% Definition of time span:
n_t = size(D,2);
t = [0:1:n_t-1]*dt;

filename = (['GIF_1D_POD_r', num2str(rank_POD), '.gif']);
x_min=min(y);
x_max=max(y);
y_min=min(D(:));
y_max=max(D(:));


prompt = {'x min:','x max','y_min','y_max'};
dlg_title = 'Plot Axes';
num_lines = 1;
defaultans = {num2str(x_min),num2str(x_max),num2str(y_min),num2str(y_max)};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
x_min=str2num(answer{1});
x_max=str2num(answer{2});
y_min=str2num(answer{3});
y_max=str2num(answer{4});

POD1D_approx = U_POD(:, 1:1:rank_POD)*...
        S_POD(1:1:rank_POD, 1:1:rank_POD)*V_POD(:, 1:1:rank_POD)';

%% .gif of a pulsating velocity profile with approximations: ========
for i = 1:1:length(t)
    
    
    % Plot of the original matrix D:
    plot(y, D(:, i), 'k-');
    [M] = AXIS(12);
    set(gcf, 'color', 'w');
    
    % Plot of the POD approximation:
    hold on
    
    plot(y,POD1D_approx(:,i),'r-.*')    
    
    
%     for j = 1:1:rank_POD
%         POD1D_approx = U_POD(:, 1:1:j) * ...
%             S_POD(1:1:j, 1:1:j) * V_POD(:, 1:1:j)';
%         plot(y, POD1D_approx(:,i), MARKER{j}, 'color', 'b');
%         [M] = AXIS(12);
%         set(gcf, 'color', 'w');
%     end
     title(['POD approximation']);
     legend('Data','Approximation')
    drawnow 
    xlim([x_min x_max]);
    ylim([y_min y_max]);
    hold off
    drawnow

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
