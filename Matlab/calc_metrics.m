function [oMI,oPC] = calc_metrics(x,y,nobMI,noshuffles)

nanvals = isnan(x) | isnan(y);
xtemp = x(~nanvals); ytemp = y(~nanvals);
PC = corr(ytemp, xtemp);
xbin = discretize(xtemp,nobMI); ybin = discretize(ytemp,nobMI);
MI = MutualInformation(ybin,xbin);
if noshuffles == 0
    oMI = MI; oPC = PC;
    return;
else
    aMI = NaN(1,noshuffles);
    aPC = aMI;
    rng(3,'twister');
    for ii = 1:noshuffles
        xtemps = shuffle(xtemp);
        [aMI(ii),aPC(ii)] = calc_metrics(xtemps,ytemp,nobMI,0);
    end
    mu=mean(aMI); si=std(aMI);
    pMI = sum(aMI>MI)/noshuffles;
    zMI =(MI-mu)/si;
    
    mu=mean(aPC); si=std(aPC);
    pPC = sum(aPC>PC)/noshuffles;
    zPC =(PC-mu)/si;

    oMI = [MI zMI pMI]; oPC = [PC zPC pPC];
end
