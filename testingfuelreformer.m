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
%% 
time = 0:(length(E)-1);
time = time.*dt;



figure(1)

subplot(7,1,1)
plot(time,E)
xlabel('Time (s)');
ylabel('Power Consumption (W)',"Rotation",0)

subplot(7,1,2)
plot(time,pdens)
xlabel('Time (s)');
ylabel('Power Density (W/cm^2)',"Rotation",0)

subplot(7,1,3)
plot(time,voltagedraw)
xlabel('Time (s)');
ylabel('Voltage (V)',"Rotation",0)

subplot(7,1,4)
plot(time,currentdraw)
xlabel('Time (s)');
ylabel('Current Density (J/cm^2)',"Rotation",0)

subplot(7,1,5)
plot(time,H2dot)
xlabel('Time (s)');
ylabel('Hydrogen Consumption (kg/s)',"Rotation",0)

subplot(7,1,6)
plot(time,heatdot)
xlabel('Time (s)');
ylabel('Heat Flow (kJ/s)',"Rotation",0)


subplot(7,1,7)
plot(time,vapordot)
xlabel('Time (s)');
ylabel('Vapor Flow (kg/s)',"Rotation",0)

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
plot(time, LNGflowrate, 'o-', LineWidth=2);
hold on
plot(time, H2Oflowrate, 'o-', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Input Flow Rates(kg/s)", FontSize=14);
legend('methane', 'steam');
title('Fuel Reformer Input Flow Rates for a Given H2 Flow Rate over Time', FontSize=14);

subplot(3,1,2);
plot(time, H2dot, 'o-', LineWidth=2);
hold on;
plot(time, COflowrate, 'o-', LineWidth=2);
hold on;
plot(time, CO2flowrate, 'o-', LineWidth=2);
hold on;
plot(time, unreactedmethaneflowrate, 'o-', LineWidth=2);
hold on;
plot(time, H2Ounreactedflowrate, 'o-', LineWidth=2);
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
[enthalpyflowrate] = SystemEnthalpyCalculations(LNGflowrate, heatflowrate, heatdot);
total_enthalpy = sum(enthalpyflowrate.*dt);
disp("The total enthalpy from heating up the LNG fuel and the fuel reformer and SOFC running in kJ is: ");
disp(total_enthalpy);