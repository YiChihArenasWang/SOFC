clear

E = [10000 8000 4000 2000 1000 5000 20000 0];
T = 800;
pH2 = 0.98;
dt = 1;
[cells] = SOFCsize(E,T,pH2);
[H2dot,vapordot,heatdot,total_H2,total_vapor,total_heat,pdens,voltagedraw,currentdraw] = SOFC(E,T,pH2,dt,cells);
%% 
time = 0:(length(E)-1);
time = time.*dt;



figure(1)
title("Power/Voltage/Current Draw Over Time")

subplot(4,1,1)
plot(time,E,"LineWidth", 2)
xlabel('Time (s)','FontSize',13);
ylabel('Power Consumption (W)','FontSize',13)

subplot(4,1,2)
plot(time,pdens,"LineWidth", 2)
xlabel('Time (s)','FontSize',13);
ylabel('Power Density (W/cm^2)','FontSize',13)

subplot(4,1,3)
plot(time,voltagedraw,"LineWidth", 2)
xlabel('Time (s)','FontSize',13);
ylabel('Voltage (V)','FontSize',13)

subplot(4,1,4)
plot(time,currentdraw,"LineWidth", 2)
xlabel('Time (s)','FontSize',13);
ylabel('Current Density (J/cm^2)','FontSize',13)

figure(2)
title("Hydrogen/Heat/Vapor Over Time")
subplot(3,1,1)
plot(time,H2dot,"LineWidth", 2)
xlabel('Time (s)','FontSize',13);
ylabel('Hydrogen Consumption (kg/s)','FontSize',13)

subplot(3,1,2)
plot(time,heatdot,"LineWidth", 2)
xlabel('Time (s)','FontSize',13);
ylabel('Heat Flow (kJ/s)','FontSize',13)

subplot(3,1,3)
plot(time,vapordot,"LineWidth", 2)
xlabel('Time (s)','FontSize',13);
ylabel('Vapor Flow (kg/s)','FontSize',13)