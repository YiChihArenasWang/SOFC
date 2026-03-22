function [totalheatflowrate, heatdotLNGheating, heatdotH2O, heatdotair] = HeatExchanger(LNGflowrate, heatdotfuelreformer, heatdotSOFC, H2Ofr, efficiency, Ti_air, Tf_air, airfr)
    
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

    % water heating calculations 
    cpH2Og = 1.865; %(kJ/(kg*K))
    cpH2Ol = 4.22; % (kJ/(kg*K))
    deltaHvapW = 2257; % kJ/kg at 1 atm
    Tbpw = 100 + 273.15; % water boiling point
    Tiw = 25 + 273.15; % water storage at room temperature
    Tfw = 700 + 273.15; % K to heat up fuel reformer to
    
    qa = H2Ofr .*cpH2Ol .* (Tbpw-Tiw); % kg/s*(kJ/(kg*K))*K = kJ/s
    qb = H2Ofr .*deltaHvapW; % kJ/s
    qc = H2Ofr .*cpH2Og .* (Tfw - Tbpw); % kJ/s

    heatdotH2O = qa + qb + qc; % kJ/s

    % air heating calculations
    cpair =  1.005; %(kJ/(kg*K))
    deltaTair = Tf_air - Ti_air; % K
    heatdotair = airfr .* cpair .* deltaTair; % kJ/s
    
    % combined total heat flow from methane heating, water heating, fuel reformer and SOFC
    totalheatflowrate = heatdotLNGheating+heatdotfuelreformer+ (efficiency*heatdotSOFC) + heatdotH2O + heatdotair;
end