%% POD_2D function ==================================================
% POD done on a 2D data set created by:
% - matrix U
% - matrix V
% - vector X
% - vector Y
% ===================================================================

function [U_POD, V_POD, UU_POD, VU_POD, UV_POD, VV_POD] = ...
        POD_2D(U, V, X, Y, r)
    
%% Check the sizes of matrices U, V, X and Y: =======================
len_U = size(U,1);
len_V = size(V,1);
wid_U = size(U,2);
wid_V = size(V,2);
len_X = length(X);
len_Y = length(Y);

if len_U == len_V && len_U == len_X * len_Y && wid_U == wid_V
%% Initial definitions: =============================================
% Changing NaN to zeros for the solid parts:
V(isnan(V)) = 0;
U(isnan(U)) = 0;

SPACE_X = X;                % extracting space X-coordinates
SPACE_Y = Y;                % extracting space Y-coordinates
n_x = length(SPACE_X);      % number of X-coordinates
n_y = length(SPACE_Y);      % number of Y-coordinates
n_t = size(V,2);            % number of time steps

%% POD approximation: ===============================================
% SVD of original solution matrix:
[UU_POD, SU_POD, VU_POD] = svd(U, 'econ');
[UV_POD, SV_POD, VV_POD] = svd(V, 'econ');

% POD Approximation:
U_POD = UU_POD(:,1:1:r) * SU_POD(1:1:r,1:1:r) * VU_POD(:,1:1:r)';
V_POD = UV_POD(:,1:1:r) * SV_POD(1:1:r,1:1:r) * VV_POD(:,1:1:r)';

% Change zeros to NaN to re-create solid parts:
U_POD(U_POD == 0) = NaN;
V_POD(V_POD == 0) = NaN;

else
    disp(['Wrong matrix dimensions.'])
    
    U_POD = NaN; V_POD = NaN; UU_POD = NaN; VU_POD = NaN; ...
	UV_POD = NaN; VV_POD = NaN;
end
