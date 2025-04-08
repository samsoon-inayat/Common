function [oMI] = calc_metric_MI(x,y,nobMI,noshuffles)

nanvals = isnan(x) | isnan(y);
xtemp = x(~nanvals); ytemp = y(~nanvals);
xbin = discretize(xtemp,nobMI); ybin = discretize(ytemp,nobMI);
MI = MutualInformation(ybin,xbin);
if noshuffles == 0
    oMI = MI; 
    return;
else
    aMI = NaN(1,noshuffles);
    rng(3,'twister');
    for ii = 1:noshuffles
        xtemps = shuffle(xtemp);
        [aMI(ii)] = calc_metric_MI(xtemps,ytemp,nobMI,0);
    end
    mu=mean(aMI); si=std(aMI);
    pMI = sum(aMI>MI)/noshuffles;
    zMI =(MI-mu)/si;

    oMI = [MI zMI pMI];
end
