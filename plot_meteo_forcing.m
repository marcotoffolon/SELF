% ------------------
% PLOTS of the meteorological forcing in one winter
% ------------------

t1 = meteo(iw).t1-t_4deg(iw);
t2 = meteo(iw).t2-t_4deg(iw);
t_ini = min(t2); t_end = max(t2);
tline = [N_dat(iw) N_dat(iw)];
tlim = [0 max(t2)];

% create figure for plots of meteorological variables
figure

% T air e T water
subplot(2,2,1); hold on;
yyaxis left; 
plot(t1,meteo(iw).Tair);
ylabel('T air [°C]');
yyaxis right; 
plot(t2,meteo(iw).LSWT);
ylabel('T water [°C]');
line(tline,[min(meteo(iw).LSWT) max(meteo(iw).LSWT)],'color','k','linestyle',':');
xlim(tlim);
title([lake,' (winter ',int2str(iw),')']);

% wind
subplot(2,2,2); hold on;
yyaxis left; 
plot(t1,meteo(iw).W);
plot(t1,meteo(iw).W3);
ylabel('W [m/s]');
yyaxis right; 
plot(t1,forc(iw).Cdrag); 
ylabel('C_{drag} [-]');
line(tline,[min(forc(iw).Cdrag) max(forc(iw).Cdrag)],'color','k','linestyle',':');
xlim(tlim);
legend('W','<W^3>^{1/3}');
title([datestr(meteo(iw).t2(1)),' - ',datestr(meteo(iw).t2(end))]);

% cloud cover and vapour pressure
subplot(2,2,3); hold on;
yyaxis left; 
plot(t1,meteo(iw).C);
ylabel('cloud [-]');
yyaxis right; 
plot(t1,meteo(iw).vap);
ylabel('p_{vap} [mbar]');
line(tline,[min(meteo(iw).vap) max(meteo(iw).vap)],'color','k','linestyle',':');
xlabel('t [d]');
xlim(tlim);

% energy fluxes
subplot(2,2,4); hold on;
yyaxis left; 
plot(t1,forc(iw).H_S);
plot(t1,forc(iw).H_A);
ylabel('H_{heat} [W/m^2]');
yyaxis right;
plot(t1,forc(iw).F_wind);
ylabel('P_{wind} [W/m^2]');
line(tline,[min(forc(iw).F_wind) max(forc(iw).F_wind)],'color','k','linestyle',':');
xlabel('t [d]');
xlim(tlim);
legend('H_S','H_A')

% save figure
if(saveall)
    saveas(gcf,[fold_fig,'meteo_',int2str(iw)],'png');
end
