function make_bars_transparent(hbs,alphaval)

for ii = 1:length(hbs)
    set(hbs(ii),'facealpha',alphaval,'EdgeColor','k');
end