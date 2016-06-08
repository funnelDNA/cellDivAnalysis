function [ coEff ] = fake_fit( channel )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
coEff = zeros(size(channel,2),3);
for ii = 1:size(channel,2)
    line = smooth(channel(:,ii),5);
    coEff(ii,1) = max(line);
    coEff(ii,2) = 0;
    coEff(ii,3) = 0;
end


end

