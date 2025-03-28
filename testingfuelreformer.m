clear;
close all;
clc;

% testing WSG
E = [10000 8000 4000 2000 1000 5000 20000 0];
T = 800;
pH2 = 0.98;
dt = 1;
cells = SOFCsize(E,T,pH2);
[H2dot,vapordot,heatdot,total_H2,total_vapor,total_heat,pdens,voltagedraw,currentdraw] = SOFC(E,T,pH2,dt,cells);

time = 0:(length(E)-1);
time = time.*dt;
%%
figure(1)

subplot(4,2,[1 2])
plot(time,E, LineWidth=2)
xlabel('Time (s)','FontSize',13);
ylabel('Power Consumption (W)','FontSize',13)

subplot(4,2,3)
plot(time,pdens, LineWidth=2)
xlabel('Time (s)','FontSize',13);
ylabel('Power Density (W/cm^2)','FontSize',13)

subplot(4,2,5)
plot(time,voltagedraw, LineWidth=2)
xlabel('Time (s)','FontSize',13);
ylabel('Voltage (V)','FontSize',13)

subplot(4,2,7)
plot(time,currentdraw, LineWidth=2)
xlabel('Time (s)','FontSize',13);
ylabel('Current Density (J/cm^2)','FontSize',13)


subplot(4,2,4)
plot(time,H2dot, LineWidth=2)
xlabel('Time (s)','FontSize',13);
ylabel('Hydrogen Consumption (kg/s)','FontSize',13)

subplot(4,2,6)
plot(time,heatdot, LineWidth=2)
xlabel('Time (s)','FontSize',13);
ylabel('Heat Flow (kJ/s)','FontSize',13)

subplot(4,2,8)
plot(time,vapordot, LineWidth=2)
xlabel('Time (s)','FontSize',13);
ylabel('Vapor Flow (kg/s)','FontSize',13)
%% fuel reformer
[LNGflowrate,  H2Oflowrate, unreactedmethaneflowrate, COflowrate, CO2flowrate, H2Ounreactedflowrate, heatflowrate, H2Ocheckfr, H2fr] = FuelReformer(H2dot);


figure(2);
subplot(4,1,1);
plot(time, E, 'o-', LineWidth=2);
xlabel("time (s)", FontSize=14)
ylabel("Power Consumption (W)", FontSize=14);
title('Power Consumption over time (Input to SOFC function)', FontSize=14);

subplot(4,1,2);
plot(time, H2dot, 'o-', LineWidth=2);
xlabel("time (s)", FontSize=14);
ylabel("H2 flow rate (kg/s)", FontSize=14);
title('H2 flow rate over time (Output of SOFC and Input to Fuel Reformer function)', FontSize=14);

% checking equations worked out right
subplot(4,1,3);
plot(time, H2Oflowrate, 'o', 'LineStyle',':', LineWidth=3);
hold on
plot(time, H2Ocheckfr, 'square-', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Steam Flow Rates(kg/s)", FontSize=14);
legend('steam from S/C ratio', 'steam calculated');
title('Steam Flow Rate Consistency Check', FontSize=14);

subplot(4,1,4);
plot(time, H2dot, 'o','LineStyle',':', LineWidth=3);
hold on
plot(time, H2fr, 'square-', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("H2 flow rates(kg/s)", FontSize=14);
legend('H2 dot input', 'H2 flow rate calculated');
title('H2 Flow Rates Consistency Check', FontSize=14);

figure(3);
subplot(3,1,1);
plot(time, LNGflowrate, 'o-b', LineWidth=2);
hold on
plot(time, H2Oflowrate, 'o-r', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Input Flow Rates(kg/s)", FontSize=14);
legend('methane', 'steam');
title('Fuel Reformer Input Flow Rates for a Given H2 Flow Rate over Time', FontSize=14);

subplot(3,1,2);
plot(time, H2dot, 'o-g', LineWidth=2);
hold on;
plot(time, COflowrate, 'o-m', LineWidth=2);
hold on;
plot(time, CO2flowrate, 'o-c', LineWidth=2);
hold on;
plot(time, unreactedmethaneflowrate, 'o-b', LineWidth=2);
hold on;
plot(time, H2Ounreactedflowrate, 'o-r', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Output Flow Rates (kg/s)", FontSize=14);
legend('H2', 'CO', 'CO2', 'unreacted methane', 'unreacted steam');
title('Fuel Reformer Output Flow Rates over Time', FontSize=14)

subplot(3,1,3);
plot(time, heatflowrate, 'o-', LineWidth=2);
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
plot(time, heatdot, 'o-', LineWidth=2);
hold on;
plot(time, heatflowrate, 'o-', LineWidth=2);
hold on;
plot(time, LNGheatingdot, 'o-', LineWidth=2);
hold on;
plot(time, totalheatflowrate, 'o-', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14);
ylabel("Heat per Second Needed (kJ/s)", FontSize=14);
title("Heat per Second Comparisons over Time", FontSize=14)
legend('SOFC Heat', 'Fuel Reformer Heat', 'Heating up LNG Heating Required', 'Total System Heat');

[warray,wtank,winitial, SOFCvapordot, FRneeddot, FRreleasedot, t2] = water(vapordot,H2Oflowrate,H2Ounreactedflowrate, 4, 2);

figure(5) 


subplot(3,1,1);
plot(t2, FRneeddot, LineWidth=2);
hold on;
plot(t2, SOFCvapordot, LineWidth=2);
hold on;
plot(t2, FRreleasedot, LineWidth=2);
hold on;
hold off;
xlabel("time (s)", FontSize=14);
ylabel("Steam per Second (kg/s)", FontSize=14);
title("Steam per Second Comparisons over Time", FontSize=14);
legend('Steam into Reformer', 'Steam Created by SOFC', 'Unreacted Steam out of Reformer');

subplot(3,1,2);
plot(t2, warray, LineWidth=2);
xlabel("time (s)", FontSize=14);
ylabel("Steam Balance (kg/s)", FontSize=14);
title("Steam Balance per Second Comparisons over Time", FontSize=14);

subplot(3,1,3);
plot(t2, wtank, LineWidth=2);
xlabel("time (s)", FontSize=14);
ylabel("Steam Needed From Tank (kg/s)", FontSize=14);
title("Steam Needed From Tank per Second over Time", FontSize=14);

disp("The initial water amount needed in the tank in kg would be : ");
disp(winitial);
