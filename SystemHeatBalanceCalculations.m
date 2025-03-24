function [totalheatflowrate, heatdotLNGheating] = SystemHeatBalanceCalculations(LNGflowrate, heatdotfuelreformer, heatdotSOFC)
    
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
    
    % combined total heat flow from methane heating, fuel reformer and SOFC
    totalheatflowrate = heatdotLNGheating+heatdotfuelreformer+heatdotSOFC;
end