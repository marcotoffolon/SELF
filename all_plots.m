% ------------------
% PLOTS of water temperature's vertical profiles
% ------------------

% 1 - water temperature
subplot(1,3,1)
plot(T,z,'r');
axis ij; xlim([0 4.5]);
hold on;
xlabel('T [°C]');
ylabel('z [m]');
%plot(Tm,z,'--g');
title(['t = ',num2str(t(jday)),' d']);

% effect of mixing
y = T;
y(1:imix) = Tm(imix);
plot(y,z,'--g');
% effect of cooling
%plot(y(1:imix)-dT,z(1:imix),'c');
% linear cooling
plot(T2,z,'b','linewidth',1.5);
hold off;

% 2 - density anomaly
subplot(1,3,2)
plot(rho1,z,'r');
axis ij; xlim([-0.1 0.001]);
hold on;
xlabel('\rho'' [kg m^{-3}]');
plot(rhom,z,'--g');
hold off;

% energy required for mixing
subplot(1,3,3)
semilogx(Epot_mix,z,'r');
axis ij; xlim([1e-5 1e3]); %ylim([0 50]);
hold on;
xlabel('E [J m^{-2}]');
line([Epot_mix(j) Epot_mix(j)],[0 hmix],'color','b');
line([Epot_mix(j) Epot_mix(j)],[0 h],'color','k','linewidth',2,'linestyle',':');
hold off;

% actually execute the plots
drawnow
if(pauseplot)
    pause %(0.1)
end
