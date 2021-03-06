function [xdata,mVar,semVar,combs,p,h,colors,hollowsep] = get_vals_for_bar_graph(mData,ra,pooled,gaps)
hollowsep = [];
if pooled%~iscell(pooled)
    cmdTxt = sprintf('mVar = ra.pooled.wf_%s.est_margmean.Mean;semVar = ra.pooled.wf_%s.est_margmean.Formula_StdErr',pooled{1},pooled{1});eval(cmdTxt)
    combs = ra.mcs.combs; p = ra.mcs.p; h = ra.mcs.p < 0.05;
else
    mVar = ra.est_marginal_means.Mean;semVar = ra.est_marginal_means.Formula_StdErr;
    combs = ra.mcs.combs; p = ra.mcs.p; h = ra.mcs.p < 0.05;
    if ra.number_of_between_factors == 0
        num_groups = 1;
    else
        num_groups = (unique(ra.rm.BetweenDesign{:,1}));
    end
    rows_within = size(ra.rm.WithinDesign,1);
    if ra.number_of_within_factors == 1
        unique_conds1 = unique(ra.rm.WithinDesign{:,1});
        ind = 1; ind_val = 1;
        for gg = 1:length(num_groups)
            for ii = 1:length(unique_conds1)
                xdata(ind,1) = ind_val;
                ind = ind + 1;
                ind_val = ind_val + gaps(1);
            end
            ind_val = ind_val + gaps(2);
        end
        colors = mData.colors(1:length(unique_conds1));
        colors = repmat(colors,length(num_groups),1);
    end
    if ra.number_of_within_factors == 2
        unique_conds1 = unique(ra.rm.WithinDesign{:,1});
        unique_conds2 = unique(ra.rm.WithinDesign{:,2});
        ind = 1; ind_val = 1;
        for gg = 1:length(num_groups)
            for ii = 1:length(unique_conds1)
                for jj = 1:length(unique_conds2)
                    xdata(ind,1) = ind_val;
                    ind = ind + 1;
                    ind_val = ind_val + gaps(1);
                end
                ind_val = ind_val + gaps(2);
            end
            ind_val = ind_val + gaps(3);
        end
        colors = mData.colors(1:length(unique_conds2));
        colors = repmat(colors,length(num_groups)*length(unique_conds1),1);
    end
    
end

