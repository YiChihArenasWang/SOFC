function [LNGfr, H2Ofr, unreactedmethanefr, COfr, H2Ounreactedfr, heatdot] = FuelReformer(H2dot)
    % add summary of function
    % add detailed explanation
    
    % finding LNG flow rate using conversion rate
    conversionrate = 0.85; % chosen based on data
    molH2pers = H2dot.*(10^3).*1./2.016; % mol/s
    molCH4pers = molH2pers.*1/3; % mol/s
    totalmolCH4pers = molCH4pers./conversionrate;
    kgCH4pers = totalmolCH4pers.*16.04./1000; % CH4 molar mass mol/s*g/mol*kg/g=kg/s
    LNGfr = kgCH4pers; % kg/s


    % finding the amount of unreacted methane as well as CO output
    unreactedmethanefr = (totalmolCH4pers-molCH4pers).*16.04./1000;% kg/s
    COmolfr = molCH4pers;% mol/s
    COfr = COmolfr.*28.01/1000; % kg/s
    
    % finding enthalpy of reaction
    deltaH298 = 206; %kJ/mol
    Tf = 700 + 273.15; % K Chosen to match with conversion rate data
    deltaT = Tf - 298;
    % which cp to use? temperature dependent
    % at 25 deg C vals below
    CpCH4 =  2.226; % (kJ/(kg*K))
    CpH2O =  1.865; % steam, (kJ/(kg*K))
    CpCO = 1.039; % (kJ/(kg*K)) 
    CpH2 = 14.30; % (kJ/(kg*K))
    % (kJ/(kg*K))*(kg/g)*(g/mol)= (kJ/(mol*K))
    CpCH4mol = CpCH4*(1/1000)*16.04; % kJ/(mol*K)
    CpH2Omol = CpH2O*(1/1000)*18.015; % kJ/(mol*K)
    CpCOmol = CpCO*(1/1000)*28.01; % kJ/(mol*K)
    CpH2mol = CpH2*(1/1000)*2.016; % kJ/(mol*K)
    deltaCp = 3*CpH2mol + CpCOmol - CpH2Omol - CpCH4mol; % (kJ/(mol*K))
    totaldeltaH = deltaH298 + deltaCp*deltaT; %kJ/mol
    heatdot = molCH4pers.*totaldeltaH; % mol/s*kJ/mol = kJ/s

    % finding the flow rate of H2O into reformer
    SCratio = 3; % S/C ratio of 3 chosen to match with conversion rate data
    H2Omolfr = SCratio.*totalmolCH4pers; % mol/s
    H2Ofr = H2Omolfr.*18.015/1000; % mol/s
    H2Oreactedmol = molH2pers.*1/3; % mol/s
    H2Oreactedkg = H2Oreactedmol.*2.016./1000; % mol/s*g/mol*kg/g=kg/s
    H2Ounreactedfr = H2Ofr - H2Oreactedkg; %kg/s
    
end