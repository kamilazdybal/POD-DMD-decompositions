%% DMD_1D_PLOT_MODES function =======================================
% This function plots the .png file of the modes of the approximation
% ===================================================================

function DMD_1D_PLOT_MODES(D, rank_DMD, Phi_extend, ...
        T_modes_extend, y, dt, Curr_Dir)

% Definition of time span:
n_t = size(D,2);
t = [0:1:n_t-1]*dt;

%% Modes of the approximation: ======================================

% Window for including user-specified values:
prompt = {'Export Mode:'};
dlg_title = 'Select Mode';
num_lines = 1;
defaultans = {'1'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

j = str2num(char(answer{1}));



 %Compute the approximation
  range_l=n_t*(rank_DMD-1);
  
   PHI_DMD=Phi_extend(:,range_l:1:end);
   T_Modes=T_modes_extend(end-rank_DMD+1:end,:);
    

     lambda_r=getappdata(0, 'lambda_r');
     lambda_i=getappdata(0, 'lambda_i');
     bD=getappdata(0, 'bD');

if j>rank_DMD
    disp(['j>',num2str(rank_DMD),', not a good mode!'])
elseif j<=rank_DMD
   hfig2 = figure(1);
    
    
   
    subplot(1,2,1)
    plot(y, Phi_extend(:,j), 'r-');
    [M] = AXIS(12);
    set(gcf, 'color', 'w');
    title(['\Phi_{', num2str(j), '}']);      

    
    subplot(1,2,2)
    plot(t,  T_Modes(j,:), 'r-');
    [M] = AXIS(12);
    set(gcf, 'color', 'w');
    title(['\psi_{', num2str(j), '}']);  

    drawnow
    

    cd(Curr_Dir);
    print('-dpng', '-r500', ['MODES_1D_DMD_r', ...
        num2str(j), '.png'])
    cd ..
    pause
    close(hfig2)
    
hfig3 = figure(3);

% Definition of the circle in a complex plane:
radius = 1; z_Circle = radius * exp((0:0.1:(2*pi)) * sqrt(-1));
MAX_B = max(real(abs(bD)));
% Eigenvalues and complex circle:
stem3(lambda_r, lambda_i, real(abs(bD))/MAX_B, 'o', 'Markersize', 5, 'color', [0 0 0], 'LineWidth', 1.5);
hold on
plot(real(z_Circle), imag(z_Circle), 'k-', 'LineWidth', 1)
stem3(lambda_r(j), lambda_i(j), real(abs(bD(j)))/MAX_B, 'o', 'Markersize', 9, 'color', [1 0 0], 'LineWidth', 1.5);

[M] = AXIS(14);
set(gcf, 'color', 'w');
xlim([-1.1 1.1])
ylim([-1.2 1.1])
%title(['Eigenvalues circle for DMD with r = ', num2str(r)]);

% Save the plot:
print('-dpng', '-r500', 'Eigenvalues_circle.png')
pause
close(3)
    
end