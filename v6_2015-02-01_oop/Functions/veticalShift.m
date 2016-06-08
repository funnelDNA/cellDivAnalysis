function [ shiftP ] = veticalShift( fr1, fr2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    verLine1Ori = sum(fr1');
    verLine2Ori = sum(fr2');

%     plot(verLine1Ori);
%     hold on;
%     plot(verLine2Ori);
%     hold off;

    scanRange = 30; %shift verLine2
    err = zeros(1, scanRange*2+1);
    ll = 1;
    for ii = -scanRange:-1
        verLine1 = [zeros(1,-ii)+verLine1Ori(1) verLine1Ori];
        verLine2 = [verLine2Ori zeros(1,-ii)+verLine2Ori(end)];
        err(ll) = sum(abs(verLine2 - verLine1));
        ll = ll + 1;
    end
    for ii = 0:scanRange
        verLine1 = [verLine1Ori zeros(1,ii)+verLine1Ori(end)];
        verLine2 = [zeros(1,ii)+verLine2Ori(1) verLine2Ori];
        err(ll) = sum(abs(verLine2 - verLine1));
        ll = ll + 1;
    end
    [minErr shiftP] = min(err);
    shiftP = shiftP - scanRange - 1;


end

%%
% 
% fr1 = allFrames{1};
% fr2 = allFrames{2};
% 
% verLine1Ori = sum(fr1');
% verLine2Ori = sum(fr2');
% 
% plot(verLine1);
% hold on;
% plot(verLine2);
% hold off;
% 
% scanRange = 20; %shift verLine2
% err = zeros(1, scanRange*2+1);
% ll = 1;
% for ii = -scanRange:-1
%     verLine1 = [zeros(1,-ii)+verLine1Ori(1) verLine1Ori];
%     verLine2 = [verLine2Ori zeros(1,-ii)+verLine2Ori(end)];
%     err(ll) = sum(abs(verLine2 - verLine1));
%     ll = ll + 1;
% end
% for ii = 0:scanRange
%     verLine1 = [verLine1Ori zeros(1,ii)+verLine1Ori(end)];
%     verLine2 = [zeros(1,ii)+verLine2Ori(1) verLine2Ori];
%     err(ll) = sum(abs(verLine2 - verLine1));
%     ll = ll + 1;
% end
% [minErr shiftP] = min(err);
% shiftP = shiftP - scanRange - 1;
% plot(err);