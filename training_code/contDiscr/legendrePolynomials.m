%% Finding the relationship between a continuous and discrete
% evaluation of a norm of two polynomial functions
% ==============================================================
clc
clear
close all
FONT = 12;  % fontsize for graphs

%% Number of points to discretize the integration interval:
M = 100;

%% Discretizing the integration interval:
a = -1; b = 1;          % integration boundaries
step = (b-a)/(M - 1);   % discretization step
x = [a:step:b];         % x-axis discretization

%% Functions to be calculated (Legendre polynomials):
L3 = 1/2 * (5*x.^3 - 3*x);          % L3 as a vector
L4 = 1/8 * (35*x.^4 - 30*x.^2 + 3); % L4 as a vector

%% Approximation of a definite integral of L3 and L4 function:
Area_L3 = trapz(x,L3);  % approximation to the area below L3
Area_L4 = trapz(x,L4);  % approximation to the area below L4

%% Approximation of the inner product of L3 and L4:
IP = L3.*L4;            % multiplying the two functions L3 and L4

% Discrete calculation of the inner product:
IP_t = trapz(x, IP);        % discrete using trapz()
IP_d = dot(L3, L4);         % discrete using dot()
% ==============================================================
% NOTE: Since the functions in the Legendre basis are orthogonal,
% we expect the dot product between them to be approximately zero.
% ==============================================================

%% Approximation of the norm of function L3:
L3_L3 = L3.^2;              % multiplying L3 with itself

% Discrete calculation of the norm:
NL3_t = trapz(x,L3_L3);     % discrete using trapz()
NL3_n = norm(L3)^2/(M/2);	% discrete using norm()
NL3_d = dot(L3,L3)/(M/2);	% discrete using dot()

% Continuous calculation of the norm:
NL3_a = b^3*(25*b^4-42*b^2+21)/28-a^3*(25*a^4-42*a^2+21)/28;

%% Approximation of the norm of function L4:
L4_L4 = L4.^2;              % multiplying L4 with itself

% Discrete calculation of the norm:
NL4_t = trapz(x,L4_L4);     % discrete using trapz()
NL4_n = norm(L4)^2/(M/2);	% discrete using norm()
NL4_d = dot(L4,L4)/(M/2);	% discrete using dot()

% Continuous calculation of the norm:
NL4_a = b*(1225*b^8-2700*b^6+1998*b^4-540*b^2+81)/576- ...
    a*(1225*a^8-2700*a^6+1998*a^4-540*a^2+81)/576;

%% Matlab output:
disp(['Number of points for discretization: ', num2str(M)])
disp([' '])
disp(['Inner product of L3 and L4 using trapz: ', num2str(IP_t)])
disp(['Inner product of L3 and L4 using dot: ', num2str(IP_d)])
disp([' '])
disp(['Discrete norm of L3 using trapz: ', num2str(NL3_t)])
disp(['Discrete norm of L3 using norm: ', num2str(NL3_n)])
disp(['Discrete norm of L3 using dot: ', num2str(NL3_d)])
disp(['Continuous norm of L3 with analytical solution: ', ...
    num2str(NL3_a)])
disp([' '])
disp(['Discrete norm of L4 using trapz: ', num2str(NL4_t)])
disp(['Discrete norm of L4 using norm: ', num2str(NL4_n)])
disp(['Discrete norm of L4 using dot: ', num2str(NL4_d)])
disp(['Continuous norm of L4 with analytical solution: ', ...
    num2str(NL4_a)])
disp([' '])
disp(['Norm and dot product were divided by M/2.'])

%% Graph plot:
hfig1 = figure(1);

plot(x,L3, 'k--')
[M] = AXIS(FONT);
set(gcf, 'color', 'w');
hold on
plot(x,L4, 'b-')
[M] = AXIS(FONT);
set(gcf, 'color', 'w');

legend('L3', 'L4')
