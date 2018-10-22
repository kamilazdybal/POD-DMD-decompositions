%% POD_1D_S function ================================================
% POD done on a 1D data set created by:
% - matrix D
% - vector y
% ===================================================================

function [D_POD, U_POD, V_POD, S_POD] = ...
        POD_1D_S(D, y)
    
        %% Check the sizes of matrices D and y:   
        len_D = size(D,1);
        wid_D = size(D,2);
        len_y = length(y);
        
        if len_D == len_y
        % SVD decomposition:
        D = getappdata(0, 'D');
        [U_POD, S_POD, V_POD] = svd(D);
        HFIG=figure(1)
        stem(diag(S_POD))
        pause(3)
        
        % Window for including user-specified values:
        prompt = {'Specify rank r:'};
        dlg_title = 'Specify rank';
        num_lines = 1;
        defaultans = {'1'};
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
        rank_POD = str2num(char(answer{1}));
        setappdata(0,'rank_POD',rank_POD);
        r = getappdata(0, 'rank_POD');
        disp([' ']);
        disp(['Rank chosen for POD analysis: ', num2str(rank_POD)]);

        % POD Approximation:
        D_POD = U_POD(:,1:1:r) * S_POD(1:1:r,1:1:r) * V_POD(:,1:1:r)';
        close (1)
end