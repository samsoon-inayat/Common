function [ha,hb,hca,xs,mVals,semVals] = plotAverageDistributions (distD,varargin)
hb = NaN; hca = NaN; ha = NaN;
p = inputParser;
default_colors = distinguishable_colors(20);
default_ySpacingFactor = 10;
addRequired(p,'distD',@iscell);
addOptional(p,'incr',inf,@isnumeric);
addOptional(p,'min',-inf,@isnumeric);
addOptional(p,'max',inf,@isnumeric);
addOptional(p,'colors',default_colors,@iscell);
addOptional(p,'maxY',100,@isnumeric);
addOptional(p,'cumPos',0,@isnumeric);
addOptional(p,'graphType','line');
addOptional(p,'legend',{},@iscell);
addOptional(p,'BaseValue',0.2,@isnumeric);
addOptional(p,'do_mean','Yes');
addOptional(p,'pdf_or_cdf','cdf');
parse(p,distD,varargin{:});

cols = p.Results.colors;
maxY = p.Results.maxY;
cumPos = p.Results.cumPos;
graphType = lower(p.Results.graphType);
legs = p.Results.legend;
bv = p.Results.BaseValue;
do_mean = p.Results.do_mean;
pdf_or_cdf = p.Results.pdf_or_cdf;

cols = repmat(cols,1,3);

if p.Results.min ~= -inf
    minB = p.Results.min;
end

if p.Results.max ~= inf
    maxB = p.Results.max;
end

if p.Results.incr ~= inf
    incr = p.Results.incr;
else
    incr = ((maxB - minB)/20);
end

bins = (minB+incr):incr:(maxB-incr);
bins = minB:incr:maxB;
% else
%     bins = incr:incr:(maxB-incr);
% end


    for dd = 1:size(distD,2)
        allBars = [];
        for an = 1:size(distD,1)
            bd = distD{an,dd};
            if size(bd,1) > 1 || size(bd,2) > 1
                bd = bd(:);
            end
            [bar1 xs] = hist(bd,bins); bar1 = 100*bar1/sum(bar1);
%             [bar1 xs] = hist(bd,bins); bar1 = 100*bar1/length(bd);
            allBars = [allBars;bar1];
        end
        if strcmp(pdf_or_cdf,'cdf');
            [mDist,semDist] = findMeanAndStandardError(cumsum(allBars,2));
        end
        if strcmp(pdf_or_cdf,'pdf');
            [mDist,semDist] = findMeanAndStandardError(allBars);
        end
        if strcmp(graphType,'line')
            shadedErrorBar(bins,mDist,semDist,{'color',cols{dd},'linewidth',0.25},0.7);
        end
        if strcmp(graphType,'bar')
            xdata = bins; means = mDist; sems = semDist; barwidth = 0.7;
            for ii = 1:length(xdata)
                hb1 = bar_patch(xdata(ii),means(ii),sems(ii),barwidth);
                set(hb1,'FaceColor',cols{ii},'EdgeColor',cols{ii});
                errorbar(xdata(ii), means(ii), sems(ii), 'k', 'linestyle', 'none','CapSize',3);
                hb(ii) = hb1;
            end
        end
        mVals(dd,:) = mDist;
        semVals(dd,:) = semDist;
    end
    xs = bins;
    ha = gca;
%     sigR = significanceTesting(distD);
    
%     if nargout == 4
%         varargout{1} = sigR;
%     end
    axes(ha);
    if ~isempty(legs)
        putLegend(gca,legs,'colors',cols);
    end
