function h = eliminate_alternate_combs(combs,p,h,nB)

total_bars = sum(nB);

vals = [];
for ii = 1:length(nB)
    tnB = nB(ii);
    vals{ii} = (ii*tnB-tnB+1):(ii*tnB);
end

ccis = [];
for cci = 1:size(combs,1)
    for ii = 1:length(vals)
        left_vals = vals{ii};
        dA = setdiff(1:length(vals),ii);
        right_vals = [];
        for jj = 1:length(dA)
            right_vals = [right_vals vals{dA(jj)}];
        end
        if ismember(combs(cci,1),left_vals) & ismember(combs(cci,2),right_vals)
            ccis = [ccis;cci];
        end
    end
end
h(ccis) = 0;
