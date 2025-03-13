clear

E = struct2array(load("FC_power_required.mat"));
T = 800;
pH2 = 0.98;
dt = 1;

[H2dot,vapordot,heatdot,total_H2,total_vapor,total_heat,pdens,voltagedraw,currentdraw,cells] = SOFC(E,T,pH2,dt);
%% 
time = 0:(length(E)-1);
time = time.*dt;



figure(3)

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
