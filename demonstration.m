clear

E = struct2array(load("FC_power_required.mat"));
T = 800;
pH2 = 0.98;
dt = 1;
cells = SOFCsize(E,T,pH2);
[H2dot,vapordot,heatdot,total_H2,total_vapor,total_heat,pdens,voltagedraw,currentdraw] = SOFC(E,T,pH2,dt,cells);

time = 0:(length(E)-1);
time = time.*dt;

figure(1)
title("Power/Voltage/Current Draw Over Time")

subplot(4,1,1)
plot(time,E)
xlabel('Time (s)');
ylabel('Power Consumption (W)')

subplot(4,1,2)
plot(time,pdens)
xlabel('Time (s)');
ylabel('Power Density (W/cm^2)')

subplot(4,1,3)
plot(time,voltagedraw)
xlabel('Time (s)');
ylabel('Voltage (V)')

subplot(4,1,4)
plot(time,currentdraw)
xlabel('Time (s)');
ylabel('Current Density (J/cm^2)')

figure(2)
title("Hydrogen/Heat/Vapor Over Time")
subplot(3,1,1)
plot(time,H2dot)
xlabel('Time (s)');
ylabel('Hydrogen Consumption (kg/s)')

subplot(3,1,2)
plot(time,heatdot)
xlabel('Time (s)');
ylabel('Heat Flow (kJ/s)')

subplot(3,1,3)
plot(time,vapordot)
xlabel('Time (s)');
ylabel('Vapor Flow (kg/s)')

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
ylabel("Sample H2 flow rate (kg/s)", FontSize=14);
title('Sample H2 flow rate over time (Output of SOFC and Input to Fuel Reformer function)', FontSize=14);

% checking equations worked out right
subplot(4,1,3);
plot(time, H2Oflowrate, 'o', 'LineStyle',':', LineWidth=3);
hold on
plot(time, H2Ocheckfr, 'square-', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Fuel reformer input flow rates(kg/s)", FontSize=14);
legend('steam from S/C ratio', 'steam calculated');
title('Checking steam flow rates match', FontSize=14);

subplot(4,1,4);
plot(time, H2dot, 'o', 'LineStyle',':', LineWidth=3);
hold on
plot(time, H2fr, 'square-', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Fuel reformer input flow rates(kg/s)", FontSize=14);
legend('H2 dot input', 'H2 flow rate calculated');
title('Checking H2 flow rates match', FontSize=14);

figure(3);
subplot(3,1,1);
plot(time, LNGflowrate, 'o-', LineWidth=2);
hold on
plot(time, H2Oflowrate, 'o-', LineWidth=2);
hold off;
xlabel("time (s)", FontSize=14)
ylabel("Fuel reformer input flow rates(kg/s)", FontSize=14);
legend('methane', 'steam');
title('Fuel reformer input flow rates for a given H2 flow rate over time', FontSize=14);

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
ylabel("Sample fuel reformer output flow rates (kg/s)", FontSize=14);
legend('H2', 'CO', 'CO2', 'unreacted methane', 'unreacted steam');
title('Fuel reformer output flow rates over time', FontSize=14)

subplot(3,1,3);
plot(time, heatflowrate, 'o-', LineWidth=2);
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

% mass fraction = mass of fuel/(mass of fuel and mass of tank)
tankmassratio = 0.935;
massfuelandtank = totalmethane/tankmassratio;
masstank = massfuelandtank - totalmethane;
disp("The mass of the LNG tank in kg would be: ");
disp(masstank);

% heating up methane calculations
deltaHvap = 510.4; % kJ/kg
Tf = 700 + 273.15; % K to heat up fuel reformer to
Ti = 110; % LNG storage temperature
Tbp = -161.5 + 273.15; % boiling point

% at 25 deg C vals below
CpCH4g =  2.226; % (kJ/(kg*K))
CpCH4l =  3.49; % (kJ/(kg*K))

% liquid heating to boiling point
q1= LNGflowrate.*CpCH4l.*(Tbp-Ti); % kg/s*(kJ/(kg*K))*K = kJ/s
q2 = LNGflowrate.*deltaHvap; %kJ/s
q3 = LNGflowrate.*CpCH4g.*(Tf-Tbp);

heatdotLNGheating = q1+q2+q3;

% combined enthalpy from methane heating, fuel reformer and SOFC
enthalpyflowrate = heatdotLNGheating+heatflowrate+heatdot;
total_enthalpy = sum(enthalpyflowrate.*dt);
disp("The total enthalpy from heating up the LNG fuel and the fuel reformer and SOFC running in kJ is: ");
disp(total_enthalpy);