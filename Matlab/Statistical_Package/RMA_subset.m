function raR = RMA_subset (ra,fac_n,sb)

% if iscell(ra)
%     for ff = 1:length(fac_n)
%         tfac = fac_n{ff};
%         tra = ra{ff};
%         raR{ff} = RMA_subset(tra,tfac);
%     end
%     return;
% end

if isstr(fac_n)
    fac_n = find(strcmp(ra.within.factors,fac_n));
end
levels = ra.within.levels(fac_n);

if exist('sb','var')
    alpha = ra.alpha/levels;
else
    alpha = ra.alpha;
end


for ii = 1:levels
    redF = [fac_n]; redV = {ii};
    [dataTR,withinR] = reduce_within_between(ra.rm.BetweenDesign,ra.within_table,redF,redV);
    % [within,dvn,xlabels,awithinD] = make_within_table({'CN','TN','PT'},[3,10,3]);
    raR{ii} = RMA(dataTR,withinR,{alpha,{''}});
    print_for_manuscript(raR{ii})
    % err
end