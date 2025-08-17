function [hbs,xdata,mVar,semVar,combs,p,h] = view_results_rmanova(ha,ra,facs,gaps,tcolors,limsY,mData)

if isempty(ha)
    figure(100);clf;
    plot(0,0);
    ha = gca;
else
    axes(ha);
end

[xdata,mVar,semVar,combs,p,h] = get_vals_RMA(mData,ra,facs,gaps,'no');

try 
    alpha = facs{3};
catch
    alpha = ra.alpha;
end


if isempty(limsY)
    mY = min([0 min(mVar - semVar)]);
    nsl = sum(p<alpha);
    ysp = max(mVar+semVar)/10;
    ystf = ysp;
    ysigf = ysp/10;
    MY = max(mVar + semVar) + nsl*ysp + ystf + nsl*ysigf;
else
    mY = limsY(1); MY = limsY(2); ysp = limsY(3); ystf = limsY(4); ysigf = limsY(5);
end


if get_p_val_ranova(ra,facs{1}) > ra.alpha
     % combs = [];
end

% if length(facs) > 3
%     combs = [];
% end



[hbs,maxY] = plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',tcolors,'sigColor','k',...
'ySpacing',ysp,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.01,'capsize',1,...
'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',mData.asterisk_font_size,'barWidth',0.5,'sigLinesStartYFactor',ystf,'sigAsteriskyshift',ysigf);

if ~exist('MY','var')
    MY = maxY;
end

set_axes_limits(gca,[xdata(1)-0.75 xdata(end)+0.75],[mY MY]); format_axes(gca);
