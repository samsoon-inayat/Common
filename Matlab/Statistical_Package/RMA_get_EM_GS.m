function [est_margmean,grp_stats] = RMA_get_EM_GS(rm,all_factors)
est_margmean = margmean(rm,all_factors);
grp_stats = grpstats(rm,all_factors);
cemm = size(grp_stats,2); grp_stats{:,cemm+1} = grp_stats.std./sqrt(grp_stats.GroupCount);
grp_stats.Properties.VariableNames{cemm+1} = 'StdErr';
cemm = size(est_margmean,2);
est_margmean{:,cemm+1} = grp_stats{:,end};
est_margmean.Properties.VariableNames{cemm+1} = 'Formula_StdErr';
