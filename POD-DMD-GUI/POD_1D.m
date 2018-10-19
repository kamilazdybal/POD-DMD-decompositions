%% POD_1D function ==================================================
% POD done on a 1D data set created by:
% - matrix D
% - vector y
% ===================================================================

function [D_POD, U_POD, S_POD, V_POD] = POD_1D(D, r)
% SVD of original solution matrix:
[U_POD, S_POD, V_POD] = svd(D);

% POD Approximation:
D_POD = U_POD(:,1:1:r) * S_POD(1:1:r,1:1:r) * V_POD(:,1:1:r)';
end