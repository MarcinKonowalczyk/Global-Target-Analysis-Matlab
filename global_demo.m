% This is a simple demo of global target analysis of transient absorption
% data.
%
% Plese see the README.md in the main repositiory for more informaiton on
% global target analysis.
% https://github.com/MarcinKonowalczyk/Global-Target-Analysis-Matlab
%
% Written by Dr. Marcin Konowalczyk
% Timmel Group @ Oxford University

close all; clear; clc;

%% Make up some data
P = peaks(101); P = flipud(P(1:50,:))'; % Inbuilt peaks funciton
temporal_noise = 0.2*ones(size(P,1),1)*randn(1,size(P,2));
spectral_noise = 0.3*randn(size(P));
D = P + temporal_noise + spectral_noise; % Wavelength by time

wl = (1:size(P,1)) + 100; % Some wavelength axixs
t = (0:(size(P,2)-1))*0.01; % Some time axis

% Plot
figure(1); clf; hold on;
imagesc(t,wl,D);
xlabel('time');
ylabel('wavelength');
grid on; box on;
axis tight;
title('Raw madeup data');

%% Start with the kinetic model and get the spectra
% Use A->B->C->void model with three parameters: kAB, kBC and kCvoid

K = @(p) [-p(1) 0 0;p(1) -p(2) 0;0 p(2) -p(3)];
p0 = [1 20 5]; % Inital parameters (rate constants) guess
c0 = [1 0 0]; % Inital concnetrations
odefun = @(t,c) K(p0)*c;
[~,c] = ode113(odefun,t,c0);

% Plot
figure(1); clf; hold on;
plot(t,c);
xlabel('time'); ylabel('species fraction');
title('Initial guess of the A->B->C->void model')
legend('A','B','C');
grid on; box on;

show_fitting = false;
optimfun = @(p) global_optimfun_1(p,wl,t,D,show_fitting);
options = optimset('Display','Iter');
pf = fminsearch(optimfun,p0,options);
[~,T,S] = global_optimfun_1(pf,wl,t,D,true);
Dfit = (T*S)';

fprintf('Fitted rate constants:\n')
fprintf('kAB = %.3f\n',pf(1))
fprintf('kBC = %.3f\n',pf(2))
fprintf('kCvoid = %.3f\n',pf(3))

figure(3); clf;
s(1) = subplot(1,3,1);
imagesc(t,wl,D);
xlabel('time'); ylabel('wavelength');
grid on; box on; axis tight square;
title('Data');

s(2) = subplot(1,3,2);
imagesc(t,wl,Dfit);
xlabel('time'); ylabel('wavelength');
grid on; box on; axis tight square;
title('Fit');

subplot(1,3,3);
imagesc(t,wl,D-Dfit);
xlabel('time'); ylabel('wavelength');
grid on; box on; axis tight square;
title('Residuals');

s(2).ZLim = s(1).ZLim;

%% Start with the spectral model and get the kinetics

% Gaussial lineshape (c - center, w - width, h - height)
g = @(x,c,w,h) exp( -2.*log(2).*((x-c)./w).^2 ) .* h;
m = @(p) g(wl,p(1),p(2),p(3)) + g(wl,p(4),p(5),p(6)); % Model function
% Parameters defining the base spectral model
P = [124 12 -10 170 10  10 ; % Species 1 - two features
     144 14  65 163 20  30 ; % Species 2 - two features
       0  0   0 155 14 -35]; % Species 3 - only one -ve feature

S = [];
for j = 1:size(P,1)
    S(j,:) = m(P(j,:));
end

% Plot
figure(1); clf; hold on;
plot(wl,S)
xlim([min(wl) max(wl)]);
grid on; box on;
xlabel('wavelength'); ylabel('absorbance');
legend('A','B','C');
title('Initial guess of the Species-associated spectra');
drawnow;

show_fitting = false;
optimfun = @(p) global_optimfun_2(p,wl,t,D,P,show_fitting);
p0 = [0 0 0 0 0 0]; % Inital guess of parameters (no shifts)
options = optimset('Display','Iter');
pf = fminsearch(optimfun,p0,options);
[~,T,S] = global_optimfun_2(pf,wl,t,D,P,true);
Dfit = S'*T;

fprintf('Fitted parameters of model spectra:\n')
fprintf('A1 center = %.3f\n',P(1,1)+pf(1))
fprintf('A1 width = %.3f\n',P(1,2)+pf(2))
fprintf('A1 height* = %.3f\n',P(1,3))
fprintf('---\n');
fprintf('A2 center = %.3f\n',P(1,4)+pf(3))
fprintf('A2 width = %.3f\n',P(1,5)+pf(4))
fprintf('A2 height* = %.3f\n',P(1,6))
fprintf('---\n');
fprintf('C center = %.3f\n',P(3,4)+pf(5))
fprintf('C width = %.3f\n',P(3,5)+pf(6))
fprintf('C height* = %.3f\n',P(3,6))
fprintf('---\n');
fprintf('* - not fitted\n');

figure(3); clf;
s(1) = subplot(1,3,1);
imagesc(t,wl,D);
xlabel('time'); ylabel('wavelength');
grid on; box on; axis tight square;
title('Data');

s(2) = subplot(1,3,2);
imagesc(t,wl,Dfit);
xlabel('time'); ylabel('wavelength');
grid on; box on; axis tight square;
title('Fit');

subplot(1,3,3);
imagesc(t,wl,D-Dfit);
xlabel('time'); ylabel('wavelength');
grid on; box on; axis tight square;
title('Residuals');

s(2).ZLim = s(1).ZLim;
