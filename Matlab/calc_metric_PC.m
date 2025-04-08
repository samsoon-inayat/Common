function [oPC] = calc_metric_PC(x,y,noshuffles)

nanvals = isnan(x) | isnan(y);
xtemp = x(~nanvals); ytemp = y(~nanvals);
PC = corr(ytemp, xtemp);
if noshuffles == 0
    oPC = PC;
    return;
else
    aPC = NaN(1,noshuffles);
    rng(3,'twister');
    for ii = 1:noshuffles
        xtemps = shuffle(xtemp);
        [aPC(ii)] = calc_metric_PC(xtemps,ytemp,0);
    end
   
    mu=mean(aPC); si=std(aPC);
    pPC = sum(aPC>PC)/noshuffles;
    zPC =(PC-mu)/si;

     oPC = [PC zPC pPC];
end
