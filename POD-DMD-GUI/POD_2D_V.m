%% POD_2D_V function ================================================
% POD done on a 2D data set created by:
% - matrix U
% - matrix V
% - vector X
% - vector Y
% ===================================================================

function [D_POD, DU_POD, DS_POD, DV_POD] = ...
        POD_2D_V(U, V, X, Y)
    
        %% Check the sizes of matrices U, V, X and Y:
        len_U = size(U,1);
        len_V = size(V,1);
        wid_U = size(U,2);
        wid_V = size(V,2);
        len_X = length(X);
        len_Y = length(Y);

        if len_U == len_V && len_U == len_X * len_Y && wid_U == wid_V
        %% Initial definitions:
        % Changing NaN to zeros for the solid parts:
        V(isnan(V)) = 0;
        U(isnan(U)) = 0;
        SPACE_X = X;                % extracting space X-coordinates
        SPACE_Y = Y;                % extracting space Y-coordinates
        n_x = length(SPACE_X);      % number of X-coordinates
        n_y = length(SPACE_Y);      % number of Y-coordinates
        n_t = size(V,2);            % number of time steps

        %% POD approximation:
        D=[U;V];
        % SVD of original solution matrix:
        [DU_POD, DS_POD, DV_POD] = svd(D, 'econ');
        HFIG=figure(1);
        stem(diag(DS_POD))
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
        disp(['Rank chosen for POD analysis: ', num2str(rank_POD)])
        close (1)

        % POD Approximation:
        D_POD = DU_POD(:,1:1:r) * DS_POD(1:1:r,1:1:r) * DV_POD(:,1:1:r)';

        % Change zeros to NaN to re-create solid parts:
         D_POD(D_POD == 0) = NaN;

        else
            disp(['Wrong matrix dimensions.'])

            U_POD = NaN; V_POD = NaN; UU_POD = NaN; VU_POD = NaN; ...
            UV_POD = NaN; VV_POD = NaN;
end
