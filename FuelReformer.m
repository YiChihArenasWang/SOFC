function [LNGfr, H2Ofr, unreactedmethanefr, COfr, CO2fr, unreactedH2Ofr, totalheatdot, H2Ocheckfr, H2fr] = FuelReformer(H2dot)
    % add summary of function
    % add detailed explanation
    
    % finding LNG flow rate using conversion rate
    conversionrateCH4 = 0.85; % chosen based on data
    conversionrateH2O = 0.4; % chosen based on data
    molH2pers = H2dot.*(10^3).*1./2.016; % mol/s
    totalmolCH4pers = molH2pers.*1/2.9; % mol/s
    reactedmolCH4pers = totalmolCH4pers.*conversionrateCH4; % mol/s
    kgCH4pers = totalmolCH4pers.*16.04./1000; % CH4 molar mass mol/s*g/mol*kg/g=kg/s
    LNGfr = kgCH4pers; % kg/s


    % finding the amount of unreacted methane as well as CO output
    unreactedmethanefr = (totalmolCH4pers-reactedmolCH4pers).*16.04./1000;% kg/s
    
    % SMR reaction results
    H2OSMRmolfr = 0.85*totalmolCH4pers;% mol/s
    COSMRmolfr = 0.85*totalmolCH4pers; % mol/s
    H2SMRmolfr = 3*0.85*totalmolCH4pers; % mol/s

    % WSG reaction results
    H2OWSGmolfr = 0.35*totalmolCH4pers; % mol/s
    H2WSGmolfr = H2OWSGmolfr; % mol/s
    COWSGmolfr = H2OWSGmolfr; % mol/s
    CO2molfr = H2OWSGmolfr; % mol/s

    % CO2 flow rate out of reformer
    CO2fr = CO2molfr.*44.01/1000; % kg/s

    % CO flow rate out of reformer is the formed CO from SMR minus CO used
    % in the WSG reaction
    COmolfr = COSMRmolfr - COWSGmolfr; % mol/s
    COfr = COmolfr.*28.01/1000; % kg/s

    % H2O flow rate into reformer and unreacted steam flow rate out
    % finding the flow rate of H2O into reformer
    SCratio = 3; % S/C ratio of 3 chosen to match with conversion rate data
    H2Omolfr = SCratio.*totalmolCH4pers; % mol/s
    H2Ofr = H2Omolfr.*18.015/1000; % mol/s
    % flow rate of steam out (total flow in minus the steam going into SMR
    % and WSG
    unreactedH2Omolfr = H2Omolfr - (H2OSMRmolfr + H2OWSGmolfr); % mol/s
    unreactedH2Ofr = unreactedH2Omolfr.*18.015/1000; % mol/s

    % calculated total H2O and H2 flow rates to check numbers
    % H2O calculations
    totalmolH2Ofr = 1/conversionrateH2O .*(H2OSMRmolfr+H2OWSGmolfr); % mol/s
    H2Ocheckfr = totalmolH2Ofr.*18.015/1000; %kg/s
    
    % H2 calculations
    H2molfr = H2SMRmolfr + H2WSGmolfr; % mol/S
    H2fr = H2molfr.*2.016./1000; % kg/8OLLO'

    % finding enthalpy of reactions
    deltaH298SMR = 206; % kJ/mol
    deltaH298WSG = -41; % kJ/mol
    Tf = 700 + 273.15; % K Chosen to match with conversion rate data
    deltaT = Tf - 298; % K
    
    % at 25 deg C vals below
    CpCH4 =  2.226; % (kJ/(kg*K))
    CpH2O =  1.865; % steam, (kJ/(kg*K))
    CpCO = 1.039; % (kJ/(kg*K)) 
    CpH2 = 14.30; % (kJ/(kg*K))
    CpCO2 = 0.8439;
    % (kJ/(kg*K))*(kg/g)*(g/mol)= (kJ/(mol*K))
    CpCH4mol = CpCH4*(1/1000)*16.04; % kJ/(mol*K)
    CpH2Omol = CpH2O*(1/1000)*18.015; % kJ/(mol*K)
    CpCOmol = CpCO*(1/1000)*28.01; % kJ/(mol*K)
    CpH2mol = CpH2*(1/1000)*2.016; % kJ/(mol*K)
    CpCO2mol = CpCO2*(1/1000)*44.01;
    % enthalpy for SMR
    deltaCpSMR = 3*CpH2mol + CpCOmol - CpH2Omol - CpCH4mol; % (kJ/(mol*K))
    totaldeltaHSMR = deltaH298SMR + deltaCpSMR*deltaT; %kJ/mol
    heatdotSMR = H2OSMRmolfr.*totaldeltaHSMR; % mol/s*kJ/mol = kJ/s

    % enthalpy for WSG
    deltaCpWSG = CpH2mol + CpCO2mol - CpH2Omol - CpCOmol; % (kJ/(mol*K))
    totaldeltaHWSG = deltaH298WSG + deltaCpWSG*deltaT; %kJ/mol
    heatdotWSG = H2OWSGmolfr.*totaldeltaHWSG; % mol/s*kJ/mol = kJ/s
    
    % total enthalpy
    totalheatdot = heatdotSMR + heatdotWSG; % kJ/s
    
end