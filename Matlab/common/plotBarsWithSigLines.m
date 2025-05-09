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
addOptional(p,'sigAsteriskyshift',5);
addOptional(p,'sigFontSize',5);
addOptional(p,'BaseValue',0.3);
addOptional(p,'barwidth',0.8);
addOptional(p,'sigLinesStartYFactor',0.1);
addOptional(p,'xdata',1:length(means));
addOptional(p,'capsize',3);
addOptional(p,'raw_data',NaN,@isnumeric);
addOptional(p,'dots','.',@ischar);
addOptional(p,'dot_size',5,@isnumeric);
parse(p,means,sems,combs,sig,varargin{:});

mData = evalin('base','mData'); magfac = mData.magfac;

cols = p.Results.colors;
myy = p.Results.maxY;
maxY = default_maxY;
sigLinesStartYFactor = p.Results.sigLinesStartYFactor*magfac;
ySpacing = p.Results.ySpacing;%*magfac;
sigColor = p.Results.sigColor;
sigTestName = p.Results.sigTestName;
sigLineWidth = p.Results.sigLineWidth*magfac;
sigAsteriskFontSize = p.Results.sigAsteriskFontSize*magfac;
sigAsteriskyshift = p.Results.sigAsteriskyshift*magfac;
sigFontSize = p.Results.sigFontSize*magfac;
bv = p.Results.BaseValue;
xdata = p.Results.xdata;
capsize = p.Results.capsize;
xdatai = xdata;
barwidth = p.Results.barwidth;
raw_data = p.Results.raw_data;
dots = p.Results.dots;
dot_size = p.Results.dot_size;

osigcolor = sigColor;

hold on;
for ii = 1:length(xdata)
%     hb = bar(xdata(ii),means(ii),'BaseValue',bv,'ShowBaseline','off','barwidth',barwidth);
    if ~isnan(raw_data)
        xscat = ones(size(raw_data(:,ii)))*ii;
        sch = scatter(xscat,raw_data(:,ii),dot_size,cols{ii},dots);
        sch.MarkerFaceAlpha = .5;
        sch.MarkerEdgeAlpha = .5;
%         plot(ii,raw_data(:,ii),dots,'color',cols{ii},'markersize',dot_size);
    end
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

dy = (maxY-yl(1));
if ~isempty(combs)
diffCombs  = combs(:,2) - combs(:,1);
maxdiff = max(combs(:,2) - combs(:,1));
numberOfSigLines = length(find(sig(:,1)));
else 
    numberOfSigLines = 0;
