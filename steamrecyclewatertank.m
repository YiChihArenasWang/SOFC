function [wbalance, H2Olevelintank, wtankmin, initalwaterintank, SOFC, FRneed, FRrelease, t2, wexhaust, totalexhauststeam, wtankflow] = steamrecyclewatertank(SOFC,FRneed,FRrelease, SOFCtimedelay, FRtimedelay)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

SOFCdelay = zeros(1,SOFCtimedelay);
Recycledelay = zeros(1,FRtimedelay);

SOFC = [SOFCdelay SOFC];
FRrelease = [Recycledelay FRrelease zeros(1,SOFCtimedelay-FRtimedelay)];
FRneed = [FRneed zeros(1,SOFCtimedelay)];

% negative wbalance means excess steam is exhausted tank, positive means steam is needed from tank
wbalance = FRneed - SOFC - FRrelease; % kg/s
wtankflow = zeros(1, length(wbalance)); % kg/s positive means steam flows out of tank
wexhaust =  zeros(1, length(wbalance)); % kg/s
wequal =  zeros(1, length(wbalance)); 

for i = 1:length(wbalance)
    if wbalance(i)>0
        wtankflow(i) = wbalance(i);
    elseif wbalance(i)<0
        wexhaust(i) = abs(wbalance(i));
    else
        wequal(i) = 1;
    end
end


wtankmin = sum(wtankflow); 
tanksafetymargin = 0.1*wtankmin;
initalwaterintank = wtankmin + tanksafetymargin;

H2Olevelintank = zeros(1, length(wbalance)); 

for i = 1:length(wbalance)
        if i == 1
            H2Olevelintank(i) = initalwaterintank - wtankflow(i);
        else
            H2Olevelintank(i) = H2Olevelintank(i-1) - wtankflow(i);
        end
end

totalexhauststeam = sum(wexhaust);
t2 = 0:(length(SOFC)-1);

end