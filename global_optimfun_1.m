function [diff,T,S] = global_optimfun_1(p,wl,t,D,plt)

% Make sure input parameters are within a sensible range
p(1:3) = abs(p(1:3)); % Rate constants must be positive

% Simulate the kinetics
K = @(p) [-p(1) 0 0;p(1) -p(2) 0;0 p(2) -p(3)];
c0 = [1 0 0]; % Inital concentrations
odefun = @(t,c) K(p)*c;
[~,T] = ode113(odefun,t,c0);

% Data matrix can be expressed as the product of the time evolution (T)
% and the species-associated spectra (S). T*S = D' is a system of linear
% equations which can be solved with the backslash (\) operator
S = T\D';

% Add a bit of correlation bewtween neighbouring points by smoothign the
% spectra with a 3p shape-preserving filter
S = sgolayfilt(S,1,3,[],2);

% Fitted data matrix
Dfit = (T*S)';

if plt %% Plot if required
    figure(2); clf;
    subplot(2,1,1);
    plot(wl,S);
    title('Species associated spectra');
    grid on; axis tight;
    xlabel('wavelength');
    ylabel('Data units'); % e.g. Absorption or dA
    
    subplot(2,1,2);
    plot(t,T);
    title('Temporal evolution');
    grid on; axis tight;
    xlabel('time');
    ylabel('Species fraction')
    
    drawnow;
end

% Meas square difference between the data and the fit
diff = mean((Dfit(:)-D(:)).^2);
end