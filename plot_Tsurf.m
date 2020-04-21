% ------------------
% PLOT SURFACE TEMPERATURE
% ------------------

maxt = max(N,N_dat(iw)); % limit of x-axis

figure

% water temperature
subplot(3,1,1);
plot(t,T_surf);
hold on;
if(1)
    plot(t,Treal);
    ylabel('LSWT [°C]');
end
plot(N,0,'db');
plot(N_dat(iw),0,'sr');
legend('SELF','data','location','southwest');
xlim([0 maxt]);
ylim([0 4.5]);
title(['(a) ',lake,', year ',int2str(years(yr_ice(iw)))]);

% heat
subplot(3,1,2);
bar(t1,-forc(iw).H_net);
axis ij
ylabel('H_{net} [W/m^2]');
xlim([0 maxt]);
pp = min(-forc(iw).H_net(1:maxt));
if (pp<0)
    ylim([min(pp*1.1,-50) max(-forc(iw).H_net(1:maxt))*1.1]);
else
    ylim([0 max(-forc(iw).H_net(1:maxt))*1.1]);
end
title('(b) net heat flux');

%wind
subplot(3,1,3);
bar(t1,forc(iw).F_wind);
ylabel('P_w [W/m^2]');
xlim([0 maxt]);
xlabel('time [day]');
title(['(c) wind power',' (\eta = ',num2str(eta,'%6.3e'),')']);
