function [hx,hy] = put_axes_labels(ha,xlab,ylab)
hx = NaN; hy = NaN;
xlims = get(gca,'xlim');
ylims = get(gca,'ylim');

tlab = xlab;
if ~isempty(tlab)
    label = tlab{1};
    pos_l = tlab{2};
    hc = xlabel(label); hx = hc;
    if ~isempty(pos_l)
        changePosition(hc,pos_l);
    end
end

tlab = ylab;
if ~isempty(tlab)
    label = tlab{1};
    pos_l = tlab{2};
    hc = ylabel(label); hy = hc;
    if ~isempty(pos_l)
        changePosition(hc,pos_l);
    end
end

