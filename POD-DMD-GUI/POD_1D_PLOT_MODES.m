%% POD_1D_PLOT_MODES function =======================================
% This function plots the .png file of the modes of the approximation
% ===================================================================

function POD_1D_PLOT_MODES(D, rank_POD, U_POD, S_POD, V_POD, ...
        y, dt, Curr_Dir)

% Definition of time span:
n_t = size(D,2);
t = [0:1:n_t-1]*dt;

%% Modes of the approximation: =====================================
%Select Mode:




% Window for including user-specified values:
prompt = {'Export Mode:'};
dlg_title = 'Select Mode';
num_lines = 1;
defaultans = {'1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

j = str2num(char(answer{1}));


if j>rank_POD
    disp(['j>',num2str(rank_POD),', not a good mode!'])
elseif j<=rank_POD
   hfig2 = figure(1);
    
    subplot(1,2,1)
    plot(y, U_POD(:,j)/norm(U_POD), 'b-')
    [M] = AXIS(12);
    set(gcf, 'color', 'w');
    title(['\Phi_{', num2str(j), '}']);

    subplot(1,2,2)
    plot(t, V_POD(:,j)/norm(V_POD), 'b-')
    [M] = AXIS(12);
    set(gcf, 'color', 'w');    
    title(['\psi_{', num2str(j), '}']);    

    drawnow 
  
   cd(Curr_Dir);
    print('-dpng', '-r500', ['MODES_1D_POD_r', ...
        num2str(j), '.png'])
    cd ..
    
     pause
    
    
    
end
    







end

    
    
    