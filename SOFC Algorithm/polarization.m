V0 = 1.121;
i = linspace(0,5,1000);
Ri = 0.034;
%Ri_3 = 0;

i0_1 = 0.38; % 100% oxygen
i0_2 = 0.18; % 21% oxygen
i0_3 = 0.14; % 10% oxygen
%i0_3 = 0.00013888;

ias = 3.79;
%ias_3 = 2.3761*10^(-16);


ics_1 = Inf;
ics_2 = 3.54;
ics_3 = 1.48;
%ics_3 = 2.698*10^(-10)

R = 8.314;
T = 800 +273.15;
n = 1;
F = 96485;


p0_H2 = 0.978;
%p0_H2_3 = 0;
p0_H20 = 1 - p0_H2;
%p0_H20_3 = 1 - p0_H2_3;


V1 = V0 - i.*Ri - 2.*R.*T./n./F .* log(1./2 .* (i./i0_1 + sqrt((i./i0_1).^2 +4))) + R.*T./2./F .* log(1 - i./ias)...
    - R.*T./2./F .* log(1 + p0_H2.*i./p0_H20./ias) + R.*T./4./F .* log(1 - i./ics_1);

V2 = V0 - i.*Ri - 2.*R.*T./n./F .* log(1./2 .* (i./i0_2 + sqrt((i./i0_2).^2 +4))) + R.*T./2./F .* log(1 - i./ias)...
    - R.*T./2./F .* log(1 + p0_H2.*i./p0_H20./ias) + R.*T./4./F .* log(1 - i./ics_2);

V3 = V0 - i.*Ri - 2.*R.*T./n./F .* log(1./2 .* (i./i0_3 + sqrt((i./i0_3).^2 +4))) + R.*T./2./F .* log(1 - i./ias)...
    - R.*T./2./F .* log(1 + p0_H2.*i./p0_H20./ias) + R.*T./4./F .* log(1 - i./ics_3);

V_true1 = real(V1);
V_true2 = real(V2);
V_true3 = real(V3);

plot(i, V_true1, i,V_true2, i, V_true3);
ylim([0,1.2])
xlim([0,3.54])