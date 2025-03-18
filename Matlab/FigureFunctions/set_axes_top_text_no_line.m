function ht = set_axes_top_text(hf,sel_ax_i,str,shifts)
hf_pos = get(hf,'Position'); 
  mData = evalin('base','mData');
  FS = 6*mData.magfac;
  
  if strcmp(str,'ns');
      shifts = shifts + [0 0.02 0 0];
  end

for ii = 1:length(sel_ax_i)
    sel_ax = sel_ax_i(ii);
    oldUnits = get(sel_ax, 'Units');
    set(sel_ax, 'Units', 'inches');
    pos = get(sel_ax,'position');
    set(sel_ax, 'Units', oldUnits);
    xlnu1(ii) = pos(1)/hf_pos(3);
    xlnu2(ii) = (pos(1)+pos(3))/hf_pos(3);
    ylnu1(ii) = pos(2)/hf_pos(4);
    ylnu2(ii) = (pos(2)+pos(4))/hf_pos(4);
end

mnx = min(xlnu1);%-0.2;
Mnx = max(xlnu2);

mny = min(ylnu1);%-0.2;
Mny = max(ylnu2);

% ylnu = ylnu2(1);% + ylnu2(1)/15;

% annotation('line',[mnx Mnx],[ylnu ylnu],'linewidth',0.25,'Color','b','linestyle','-');

% mofl = mnx + ((Mnx - mnx)/2);
% mofly = mny + ((Mny - mny)/2);

sizetxt = [mnx mny diff([mnx Mnx]) diff([mny Mny])];

if exist('shifts','var')
    sizetxt = sizetxt + shifts;
end

ht = annotation('textbox',sizetxt,'String',str,'FontSize',FS,'Margin',0,'EdgeColor','none','FaceAlpha',0);

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


