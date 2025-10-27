function ht = set_axes_top_text(hf,sel_ax_i,str,shifts)
hf_pos = get(hf,'Position'); 
for ii = 1:length(sel_ax_i)
    sel_ax = sel_ax_i(ii);
    pos = get(sel_ax,'position');
    xlnu1(ii) = pos(1)/hf_pos(3);
    xlnu2(ii) = (pos(1)+pos(3))/hf_pos(3);
    ylnu2(ii) = (pos(2)+pos(4))/hf_pos(4);
end

mnx = min(xlnu1);%-0.2;
Mnx = max(xlnu2);
if iscell(shifts)
  shifts_line = shifts{1};
  shifts_text = shifts{2};
else
  shifts_line = 0;
  shifts_text = shifts;
end
ylnu = ylnu2(1) + shifts_line;

annotation('line',[mnx Mnx],[ylnu ylnu],'linewidth',0.25,'Color','k','linestyle','-');

mofl = mnx + ((Mnx - mnx)/2);

sizetxt = [mnx ylnu diff([mnx Mnx]) ylnu/10];

if exist('shifts','var')
    sizetxt = sizetxt + shifts_text;
end

ht = annotation('textbox',sizetxt,'String',str,'FontSize',6,'Margin',0,'EdgeColor','none','FaceAlpha',0);

% for aii = 1:length(ff.h_axes)
%     sel_ax = ff.h_axes(1,aii);axes(sel_ax);
%     xlims = get(sel_ax,'xlim'); ylims = get(sel_ax,'ylim'); xlimshalf = xlims(1) + diff(xlims)/2; title_txt = sprintf('%s%s',title_prefix,titles{aii});
%     ht = text(xlimshalf,ylims(2)+ysp,title_txt,'FontSize',6); ht_ex = get(ht,'Extent'); ht_pos = get(ht,'Position'); 
%     new_x = xlims(1) + (xlims(2) - xlims(1) - ht_ex(3))/2; set(ht,'Position',[new_x ht_pos(2:3)]);
% end

% lhbs = length(hbs);
% inds = 1:gv:lhbs;
% for ii = 1:length(inds)
%     tempx1 = get(hbs(inds(ii)),'XData'); tempx2 = get(hbs(inds(ii)+gv-1),'XData');
%     [nx(1) ~] = ds2nfu(sel_ax,tempx1(1),0);
%     [nx(2) ~] = ds2nfu(sel_ax,tempx2(2),0); 
%     annotation('line',nx,[ylnu ylnu],'linewidth',0.25);
%     annotation('textbox',[nx(1) 0 diff(nx) ylnu/1.3],'String',ticklabels{ii},'FontSize',6,'Margin',0,'EdgeColor','w');
% end


