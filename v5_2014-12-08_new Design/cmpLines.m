function [line1 line2] = cmpLines(line1,line2,varargin)
if length(varargin) > 0
    adLv = varargin{1};
else
    adLv = 0;
end
    l1 = length(line1);
    l2 = length(line2);
    if l1>l2
        line2 = [line2 zeros(1,l1-l2)+adLv];
    else        
        line1 = [line1 zeros(1,l2-l1)+adLv];
    end
end
