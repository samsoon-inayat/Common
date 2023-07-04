function [combs,p,h] = rearrange_combs(combs,p,h)

n = 0;
% err

combs12 = combs(:,1:2);

dcombs = diff(combs12,[],2);

[ssdcombs,sdcombs] = sort(dcombs);

combso = combs(sdcombs,:);
po = p(sdcombs,:);
ho = h(sdcombs,:);

changeInds = [0;diff(ssdcombs)];

combso = [combso changeInds];