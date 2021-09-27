function [xc,yc] = display_p_table_independent(ha,pvt,rclt,props)
nrows = size(pvt,1);
ncols = size(pvt,2);

lmargin = rclt(3); 
tmargin = rclt(4);

rowHeight = rclt(2);
colWidth = rclt(1);
x = 0; y = 0;
for ii = 2:(ncols+1)
    x(ii) = x(ii-1) + colWidth;
    xc(ii-1) = x(ii-1) + colWidth/2;
end
for ii = 2:(nrows+1)
    y(ii) = y(ii-1) + rowHeight;
    yc(ii-1) = y(ii-1) + rowHeight/2;
end
% make grid lines
axes(ha);cla
hold on;
% vertical lines
for ii = 1:length(x)
    plot([x(ii) x(ii)],[y(1) y(end)],'k','linewidth',0.5);
end
% horizontal lines
for ii = 1:length(y)
    plot([x(1) x(end)],[y(ii) y(ii)],'k','linewidth',0.5);
end
axis equal
box on;
xlim([x(1) x(end)]); ylim([y(1) y(end)]);
set(gca,'Ydir','Reverse','TickDir','out','linewidth',0.25)

for rr = 1:size(pvt,1)
    for cc = 1:size(pvt,2)
%         htxt = text(sc(cc)-colWidth+lmargin,sr(rr),pvt{rr,cc},'FontSize',6);
        htxt = text(x(cc)+lmargin,y(rr)+tmargin,pvt{rr,cc},'FontSize',6);
    end
end

