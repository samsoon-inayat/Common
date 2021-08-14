function set_title(ha,titleTxt,xy,FontSize,color)

if ~exist('color','var')
    color = 'k';
end
axes(ha);
text(xy(1),xy(2),titleTxt,'FontSize',FontSize,'color',color);
