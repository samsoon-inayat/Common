function raR = RMA_bonferroni (ra,fac_n)



if isstr(fac_n)
    fac_n = find(strcmp(ra.within.factors,fac_n));
end

levels = ra.within.levels(fac_n);
alpha = ra.alpha/levels;


for ii = 1:levels
    redF = [fac_n]; redV = {ii};
    [dataTR,withinR] = reduce_within_between(ra.rm.BetweenDesign,ra.within_table,redF,redV);
    raR{ii} = RMA(dataTR,withinR,{alpha,{''}});
    disp(ii)
    print_for_manuscript(raR{ii})
end