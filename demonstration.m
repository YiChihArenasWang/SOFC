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

%% Fuel Reformer

[LNGflowrate,  H2Oflowrate, unreactedmethaneflowrate, COflowrate, H2Ounreactedflowrate, heatdot] = FuelReformer(H2dot);

%% 
figure(3);
plot(time, E);
xlabel("time (s)")
ylabel("Power Consumption (W)");
title('Power Consumption over time (Input to SOFC function)');

figure(4);
plot(time, H2dot);
xlabel("time (s)")
ylabel("Sample H2 flow rate (kg/s)");
title('Sample H2 flow rate over time (Output of SOFC and Input to Fuel Reformer function)');

figure(5);
plot(time, LNGflowrate);
hold on
plot(time, H2Oflowrate);
hold off;
xlabel("time (s)")
ylabel("Fuel reformer input flow rates(kg/s)");
legend('methane', 'steam');
title('Fuel reformer input flow rates for a given H2 flow rate over time');

figure(6);
plot(time, H2dot);
hold on;
plot(time, COflowrate);
hold on;
plot(time, unreactedmethaneflowrate);
hold on;
plot(time, H2Ounreactedflowrate);
hold off;
xlabel("time (s)")
ylabel("Sample fuel reformer output flow rates (kg/s)");
legend('H2', 'CO', 'unreacted methane', 'unreacted steam' );
title('Fuel reformer output flow rates over time');

figure(7);
plot(time, heatdot);
xlabel("time (s)")
ylabel("Heat per second needed (kJ/s)");
title("Heat per second needed over time");

totalmethane = sum(LNGflowrate.*dt); % each flow rate is at a time of one second so the sum 
% of the flow rate is the total mass
disp("The total methane consumption is: ");
disp(totalmethane);

totalwater = sum(H2Oflowrate.*dt);
totalunwater = sum(H2Ounreactedflowrate.*dt);
