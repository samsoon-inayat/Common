function [hbs,myys] = plot_bars_sig_lines (means,sems,combs,sig,varargin)

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
addOptional(p,'error_bar_color',{[0 0 0]});
addOptional(p,'face_colors',{});
addOptional(p,'edge_colors',{});
addOptional(p,'alpha',0.05);

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
error_bar_color = p.Results.error_bar_color;
face_colors = p.Results.face_colors;
edge_colors = p.Results.edge_colors;
alpha = p.Results.alpha;

if isempty(face_colors)
    face_colors = cols;
end
if isempty(edge_colors)
    edge_colors = cols;
end
if length(error_bar_color) == 1
    error_bar_color = repmat(error_bar_color,2,1);
end

error_bar_upper_color = error_bar_color{1};
error_bar_lower_color = error_bar_color{2};

hold on;
for ii = 1:length(xdata)
%     hb = bar(xdata(ii),means(ii),'BaseValue',bv,'ShowBaseline','off','barwidth',barwidth);
    hb = bar_patch(xdata(ii),means(ii),sems(ii),barwidth);
    set(hb,'FaceColor',face_colors{ii},'EdgeColor',edge_colors{ii});
%     errorbar(xdata(ii), means(ii), sems(ii), 'k', 'linestyle', 'none','CapSize',capsize);
    errorbar(xdata(ii), means(ii), [],sems(ii), 'color',error_bar_upper_color, 'linestyle', 'none','CapSize',capsize);
    errorbar(xdata(ii), means(ii), sems(ii),[], 'color',error_bar_lower_color, 'linestyle', 'none','CapSize',capsize);
    hbs(ii) = hb;
end

if size(sig,2) == 1
    pv = sig(:,1); h = pv < alpha;
else
   h = logical(sig(:,1)); pv = sig(:,2);
end

if length(xdata) == 1
    ylims = ylim;
    myys = ylims(2);
    return;
end
dx = xdata(2) - xdata(1);
yl = get(gca,'YLim');

fyy = maxY + sigLinesStartYFactor*(maxY-yl(1));
fyy1 = maxY + 10*(maxY-yl(1));
ayy = (fyy+(ySpacing/2)):ySpacing:fyy1;
count = 0;

combs = combs(h,:);
pv = pv(h);
h = h(h);
if isempty(h)
    myys = maxY;
    ylimvs = [yl(1) maxY];
    ylim(ylimvs);
    yt = default_maxY + ((ylimvs(2)-ylimvs(1))/10);
    if isempty(xdatai)
        xdata = xlim;
    else
        if xdatai(1) > 1
            xdata = xdatai(1);
        else
            xdata = xdatai(2);
        end
    end
    ht = text(xdata(1)+(dx/2),yt,sprintf('%s',sigTestName),'FontSize',sigFontSize,'Color',sigColor);
    extent = get(ht,'Extent');
    total = xdata(end) - xdata(1);
    indent = (total - extent(3))/2;
    xt = xdata(1) + indent + total/10;
    set(ht,'Position',[xt yt 0]);
    myys = 1.1*myys;
    return;
end
nast = getNumberOfAsterisks(pv);

for ii = 1:length(h)
    count = count + 1;
    yy = ayy(count); dy = ayy(2) - ayy(1);
    b1  = combs(ii,1);
    b2  = combs(ii,2);
    x1 = xdata(b1)+dx/40;
    x2 = xdata(b2)- dx/40;
    line([x1 x2], [yy yy],'linewidth',sigLineWidth,'color',sigColor);
    line([x1 x1], [yy-(ySpacing/2) yy],'linewidth',sigLineWidth,'color',sigColor);
    line([x2 x2], [yy-(ySpacing/2) yy],'linewidth',sigLineWidth,'color',sigColor);
    sigText = nast{ii};
    xt1 = x1 + (x2-x1)/2;
    text(xt1,yy-dy/2,sigText,'FontSize',sigAsteriskFontSize,'HorizontalAlignment','center','Color',sigColor);
%     ytxt = (yy-(ySpacing/3));
%     text(x2+dx/20,ytxt,sigText,'FontSize',sigAsteriskFontSize,'HorizontalAlignment','center','Color',sigColor);
    all_yys(ii) = yy;
end

myys = max(all_yys(:));
if myys > myy
    ylimvs = [yl(1) myys];
else
    ylimvs = [yl(1) myy];
end
ylim(ylimvs);
yt = ylimvs(2);
xdata = xlim;
ht = text(xdata(1)+(dx/2),yt,sigTestName,'FontSize',sigFontSize,'Color',sigColor);
extent = get(ht,'Extent');
total = xdata(end) - xdata(1);
indent = (total - extent(3))/2;
xt = xdata(1) + indent + total/10;
set(ht,'Position',[xt yt 0]);

myys = 1.1*myys;

