function [tankmass] = LNGTank(LNGfr, dt)
    totalmethane = sum(LNGfr.*dt);
    % mass fraction = mass of fuel/(mass of fuel and mass of tank)
    tankmassratio = 0.935;
    massfuelandtank = totalmethane/tankmassratio;
    tankmass = massfuelandtank - totalmethane;
end