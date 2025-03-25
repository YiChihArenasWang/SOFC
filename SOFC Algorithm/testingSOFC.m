clear

E = [10000 8000 4000 2000 1000 5000 20000 0];
T = 800;
pH2 = 0.98;
dt = 1;

[H2dot,vapordot,heatdot,total_H2,total_vapor,total_heat] = SOFC(E,T,pH2,dt);