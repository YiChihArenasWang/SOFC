function [wbalance,wneeded] = water(SOFC,FRneed,FRrelease)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

SOFCdelay = zeros(1,30);
Recycledelay = zeros(1,15);

SOFC = [SOFCdelay SOFC];
FRrelease = [Recycledelay FRrelease zeros(1,15)];
FRneed = [FRneed zeros(1,30)];

wbalance = FRneed - SOFC - FRrelease;
wneeded = 0;
w_unused_exhaust = 0;


for i = 1:length(wbalance)
    if wbalance(i) > 0
        wneeded = wneeded + wbalance(i);
    end

end



end