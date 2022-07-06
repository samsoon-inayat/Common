function adjust_axes (ff,ylims,stp,widths,gap,ylabeltxt)

% ff = makeFigureRowsCols(107,[1 0.5 4 1],'RowsCols',[1 2],...
%         'spaceRowsCols',[0.01 -0.02],'rightUpShifts',[0.07 0.26],'widthHeightAdjustment',...
%         [10 -410]);    set(gcf,'color','w');    set(gcf,'Position',[10 3 1.6 1.25]);
% %     MY = 30; ysp = 2; sigLinesStartYFactor = 1.5; mY = 0; % responsive cells
% %     MY = 70; ysp = 5; sigLinesStartYFactor = 1.5; mY = 0; % responsive fidelity
% %     MY = 1.5; ysp = 0.15; sigLinesStartYFactor = 0.1; mY = -0.25; % responsive fidelity
%     stp = 0.43; widths = [0.4 0.4 0.4 0.4 0.4 0.4]+0.1; gap = 0.09;
if size(ff.h_axes,1) == 1
    set(ff.hf,'Units','inches');
    for aii = 1:length(ff.h_axes)
        sel_ax = ff.h_axes(1,aii);
        set(sel_ax,'Units','inches');
        axesPosd = get(sel_ax,'Position');
        if aii == 1
            rt = stp; 
            ylabel(sel_ax,ylabeltxt);
        else
            rt = rt + widths(aii-1) + gap; set(sel_ax,'yticklabels',[]);
        end
        set(sel_ax,'Position',[rt axesPosd(2) widths(aii) axesPosd(4)]);
        ylim(sel_ax,ylims);
    end
else
    set(ff.hf,'Units','inches');
    for rr = 1:size(ff.h_axes,1)
        for aii = 1:size(ff.h_axes,2)
            sel_ax = ff.h_axes(rr,aii);
            set(sel_ax,'Units','inches');
            axesPosd = get(sel_ax,'Position');
            if aii == 1
                rt = stp; 
                ylabel(sel_ax,ylabeltxt);
            else
                rt = rt + widths(aii-1) + gap; set(sel_ax,'yticklabels',[]);
            end
            set(sel_ax,'Position',[rt axesPosd(2) widths(aii) axesPosd(4)]);
            ylim(sel_ax,ylims);
            end
    end
end