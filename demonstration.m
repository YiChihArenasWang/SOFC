clear

load("FC_power_required.mat");
E = thrust_power_required(2,:).*1000;
load("mission_t_v_h.mat");
M = mission_t_v_h(3,:);
V = mission_t_v_h(2,:);
T = 800;
pH2 = 0.98;
dt = 1;
cells = SOFCsize(E,T,pH2);
[H2dot,vapordot,heatdot,total_H2,total_vapor,total_heat,pdens,voltagedraw,currentdraw] = SOFC(E,T,pH2,dt,cells);

time = 0:(length(E)-1);
time = time.*dt;
%%
figure(1)

subplot(4,2,2)
plot(time,E, LineWidth=2)
xlabel('Time (s)','FontSize',14);
ylabel('Power Consumption (W)','FontSize',14)

subplot(4,2,1)
plot(time,M, LineWidth=2)
xlabel('Time (s)','FontSize',14);
ylabel('Altitude (m)','FontSize',14)
hold on
yyaxis right
plot(time,V, Linewidth=2);
ylabel('Velocity (m/s)','FontSize',14)

subplot(4,2,3)
plot(time,pdens, LineWidth=2)
xlabel('Time (s)','FontSize',14);
ylabel('Power Density (W/cm^2)','FontSize',14)

subplot(4,2,5)
plot(time,voltagedraw, LineWidth=2)
xlabel('Time (s)','FontSize',14);
ylabel('Voltage (V)','FontSize',14)

subplot(4,2,7)
plot(time,currentdraw, LineWidth=2)
xlabel('Time (s)','FontSize',14);
ylabel('Current Density (J/cm^2)','FontSize',14)


subplot(4,2,4)
plot(time,H2dot, LineWidth=2)
xlabel('Time (s)','FontSize',14);
ylabel('Hydrogen Consumption (kg/s)','FontSize',14)

subplot(4,2,6)
plot(time,heatdot, LineWidth=2)
xlabel('Time (s)','FontSize',14);
ylabel('Heat Flow (kJ/s)','FontSize',14)

subplot(4,2,8)
plot(time,vapordot, LineWidth=2)
xlabel('Time (s)','FontSize',14);
ylabel('Vapor Flow (kg/s)','FontSize',14)

%% fuel reformer
[LNGflowrate,  H2Oflowrate, unreactedmethaneflowrate, COflowrate, CO2flowrate, H2Ounreactedflowrate, heatflowrate, H2Ocheckfr, H2fr] = FuelReformer(H2dot);


figure(2);
subplot(4,1,1);
plot(time, E, LineWidth=2);
xlabel("time (s)", FontSize=14)
ylabel("Power Consumption (W)", FontSize=14);
title('Power Consumption over time (Input to SOFC function)', FontSize=14);

subplot(4,1,2);
plot(time, H2dot, LineWidth=2);
xlabel("time (s)", FontSize=14);
ylabel("H2 flow rate (kg/s)", FontSize=14);
title('H2 flow rate over time (Output of SOFC and Input to Fuel Reformer function)', FontSize=14);

