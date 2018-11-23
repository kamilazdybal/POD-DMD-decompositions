%% Exact DMD
%{
Checking the difference between two approaches to compute DMD modes:
Phi_1 = Ur * W
Phi_2 = X2 * Vr * diag(1./diag(Sigmar)) * W
%}
clc
clear
close all
fnts = 4;
u = cell2mat(struct2cell(load('../../datasets/2D_Vector_Data_Reduced/U.mat')));
v = cell2mat(struct2cell(load('../../datasets/2D_Vector_Data_Reduced/V.mat')));
v(isnan(v)) = 0;
u(isnan(u)) = 0;
x = cell2mat(struct2cell(load('../../datasets/2D_Vector_Data_Reduced/X.mat')));
y = cell2mat(struct2cell(load('../../datasets/2D_Vector_Data_Reduced/Y.mat')));
[x, y] = meshgrid(x,y);
x = reshape(x, [1476,1]);
y = reshape(y, [1476,1]);
D = [u; v];
r = 4;
nunit = 1476;

% DMD:
X1 = D(:,1:end-1);
X2 = D(:,2:end);

[U, Sigma, V] = svd(X1, 'econ');
Ur = U(:, 1:r); Sigmar = Sigma(1:r, 1:r); Vr = V(:, 1:r);
plot(diag(Sigmar)/sum(diag(Sigma)), '-o')
Atilde = Ur' * X2 * Vr * diag(1./diag(Sigmar));
[W, D] = eig(Atilde);

%% DMD modes

% Phi_1:
Phi_1 = Ur * W;
Phi = sqrt(Phi_1(1:nunit, :).^2 + Phi_1(nunit+1:end, :).^2);
Phi(Phi == 0) = NaN;

figure(1)
subplot(r,3,1), scatter(x, y, 4, real(Phi(:, 1)), 'filled'), title(['Phi_1 = U_r W, mode 1']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;
subplot(r,3,4), scatter(x, y, 4, real(Phi(:, 2)), 'filled'), title(['Phi_1 = U_r W, mode 2']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;
subplot(r,3,7), scatter(x, y, 4, real(Phi(:, 3)), 'filled'), title(['Phi_1 = U_r W, mode 3']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;
subplot(r,3,10), scatter(x, y, 4, real(Phi(:, 4)), 'filled'), title(['Phi_1 = U_r W, mode 4']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;

% Phi_2
Phi_2 = X2 * Vr * diag(1./diag(Sigmar)) * W;
Phi = sqrt(Phi_2(1:nunit, :).^2 + Phi_2(nunit+1:end, :).^2);
Phi(Phi == 0) = NaN;

figure(1)
subplot(r,3,2), scatter(x, y, 4, real(Phi(:, 1)), 'filled'), title(['Phi_2 = X_2 V_r \Sigma_r^{-1} W, mode 1']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;
subplot(r,3,5), scatter(x, y, 4, real(Phi(:, 2)), 'filled'), title(['Phi_2 = X_2 V_r \Sigma_r^{-1} W, mode 2']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;
subplot(r,3,8), scatter(x, y, 4, real(Phi(:, 3)), 'filled'), title(['Phi_2 = X_2 V_r \Sigma_r^{-1} W, mode 3']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;
subplot(r,3,11), scatter(x, y, 4, real(Phi(:, 4)), 'filled'), title(['Phi_2 = X_2 V_r \Sigma_r^{-1} W, mode 4']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;

% Residual:
residual = Phi_1 - Phi_2;
residual = sqrt(residual(1:nunit, :).^2 + residual(nunit+1:end, :).^2);
residual(residual == 0) = NaN;

figure(1)
subplot(r,3,3), scatter(x, y, 4, real(residual(:, 1)), 'filled'), title(['Phi_1 - Phi_2, mode 1']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;
subplot(r,3,6), scatter(x, y, 4, real(residual(:, 2)), 'filled'), title(['Phi_1 - Phi_2, mode 2']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;
subplot(r,3,9), scatter(x, y, 4, real(residual(:, 3)), 'filled'), title(['Phi_1 - Phi_2, mode 3']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;
subplot(r,3,12), scatter(x, y, 4, real(residual(:, 4)), 'filled'), title(['Phi_1 - Phi_2, mode 4']), axis(['equal']), xlim([min(x) max(x)]), ylim([min(y) max(y)]), colorbar
ax = gca; ax.FontSize = fnts;
print('-dpng','-r500',['DMD_Modes_Phi.png'])

close all