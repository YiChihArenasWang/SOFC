function [wbalance,wtank,winitial, SOFC, FRneed, FRrelease, t2] = water(SOFC,FRneed,FRrelease, SOFCtimedelay, FRtimedelay)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

SOFCdelay = zeros(1,SOFCtimedelay);
Recycledelay = zeros(1,FRtimedelay);

SOFC = [SOFCdelay SOFC];
FRrelease = [Recycledelay FRrelease zeros(1,SOFCtimedelay-FRtimedelay)];
FRneed = [FRneed zeros(1,SOFCtimedelay)];

% negative wbalance means excess steam is added to the tank, positive means steam is needed from tank
wbalance = FRneed - SOFC - FRrelease; 
wtank = zeros(1, length(wbalance)); 


for i = 1:length(wbalance)
    if i==1
        wtank(i) = 0 - wbalance(i);
    else
        wtank(i) = wtank(i-1) - wbalance(i);
    end
end
wtank = -wtank;
% wtank positive means steam is needed from tank, negative is excess steam
winitial = max(wtank);

t2 = 0:(length(wtank)-1);


end