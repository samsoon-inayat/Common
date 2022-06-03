function [hbs,myys] = plotBarsWithSigLines (means,sems,combs,sig,varargin)

p = inputParser;
default_maxY = max(means+sems);
default_colors = distinguishable_colors(20);
default_ySpacingFactor = 10;
addRequired(p,'means',@isnumeric);
addRequired(p,'sems',@isnumeric);
addRequired(p,'combs',@isnumeric);
addRequired(p,'sig',@isnumeric);
addOptional(p,'maxY',default_maxY+10*default_maxY,@isnumeric);
addOptional(p,'colors',default_colors,@iscell);
% addOptional(p,'ySpacingFactor',default_ySpacingFactor,@isnumeric);
addOptional(p,'ySpacing',1,@isnumeric);
addOptional(p,'sigColor','k');
addOptional(p,'sigTestName','');
addOptional(p,'sigLineWidth',0.25);
addOptional(p,'sigAsteriskFontSize',5);
addOptional(p,'sigFontSize',5);
addOptional(p,'BaseValue',0.3);
addOptional(p,'barwidth',0.8);
addOptional(p,'sigLinesStartYFactor',0.1);
addOptional(p,'xdata',1:length(means));
addOptional(p,'capsize',3);
parse(p,means,sems,combs,sig,varargin{:});

cols = p.Results.colors;
myy = p.Results.maxY;
maxY = default_maxY;
sigLinesStartYFactor = p.Results.sigLinesStartYFactor;
ySpacing = p.Results.ySpacing;
sigColor = p.Results.sigColor;
sigTestName = p.Results.sigTestName;
sigLineWidth = p.Results.sigLineWidth;
sigAsteriskFontSize = p.Results.sigAsteriskFontSize;
sigFontSize = p.Results.sigFontSize;
bv = p.Results.BaseValue;
xdata = p.Results.xdata;
capsize = p.Results.capsize;
xdatai = xdata;
barwidth = p.Results.barwidth;

hold on;
for ii = 1:length(xdata)
%     hb = bar(xdata(ii),means(ii),'BaseValue',bv,'ShowBaseline','off','barwidth',barwidth);
    hb = bar_patch(xdata(ii),means(ii),sems(ii),barwidth);
    set(hb,'FaceColor',cols{ii},'EdgeColor',cols{ii});
    errorbar(xdata(ii), means(ii), sems(ii), 'k', 'linestyle', 'none','CapSize',capsize);
%     errorbar(xdata(ii), means(ii), [],sems(ii), 'k', 'linestyle', 'none','CapSize',3);
%     errorbar(xdata(ii), means(ii), sems(ii),[], 'w', 'linestyle', 'none','CapSize',3);
    hbs(ii) = hb;
end
% xlim([0.5 length(means)+0.5]);

% xdata = 1:length(means);
if length(xdata) == 1
    ylims = ylim;
    myys = ylims(2);
    return;
end
dx = xdata(2) - xdata(1);

yl = get(gca,'YLim');

if size(sig,2) == 1
    sig = [sig(:,1)<0.05 sig(:,1)];
end

combs = combs(logical(sig(:,1)),:);
pvals = find(logical(sig(:,1)));

dy = (maxY-yl(1));
if ~isempty(combs)
    diffCombs  = combs(:,2) - combs(:,1);
    maxdiff = max(combs(:,2) - combs(:,1));
    numberOfSigLines = length(find(sig(:,1)));
else 
    numberOfSigLines = 0;
end

fyy = maxY + sigLinesStartYFactor*(maxY-yl(1));
fyy1 = maxY + 10*(maxY-yl(1));
ayy = (fyy+(ySpacing/2)):ySpacing:fyy1;
count = 0;
all_yys = [];
while 1
    if size(combs,1) > 1
        fdisj = find_disjoint(combs);
    else
        fdisj = 1;
    end
    for ii = 1:length(fdisj)
        yy = ayy(count); dy = ayy(2) - ayy(1);
        b1  = combs(fdisj(ii),1);
        b2  = combs(fdisj(ii),2);
        x1 = xdata(b1)+dx/40;
        x2 = xdata(b2)- dx/40;
        line([x1 x2], [yy yy],'linewidth',sigLineWidth,'color',sigColor);
        line([x1 x1], [yy-(ySpacing/3) yy],'linewidth',sigLineWidth,'color',sigColor);
        line([x2 x2], [yy-(ySpacing/3) yy],'linewidth',sigLineWidth,'color',sigColor);
        pvalue = sig(pvals(count),2);
        sigText = getNumberOfAsterisks(pvalue);
        xt1 = x1 + (x2-x1)/2;
        text(xt1,yy+dy/7,sigText,'FontSize',sigAsteriskFontSize,'HorizontalAlignment','center','Color',sigColor);
        all_yys = [all_yys yy];
    end
    combs(fdisj,:) = [];
    pvals(fdisj,:) = [];
    combs
    if isempty(combs)
        break;
    end
end
myys = max(all_yys(:));

myys = 1.1*myys;


function fdisj = find_disjoint(theCombs)
fdisj = [];
combs_combs = nchoosek(1:size(theCombs,1),2);

disj = [];
for cc = 1:size(combs_combs)
    combs_1 = theCombs(combs_combs(cc,1),:);
    combs_2 = theCombs(combs_combs(cc,2),:);
    if combs_2(1) <= combs_1(2)
        continue;
    end
    disj = [disj;cc];
end
if isempty(disj)
    disj = 1;
end
fdisj = combs_combs(disj(1),:);