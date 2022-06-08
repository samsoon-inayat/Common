function put_sig_lines(hf,ha,hbs,msem,p,specs)

for rr = size(hbs,1)
    put_sig_line(hf,ha,hbs(rr,:),msem(rr,:),p(rr),specs);
end

function put_sig_line(hf,ha,hbs,msem,p,specs)

sigLineWidth = specs{1};
start_factor = specs{2};
height = specs{3};
sigAsteriskFontSize = specs{4};
sigColor = specs{5};
sigText = getNumberOfAsterisks(p);


temp = get(hbs(1),'XData'); x1 = min(temp) + ((max(temp)-min(temp))/2);
temp = get(hbs(2),'XData'); x2 = min(temp) + ((max(temp)-min(temp))/2);

y1 = msem(1); y2 = msem(2);

yy = max([y1 y2]) + start_factor;

line([x1 x2], [yy yy],'linewidth',sigLineWidth,'color',sigColor);
line([x1 x1], [yy-height yy],'linewidth',sigLineWidth,'color',sigColor);
line([x2 x2], [yy-height yy],'linewidth',sigLineWidth,'color',sigColor);
xt1 = x1 + (x2-x1)/2;
text(xt1,yy+yy/10,sigText,'FontSize',sigAsteriskFontSize,'HorizontalAlignment','center','Color',sigColor);

