function format_axes(ha)
 mData = evalin('base','mData');
if nargin == 1
    set(ha,'FontSize',mData.magfac*6,'FontWeight','Normal','TickDir','out','linewidth',0.25,'xcolor','k','ycolor','k');
end
