function changePosition(hc,upos)

if length(hc) == 1
    pos = get(hc,'Position');
    pos = pos + upos;
    set(hc,'Position',pos);
else
    for ii = 1:length(hc)
        changePosition(hc(ii),upos);
    end
end