function shift_axes_up (ff,axn,shft,gap)

for rr = 1:size(axn,1)
    for aii = 1:size(axn,2)
        sel_ax = ff.h_axes(rr,axn(rr,aii));
        axesPosd = get(sel_ax,'Position');
        axesPosd = axesPosd + shft;
        set(sel_ax,'Position',axesPosd);
    end
end
