function make_bars_hollow(hbs)

for ii = 1:length(hbs)
    color = get(hbs(ii),'EdgeColor');
    set(hbs(ii),'facecolor','none','edgecolor',color);
end