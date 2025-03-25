clear

E = ones(3600,1).*75000;
T = 800;
pH2 = 0.98;
dt = 1;

temp = [700,750,800];
res = [0.05, 0.0367, 0.0307];
i0 = [0.2327, 0.38, 0.38];
ias = [2.3, 2.8397, 3.1323];
ics = [2.3, 2.8292, 3.1311];

syms t
coeff_ias = polyfit(temp,ias,2);
iaseq = coeff_ias(1)*t^2 + coeff_ias(2)*t + coeff_ias(3);

coeff_res = polyfit(temp,res,2);
reseq = coeff_res(1)*t^2 + coeff_res(2)*t + coeff_res(3);

coeff_ics = polyfit(temp,ics,2);
icseq = coeff_ics(1)*t^2 + coeff_ics(2)*t + coeff_ics(3);

coeff_i0 = polyfit(temp,i0,2);
i0eq = coeff_i0(1)*t^2 + coeff_i0(2)*t + coeff_i0(3);

res_real = subs(reseq,t,T);
ias_real = subs(iaseq,t,T);
ics_real = subs(icseq,t,T);
i0_real = subs(i0eq,t,T);


V0 = 1.121;
R = 8.314;
n = 1;
F = 96485;
pH20 = 1- pH2;
i = 0;
V = 0;

ntemp = 0;
Vtemp = 10000;
j=1;

while Vtemp > 0 

i(j) = ntemp;    
V(j) = V0 - ntemp.*res_real - 2.*R.*T./n./F .* log(1./2 .* (ntemp./i0_real + sqrt((ntemp./i0_real).^2 +4))) + R.*T./2./F .* log(1 - ntemp./ias_real)...
    - R.*T./2./F .* log(1 + pH2.*ntemp./pH20./ias_real) + R.*T./4./F .* log(1 - ntemp./ics_real);
Vtemp = V(j);
ntemp = ntemp + 0.01;
j = j +1;

end

V(V~=real(V)) = NaN;
power = i.*V;
pdens_max = max(power);

E_max = max(E);
A = 500; %cm^2
min_cells = E_max/(pdens_max*A);

plot(i,power);

% Use min cells to find pdens req, find current relating to that power
% Then find, h2dot
pdens = E./min_cells./A;
currentdraw = spline(power,i,pdens);
voltagedraw = spline(i,V,currentdraw);


H2dot = 1.05*10^(-8)  .* currentdraw .* A .* min_cells; % kg/s

total_H2 = sum(H2dot.*dt);

h2mol = H2dot.*1000./2.02;
h20mol = h2mol;
vapordot = h20mol.*18.02./1000; % kg/s
total_vapor = sum(vapordot.*dt);


enthalpykg25 = -285.8/18.02*1000; % kJ/kg
e2 = enthalpykg25 + 4.18*(100-25);
e3 = e2 + 2260;
e4 = e3 + 1.996*(T - 373.15);
heatdot = e4.*vapordot; % kJ/s
total_heat = sum(heatdot.*dt);

% Change code to implement arrays, measure total release
% Try to show polarization curves and power density curves 
% across different temperatures to see how accurate the curves are