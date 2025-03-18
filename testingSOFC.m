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