function set_bar_graph_sub_xtick_text(hf,sel_ax,hbs,gv,ticklabels,options)
mData = evalin('base','mData');
magfac = mData.magfac;
outerpos = get(sel_ax,'OuterPosition');
hf_pos = get(hf,'Position'); 
ylnu = outerpos(2)/hf_pos(4);

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

lhbs = length(hbs);
inds = 1:gv:lhbs;
for ii = 1:length(inds)
    tempx1 = get(hbs(inds(ii)),'XData'); tempx2 = get(hbs(inds(ii)+gv-1),'XData');
    [nx(1) ~] = ds2nfu(sel_ax,tempx1(1),0);
    [nx(2) ~] = ds2nfu(sel_ax,tempx2(2),0);
    annotation('line',nx,[ylnu ylnu],'linewidth',0.25);
    ylnut = ylnu/1.3;
    if exist('shifts','var')
        if length(shifts) == 2
            ylnut = ylnut + shifts(2);
        end
    end
    annotation('textbox',[nx(1) 0 diff(nx) ylnut],'String',ticklabels{ii},'FontSize',magfac*6,'Margin',0,'EdgeColor','w','FontWeight','Bold');
end


