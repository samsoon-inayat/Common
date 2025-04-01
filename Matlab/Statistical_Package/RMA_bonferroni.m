function raR = RMA_bonferroni (ra,fac_n)

levels = ra.within.levels(fac_n);
alpha = ra.alpha/levels;


for ii = 1:levels
    redF = [fac_n]; redV = {ii};
    [dataTR,withinR] = reduce_within_between(ra.rm.BetweenDesign,ra.within_table,redF,redV);
    raR{ii} = RMA(dataTR,withinR,{alpha,{''}});
    print_for_manuscript(raR{ii})
end