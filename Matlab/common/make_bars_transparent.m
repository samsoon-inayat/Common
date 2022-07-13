function make_bars_transparent(hbs,alphaval)

for ii = 1:length(hbs)
    set(hbs(ii),'facealpha',alphaval,'EdgeColor',[0.5 0.5 0.5]);
end