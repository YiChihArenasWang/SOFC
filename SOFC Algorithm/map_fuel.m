grav = [43.4 44 120 120 120 19.7 23 42.5];
vol = [34.5 32 8 2.7 4.7 15.6 12.7 36.2];

plot(grav,vol, 'o');
xlabel("Gravimetric Energy Density (MJ/kg)");
ylabel("Volumetric Energy Density (MJ/L)");
xlim([0 142]);

text(45.4, 34.5, "JP8");
text(46, 32, "Gasoline");
text(122, 8, "LH2");
text(122, 2.7, "H2 (350 bar)");
text(122, 4.7, "H2 (700 bar)");
text(21.7, 15.6, "Methanol");
text(25, 12.7, "Ammonia");
text(44.5, 36.2, "Diesel");