function ha1 = display_p_table(ha,hbs,pos,pvt,props)
xlims = get(ha,'xlim');
xdata = get(ha,'xtick');
xticklabels  = get(ha,'xticklabels');
ha1 = duplicate_axes(ha,[0 0.25 0 0.3]); format_axes(ha1); ylim(xlims); 
ptable = pvt;
set(ha1,'xtick',xticks,'xticklabels',[],'ytick',xdata,'yticklabels',xticklabels); xtickangle(45)

for rr = 1:size(ptable,1)
    for cc = 1:size(ptable,2)
        if isnan(ptable(rr,cc)) || ptable(rr,cc) >= 0.05
            continue;
        end
        nast = getNumberOfAsterisks(ptable(rr,cc));
        xv = xdata(rr); yv = xdata(cc);
        text(xv,yv,nast,'FontSize',4,'Color',[0.5 0.5 0.5]);
    end
end
ha1.XColor = [0.5 0.5 0.5]; ha1.YColor = [0.5 0.5 0.5];
ha1.XAxis.Visible = 'Off'; ha1.FontSize = 4;

vend = xlims(2);
axes(ha1);cla
hold on;

ylims = ylim;
% [TLx TLy] = ds2nfu(hbs(1).Vertices(1),ylims(2)-0);
% [BLx BLy] = ds2nfu(hbs(1).Vertices(1),ylims(1));
% aH = (TLy - BLy);

[TLx,~] = ds2nfu(xlims(2),hbs(1).Vertices(1)); % right-lower point of first horizontal bar
[BLx,~] = ds2nfu(xlims(1),hbs(1).Vertices(1)); % left-lower point of first 
aW1 = TLx - BLx;

ii = 1;v1 = hbs(ii).Vertices(1);     v2 = hbs(ii).Vertices(2);
[BLx1 BLy] = ds2nfu(v1,xlims(1));    % figure cooridinates lower left of bar
[BRx BRy1] = ds2nfu(xlims(1),v2);    [BLx BLy1] = ds2nfu(xlims(1),v1);

ii = length(hbs);v1 = hbs(ii).Vertices(1);     v2 = hbs(ii).Vertices(2);
[BRx1,~] = ds2nfu(v2,xlims(1));     % figure coordinates lower right of bar
[~,BRy] = ds2nfu(xlims(1),xlims(2));    [BLx BLy2] = ds2nfu(xlims(1),v1);
aH = BRy - BLy;
% aW1 = (BRx1 - BLx1);

for ii = 1:length(hbs)
    % vertical bars
    v1 = hbs(ii).Vertices(1);  % left of bar (bottom for horizontal ones)
    v2 = hbs(ii).Vertices(2);  % right of bar (top for horizontal ones)
    [BRx BRy] = ds2nfu(v2,xlims(1));     % figure coordinates lower right of bar
    [BLx BLy] = ds2nfu(v1,xlims(1));    % figure cooridinates lower left of bar
    aW = (BRx-BLx); % width of bar is right of bar - left of bar (subtraction of x coordinates)
    annotation('rectangle',[BLx BLy aW aH],'facealpha',0.2,'linestyle','none','facecolor','k');
    % horizontal bars
    [BRx BRy] = ds2nfu(xlims(1),v2); % figure coordinates top left of bar
    [BLx BLy] = ds2nfu(xlims(1),v1); % figure coordinates bottom left of bar
    aH1 = (BRy-BLy); % height of bar is top left - bottom left (subtraction of y coordinates)
    annotation('rectangle',[BLx BLy aW1 aH1],'facealpha',0.2,'linestyle','none','facecolor','k');
    lv(ii) = v1;
    lvc(ii) = v1 + (v2-v1)/1.5;
    lvc1(ii) = v1 + (v2-v1)/10;
%     lv2(ii) = v2;
end


for rr = 1:size(ptable,1)
    for cc = 1:size(ptable,2)
        if isnan(ptable(rr,cc)) || ptable(rr,cc) >= 0.05
            continue;
        end
        nast = getNumberOfAsterisks(ptable(rr,cc));
        xv = lvc(cc); yv = lvc1(rr);%xdata(rr);
        ht = text(xv,yv,nast,'FontSize',4,'Color',[0.5 0.5 0.5]);
        ex = ht.Extent;
        nxv = xv - ex(3)/1.5;
        nyv = yv - ex(4)/2;
        delete(ht);
        ht = text(nxv,yv,nast,'FontSize',4,'Color',[0.5 0.5 0.5]);
        n = 0;
    end
end

