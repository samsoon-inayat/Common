function ht = set_bar_graph_sub_xtick_text(ff,gv,ticklabels,options)
mData = evalin('base','mData');
magfac = mData.magfac;


hf_pos = get(ff.hf,'Position'); 

pos1 = get(ff.h_axes(1,1),'Position'); pos2 = get(ff.h_axes(1,2),'Position');

ylnu = pos1(2)/hf_pos(4);

if exist('options','var')
    if length(options) == 1
        shifts = options{1};
    else
        shifts = [0 0];
    end
    ylnu = ylnu - (-shifts(1));
else
    shifts = [0 0];
end


inds = 1:gv:length(ff.h_axes);
for iii = 1:length(inds)
    ii = inds(iii);
    pos1 = get(ff.h_axes(1,ii),'Position'); pos2 = get(ff.h_axes(1,ii+1),'Position');
    xlnu1 = pos1(1)/hf_pos(3); xlnu2 = (pos1(1)+pos1(3))/hf_pos(3);
    xlnu1p = pos2(1)/hf_pos(3); xlnu2p = (pos2(1)+pos2(3))/hf_pos(3);
    annotation('line',[xlnu1 xlnu2p],[ylnu ylnu],'linewidth',0.25);
    sztxt = [(xlnu1+(xlnu2p-xlnu1)/3) ylnu-(-shifts(2)) xlnu2-xlnu1 0];
    ht(ii)= annotation('textbox',sztxt,'String',ticklabels{iii},'FontSize',magfac*6,'Margin',0,'EdgeColor','none','FontWeight','Normal');
end
n = 0;

% 
% outerpos = get(sel_ax,'OuterPosition');
% 
% ylnu = outerpos(2)/hf_pos(4);
% 
% if exist('options','var')
%     if length(options) == 1
%         shifts = options{1};
%     else
%         shifts = [0 0];
%     end
%     ylnu = ylnu - (-shifts(1));
% else
%     shifts = [0 0];
% end
% 
% lhbs = length(hbs);
% inds = 1:gv:lhbs;
% for ii = 1:length(inds)
%     tempx1 = get(hbs(inds(ii)),'XData'); tempx2 = get(hbs(inds(ii)+gv-1),'XData');
%     [nx(1) ~] = ds2nfu(sel_ax,tempx1(1),0);
%     [nx(2) ~] = ds2nfu(sel_ax,tempx2(2),0);
%     annotation('line',nx,[ylnu ylnu],'linewidth',0.25);
%     ylnut = ylnu/1.3;
%     if exist('shifts','var')
%         if length(shifts) == 2
%             ylnut = ylnut + shifts(2);
%         end
%     end
%     ht(ii)= annotation('textbox',[nx(1) 0 diff(nx) ylnut],'String',ticklabels{ii},'FontSize',magfac*6,'Margin',0,'EdgeColor','w','FontWeight','Normal');
% end
% 
% 