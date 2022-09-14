function shift_axes (ff,axn,shft,gap)

for rr = 1:size(axn,1)
    for aii = 1:size(axn,2)
      if aii == 1
        sel_ax = ff.h_axes(rr,axn(rr,aii));
        axesPosd = get(sel_ax,'Position');
        axesPosd = axesPosd + [shft 0 0 0];
        set(sel_ax,'Position',axesPosd);
      else
        sel_ax = ff.h_axes(rr,axn(rr,aii));
        axesPosd = get(sel_ax,'Position');
        axesPosd = [lastpos(1)+lastpos(3)+gap axesPosd(2) axesPosd(3) axesPosd(4)];
        set(sel_ax,'Position',axesPosd);
      end
      lastpos = axesPosd;
    end
end