% checking equations worked out right
subplot(4,1,3);
plot(time, H2Oflowrate, 'LineStyle',':', LineWidth=3);
hold on
plot(time, H2Ocheckfr, '--', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Steam Flow Rates(kg/s)", FontSize=14);
legend('steam from S/C ratio', 'steam calculated');
title('Steam Flow Rate Consistency Check', FontSize=14);

subplot(4,1,4);
plot(time, H2dot,'LineStyle',':', LineWidth=3);
hold on
plot(time, H2fr, '--', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("H2 flow rates(kg/s)", FontSize=14);
legend('H2 dot input', 'H2 flow rate calculated');
title('H2 Flow Rates Consistency Check', FontSize=14);

figure(3);
subplot(3,1,1);
plot(time, LNGflowrate, LineWidth=2);
hold on
plot(time, H2Oflowrate, LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Input Flow Rates(kg/s)", FontSize=14);
legend('methane', 'steam');
title('Fuel Reformer Input Flow Rates for a Given H2 Flow Rate over Time', FontSize=14);

subplot(3,1,2);
plot(time, unreactedmethaneflowrate, LineWidth=2);
hold on;
plot(time, H2Ounreactedflowrate, LineWidth=2);
hold on;
plot(time, H2dot, LineWidth=2);
hold on;
plot(time, COflowrate, LineWidth=2);
hold on;
plot(time, CO2flowrate, LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Output Flow Rates (kg/s)", FontSize=14);
legend('unreacted methane', 'unreacted steam', 'H2', 'CO', 'CO2');
title('Fuel Reformer Output Flow Rates over Time', FontSize=14)

subplot(3,1,3);
plot(time, heatflowrate, LineWidth=2);
xlabel("time (s)", FontSize=14);
ylabel("Heat per Second Needed (kJ/s)", FontSize=14);
title("Heat per Second Needed over Time", FontSize=14)


% display totals
totalmethane = sum(LNGflowrate.*dt); % each flow rate is at a time of one second so the sum 
% of the flow rate is the total mass
disp("The total methane consumption in kg is: ");
disp(totalmethane);
totalheatfromreformer = sum(heatflowrate.*dt);
disp("The total heat the reformer needs in kJ is: ");
disp(totalheatfromreformer);

% LNG Tank
% mass fraction = mass of fuel/(mass of fuel and mass of tank)
[tankmass] = LNGTank(LNGflowrate, dt);
disp("The mass of the LNG tank in kg would be: ");
disp(tankmass);

% enthalpy calculations
[totalheatflowrate, LNGheatingdot] = SystemHeatBalanceCalculations(LNGflowrate, heatflowrate, heatdot);
total_heat = sum(totalheatflowrate.*dt);
disp("The total enthalpy from heating up the LNG fuel and the fuel reformer and SOFC running in kJ is: ");
disp(total_heat);

figure(4);
plot(time, heatdot, LineWidth=2);
hold on;
plot(time, heatflowrate, LineWidth=2);
hold on;
plot(time, LNGheatingdot, LineWidth=2);
hold on;
plot(time, totalheatflowrate,LineWidth=2);
hold off;
xlabel("time (s)", FontSize=18);
ylabel("Heat per Second Needed (kJ/s)", FontSize=18);
title("Heat per Second Comparisons over Time", FontSize=18)
legend('SOFC Heat', 'Fuel Reformer Heat', 'Heat Required to Heat up Methane', 'Total System Heat', fontsize=18);

%%

[warray,wtank, wmin, winitial, SOFCvapordot, FRneeddot, FRreleasedot, t2, excessH2O, totalexhauststeam] = steamrecycle(vapordot,H2Oflowrate,H2Ounreactedflowrate, 30, 15);

figure(5) 


subplot(4,1,1);
plot(t2, FRneeddot, LineWidth=2);
hold on;
plot(t2, SOFCvapordot, LineWidth=2);
hold on;
plot(t2, FRreleasedot, LineWidth=2);
hold on;
hold off;
xlabel("time (s)", FontSize=13);
ylabel("Steam per Second (kg/s)", FontSize=13);
title("Steam per Second Comparisons over Time", FontSize=14);
legend('Steam into Reformer', 'Steam Created by SOFC', 'Unreacted Steam out of Reformer', fontsize=13);

subplot(4,1,2);
plot(t2, warray, LineWidth=2);
xlabel("time (s)", FontSize=13);
ylabel("Steam Balance (kg/s)", FontSize=13);
title("Steam Balance per Second Comparisons over Time", FontSize=14);

subplot(4,1,3);
plot(t2, wtank, LineWidth=2);
xlabel("time (s)", FontSize=13);
ylabel("Steam in Tank (kg)", FontSize=13);
title("Steam in Tank over Time", FontSize=14);

subplot(4,1,4);
plot(t2, excessH2O, LineWidth=2);
xlabel("time (s)", FontSize=13);
ylabel("Steam Exhaust (kg)", FontSize=13);
title("Steam Exhausted over Time", FontSize=14);

disp("The minimum amount of water needed in the tank in kg would be: ");
disp(wmin);
disp("The initial water amount in the tank in kg would be : ");
disp(winitial);
disp("The total amount of steam exhaust in kg is: ")
disp(totalexhauststeam);
