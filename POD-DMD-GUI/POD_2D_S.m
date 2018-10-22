%% POD_2D_S function ================================================
% POD done on a 2D data set created by:
% - matrix U
% - vector X
% - vector Y
% ===================================================================

function [U_POD, UU_POD, UV_POD, SU_POD] = ...
        POD_2D_S(U, X, Y)
    
        %% Check the sizes of matrices U, V, X and Y:
        len_U = size(U,1);
        wid_U = size(U,2);
        len_X = length(X);
        len_Y = length(Y);

        if len_U == len_X * len_Y
        %% Initial definitions:
        % Changing NaN to zeros for the solid parts:
        U(isnan(U)) = 0;
        SPACE_X = X;                % extracting space X-coordinates
        SPACE_Y = Y;                % extracting space Y-coordinates
        n_x = length(SPACE_X);      % number of X-coordinates
        n_y = length(SPACE_Y);      % number of Y-coordinates
        n_t = size(U,2);            % number of time steps

        %% POD approximation:
        % SVD decomposition:
        [UU_POD, SU_POD, UV_POD] = svd(U, 'econ');
        HFIG=figure(1);
        stem(diag(SU_POD))
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
        U_POD = UU_POD(:,1:1:r) * SU_POD(1:1:r,1:1:r) * UV_POD(:,1:1:r)';

        % Change zeros to NaN to re-create solid parts:
        U_POD(U_POD == 0) = NaN;

        else
        disp(['Wrong matrix dimensions.'])

        U_POD = NaN; V_POD = NaN; UU_POD = NaN; VU_POD = NaN; ...
        UV_POD = NaN; VV_POD = NaN;
end
