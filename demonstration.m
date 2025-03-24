clear

E = struct2array(load("FC_power_required.mat"));
E = E(2,:);
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
plot(time, E, LineWidth=2);
xlabel("time (s)", FontSize=14)
ylabel("Power Consumption (W)", FontSize=14);
title('Power Consumption over time (Input to SOFC function)', FontSize=14);

subplot(4,1,2);
plot(time, H2dot, LineWidth=2);
xlabel("time (s)", FontSize=14);
ylabel("Sample H2 flow rate (kg/s)", FontSize=14);
title('Sample H2 flow rate over time (Output of SOFC and Input to Fuel Reformer function)', FontSize=14);

% checking equations worked out right
subplot(4,1,3);
plot(time, H2Oflowrate, 'LineStyle',':', LineWidth=3);
hold on
plot(time, H2Ocheckfr, LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Fuel reformer input flow rates(kg/s)", FontSize=14);
legend('steam from S/C ratio', 'steam calculated');
title('Checking steam flow rates match', FontSize=14);

subplot(4,1,4);
plot(time, H2dot, 'LineStyle',':', LineWidth=3);
hold on
plot(time, H2fr, LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Fuel reformer input flow rates(kg/s)", FontSize=14);
legend('H2 dot input', 'H2 flow rate calculated');
title('Checking H2 flow rates match', FontSize=14);

figure(3);
subplot(3,1,1);
plot(time, LNGflowrate, LineWidth=2);
hold on
plot(time, H2Oflowrate, LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Fuel reformer input flow rates(kg/s)", FontSize=14);
legend('methane', 'steam');
title('Fuel reformer input flow rates for a given H2 flow rate over time', FontSize=14);

subplot(3,1,2);
plot(time, H2dot, LineWidth=2);
hold on;
plot(time, COflowrate, LineWidth=2);
hold on;
plot(time, CO2flowrate, LineWidth=2);
hold on;
plot(time, unreactedmethaneflowrate, LineWidth=2);
hold on;
plot(time, H2Ounreactedflowrate, LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Sample fuel reformer output flow rates (kg/s)", FontSize=14);
legend('H2', 'CO', 'CO2', 'unreacted methane', 'unreacted steam');
title('Fuel reformer output flow rates over time', FontSize=14)

subplot(3,1,3);
plot(time, heatflowrate, LineWidth=2);
xlabel("time (s)", FontSize=14);
ylabel("Heat per second needed (kJ/s)", FontSize=14);
title("Heat per second needed over time", FontSize=14)


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
tankmassratio = 0.935;
massfuelandtank = totalmethane/tankmassratio;
masstank = massfuelandtank - totalmethane;
disp("The mass of the LNG tank in kg would be: ");
disp(masstank);

% enthalpy calculations
[enthalpyflowrate] = SystemEnthalpyCalculations(LNGflowrate, heatflowrate, heatdot);
total_enthalpy = sum(enthalpyflowrate.*dt);
disp("The total enthalpy from heating up the LNG fuel and the fuel reformer and SOFC running in kJ is: ");
disp(total_enthalpy);