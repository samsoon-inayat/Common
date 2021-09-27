function sigText = getNumberOfAsterisks(pvalue)
if length(pvalue) == 1
    sigText = getnoa(pvalue);
else
    for ii = 1:length(pvalue)
        sigText{ii} = getnoa(pvalue(ii));
    end
end


function sigText = getnoa(pvalue)
sigText = 'ns';
if pvalue < 0.05 && pvalue > 0.01
    sigText = '*'; 
end
if pvalue < 0.01 && pvalue > 0.001
    sigText = '**';
end
if pvalue < 0.001
    sigText = '***';
end