end
% err 
if numberOfSigLines > 0
    fyy = maxY + sigLinesStartYFactor;
    tcombs = combs(logical(sig(:,1)),:); tps = sig(logical(sig(:,1)),2);
    rpi = 1; yy = max(means(tcombs(1,1:2))+sems(tcombs(1,1:2))) + sigLinesStartYFactor; prev_vals = []; vals_p = []; jj = 1;
    while size(tcombs,1) > 0
        b1  = tcombs(rpi,1); b2  = tcombs(rpi,2);
        if ismember(b1,prev_vals) || ismember(b2,prev_vals) || sum(b1 < max(prev_vals)) || sum(b2 < max(prev_vals))
            rpi = rpi + 1;
            if rpi > size(tcombs,1)
                tcombs(vals_p,:) = [];
                tps(vals_p,:) = [];
                prev_vals = [];
                rpi = 1;
                vals_p = [];
                yy = yy + ySpacing;
            end
            continue;
        else
            prev_vals = [prev_vals b1 b2];
            vals_p = [vals_p;rpi];
        end
        if size(tcombs,2) == 3
            ac  = tcombs(rpi,3);
        else
            ac = 0;
        end
        x1 = xdata(b1)+dx/40;
        x2 = xdata(b2)- dx/40;
        if ~logical(ac)
            linst = '-';
            lwid = sigLineWidth;
            sigColor = osigcolor;
        else
           linst = '-.';
            lwid = sigLineWidth + sigLineWidth;
            sigColor = 'b';
        end
        line([x1 x2], [yy yy],'linewidth',sigLineWidth,'color',sigColor);
        line([x1 x1], [yy-(ySpacing/3) yy],'linewidth',lwid,'color',sigColor,'LineStyle',linst);
        line([x2 x2], [yy-(ySpacing/3) yy],'linewidth',lwid,'color',sigColor,'LineStyle',linst);

        pvalue = tps(rpi);
        sigText = getNumberOfAsterisks(pvalue);
        xt1 = x1 + (x2-x1)/2;
        text(xt1,yy+sigAsteriskyshift,sigText,'FontSize',sigAsteriskFontSize,'HorizontalAlignment','center','Color',sigColor);
        all_yys(jj) = yy; jj = jj + 1;
        rpi = rpi + 1;
        if rpi > size(tcombs,1)
            tcombs(vals_p,:) = [];
            tps(vals_p,:) = [];
            prev_vals = [];
            rpi = 1;
            vals_p = [];
            yy = yy + ySpacing;
        end
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
else
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
end
% % % if numberOfSigLines > 0
% % %     fyy = maxY + sigLinesStartYFactor*(maxY-yl(1));
% % %     fyy1 = maxY + 10*(maxY-yl(1));
% % % %     sigLineWidth = 0.5;
% % % %     ayy = fyy:((maxY-yl(1))/ySpacingFactor):fyy1;
% % % %     ayy = (fyy+(ySpacing/2)):ySpacing:fyy1; % original
% % % %     ayy = linspace(fyy,fyy1,num_lev);
% % %     yy = fyy; dy = ySpacing;
% % % %     myy = ayy(numberOfSigLines);
% % %     count = 0;
% % %     for ii = 1:maxdiff
% % %         inds = find(diffCombs == ii);
% % %         for jj = 1:length(inds)
% % %             if ~sig(inds(jj),1)
% % %                 continue;
% % %             end
% % %             count = count + 1;
% % %             if lcombs(inds(jj))
% % %                 yy = yy + ySpacing;
% % %             end
% % % %             yy = ayy(count); dy = ayy(2) - ayy(1);
% % %             b1  = combs(inds(jj),1);
% % %             b2  = combs(inds(jj),2);
% % %             if size(combs,2) == 3
% % %                 ac  = combs(inds(jj),3);
% % %             else
% % %                 ac = 0;
% % %             end
% % %             x1 = xdata(b1)+dx/40;
% % %             x2 = xdata(b2)- dx/40;
% % %             if ~logical(ac)
% % %                 linst = '-';
% % %                 lwid = sigLineWidth;
% % %                 sigColor = osigcolor;
% % %             else
% % %                linst = '-.';
% % %                 lwid = sigLineWidth + sigLineWidth;
% % %                 sigColor = 'b';
% % %             end
% % %             line([x1 x2], [yy yy],'linewidth',sigLineWidth,'color',sigColor);
% % %             line([x1 x1], [yy-(ySpacing/3) yy],'linewidth',lwid,'color',sigColor,'LineStyle',linst);
% % %             line([x2 x2], [yy-(ySpacing/3) yy],'linewidth',lwid,'color',sigColor,'LineStyle',linst);
% % % %             if count == 1
% % % %                 line([x1 x1], [means(b1)+sems(b1)+dy/15 yy],'linewidth',sigLineWidth,'color',sigColor);
% % % %                 line([x2 x2], [means(b2)+sems(b2)+dy/15 yy],'linewidth',sigLineWidth,'color',sigColor);
% % % %             else
% % % %                 line([x1 x1], [ayy(count-1)+0.3*dy/10 yy],'linewidth',sigLineWidth,'color',sigColor);
% % % %                 line([x2 x2], [ayy(count-1)+0.3*dy/10 yy],'linewidth',sigLineWidth,'color',sigColor);
% % % %             end
% % %             pvalue = sig(inds(jj),2);
% % %             sigText = getNumberOfAsterisks(pvalue);
% % %             xt1 = x1 + (x2-x1)/2;
% % %             text(xt1,yy+dy/7,sigText,'FontSize',sigAsteriskFontSize,'HorizontalAlignment','center','Color',sigColor);
% % %             all_yys(ii,jj) = yy;
% % %         end
% % %     end
% % %     myys = max(all_yys(:));
% % %     if myys > myy
% % %         ylimvs = [yl(1) myys];
% % %     else
% % %         ylimvs = [yl(1) myy];
% % %     end
% % %     ylim(ylimvs);
% % %     yt = ylimvs(2);
% % %     xdata = xlim;
% % %     ht = text(xdata(1)+(dx/2),yt,sigTestName,'FontSize',sigFontSize,'Color',sigColor);
% % %     extent = get(ht,'Extent');
% % %     total = xdata(end) - xdata(1);
% % %     indent = (total - extent(3))/2;
% % %     xt = xdata(1) + indent + total/10;
% % %     set(ht,'Position',[xt yt 0]);
% % % else
% % %     myys = maxY;
% % %     ylimvs = [yl(1) maxY];
% % %     ylim(ylimvs);
% % %     yt = default_maxY + ((ylimvs(2)-ylimvs(1))/10);
% % %     if isempty(xdatai)
% % %         xdata = xlim;
% % %     else
% % %         if xdatai(1) > 1
% % %             xdata = xdatai(1);
% % %         else
% % %             xdata = xdatai(2);
% % %         end
% % %     end
% % %     ht = text(xdata(1)+(dx/2),yt,sprintf('%s',sigTestName),'FontSize',sigFontSize,'Color',sigColor);
% % %     extent = get(ht,'Extent');
% % %     total = xdata(end) - xdata(1);
% % %     indent = (total - extent(3))/2;
% % %     xt = xdata(1) + indent + total/10;
% % %     set(ht,'Position',[xt yt 0]);
% % % end

myys = 1.1*myys;

set(gcf,'Renderer','painters')
