function [wbalance, H2Olevelintank, wmin, initalwaterintank, SOFC, FRneed, FRrelease, t2, excessH2O, totalexhauststeam] = steamrecycle(SOFC,FRneed,FRrelease, SOFCtimedelay, FRtimedelay)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

SOFCdelay = zeros(1,SOFCtimedelay);
Recycledelay = zeros(1,FRtimedelay);

SOFC = [SOFCdelay SOFC];
FRrelease = [Recycledelay FRrelease zeros(1,SOFCtimedelay-FRtimedelay)];
FRneed = [FRneed zeros(1,SOFCtimedelay)];

% negative wbalance means excess steam is added to the tank, positive means steam is needed from tank
wbalance = FRneed - SOFC - FRrelease; % kg/s
wtankstartat0 = zeros(1, length(wbalance)); % kg


for i = 1:length(wbalance)
    if i==1
        wtankstartat0(i) = 0 - wbalance(i);
    else
        wtankstartat0(i) = wtankstartat0(i-1) - wbalance(i);
    end
end

% wtank negative means steam is used from tank, positive is excess steam
% (amount in tank starts at 0)
wmin = -min(wtankstartat0);
tanksafetymargin = 0.1*wmin;
initalwaterintank = wmin + tanksafetymargin;

H2Olevelintank = zeros(1, length(wbalance)); 

excessH2O = zeros(1, length(wbalance)); 
for i = 1:length(wbalance)
    if i==1
        H2Olevelintank(i) = initalwaterintank - wbalance(i);
        if H2Olevelintank(i)>initalwaterintank
            excessH2O(i) = H2Olevelintank(i) - initalwaterintank;
            H2Olevelintank(i) = initalwaterintank;
        end
    else
        H2Olevelintank(i) = H2Olevelintank(i-1) - wbalance(i);
        if H2Olevelintank(i)>initalwaterintank
            excessH2O(i) = H2Olevelintank(i) - initalwaterintank;
            H2Olevelintank(i) = initalwaterintank;            
        end
    end
end

totalexhauststeam = sum(excessH2O);
t2 = 0:(length(SOFC)-1);

end