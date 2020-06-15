function [diff,T,S] = global_optimfun_2(p,wl,t,D,P,plt)

coerce = @(x,l,u)  max(min(x,u),l); % Coersce a value to range [l,u]

% Make sure input parameters are within a sensible range
I = [-1 1]; % -1 to 1 range
limits = [I*5;I*2;I*5;I*2;I*10;I*4]; % Ranges for all the parameters
for j = 1:numel(p)
    p(j) = coerce(p(j),limits(j,1),limits(j,2));
end

% Gaussial lineshape (c - center, w - width, h - height)
g = @(x,c,w,h) exp( -2.*log(2).*((x-c)./w).^2 ) .* h;
m = @(p) g(wl,p(1),p(2),p(3)) + g(wl,p(4),p(5),p(6)); % Model function
% Parametrize small shifts in magnitude and width of the components of
% secies A and C. Assume species B is well known. (<- This is just an
% example)
P = P + [p(1) p(2) 0 p(3) p(4) 0 ;
         0    0    0 0    0    0 ; 
         0    0    0 p(5) p(6) 0];

for j = 1:size(P,1)
    S(j,:) = m(P(j,:));
end

% Now the system of linear equations to solve is S'*T = D. The backslash
% operator can give negative values of T, hence use a dedicated nonnegative
% solver = lsqnonneg

%T = S'\D; % <- This can give negative results for T
for j = 1:size(D,2)
    T(:,j) = lsqnonneg(S',D(:,j));
end

% Add a bit of correlation bewtween neighbouring time points
T = sgolayfilt(T,1,3,[],2);
T(T<0) = 0; % Species fractions cannot be negative

% Fitted data matrix
Dfit = S'*T;

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