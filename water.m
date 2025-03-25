function [wbalance,wtank,winitial] = water(SOFC,FRneed,FRrelease, SOFCtimedelay, FRtimedelay)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

SOFCdelay = zeros(1,SOFCtimedelay);
Recycledelay = zeros(1,FRtimedelay);

SOFC = [SOFCdelay SOFC];
FRrelease = [Recycledelay FRrelease zeros(1,SOFCtimedelay-FRtimedelay)];
FRneed = [FRneed zeros(1,30)];

wbalance = FRneed - SOFC - FRrelease;
wtank = [];

for i = 1:length(wbalance)
    if i==1
        wtank(i) = 0 - wbalance(i);
    else
        wtank(i) = wtank(i-1) - wbalance(i);
    end
end

winitial = min(wtank);

end