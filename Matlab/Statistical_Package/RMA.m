function out = RMA(between,within,alpha)
if ~exist('alpha','var')
    alpha = 0.05;
end
[between_factors,nbf] = get_between_factors(between);
nwf = size(within,2);
if nbf > 1 || nwf > 3
    disp('number of between factors <=1 or number of within factors <=2');
    error;
end
within_factors = within.Properties.VariableNames;
%% define repeated measures model and do ranova
wilk_text = build_wilk_text(between,between_factors);
rm = fitrm(between,wilk_text);
[rm.WithinDesign,rm.WithinModel] = build_within_design_and_model(within);
out.number_of_between_factors = nbf;
out.number_of_within_factors = nwf;
out.rm = rm;
out.mauchly = mauchly(rm);
out.ranova = rm.ranova('WithinModel',rm.WithinModel);
%*********************
% if within_factors are 2 then in the updated within table there is
% interaction term as well e.g., Type and Dominance ... thenlast column
% would be Type_Dominance
%*********************
all_factors = [between_factors within_factors];
[out.EM,out.GS] = get_EM_GS(rm,within_factors); % est_marg_means
out.MC = do_MC(rm,alpha); % all multiple comparisons
out.all_factors = all_factors';
% if nwf <= 2
out = populate_combs_ps(out);
% end
% mcs_bonferroni = populate_combs_and_ps(rm,est_margmean,mcs_bonferroni,0);
% mcs_lsd = populate_combs_and_ps(rm,est_margmean,mcs_lsd,0);
% mcs_bonferroni_wf = populate_combs_and_ps(rm,est_margmean_wf,mcs_bonferroni,1);
% mcs_lsd_wf = populate_combs_and_ps(rm,est_margmean_wf,mcs_lsd,1);

function sig_mcs = find_sig_mcs(mcs)

field_names = fields(mcs);
for ii = 1:length(field_names)
    cmdTxt = sprintf('thisTable = mcs.%s;',field_names{ii});
    eval(cmdTxt);
    if strcmp(thisTable.Properties.VariableNames{3},'Difference')
        sig_thisTable = find_sig_mctbl(thisTable,5);
    else
        sig_thisTable = find_sig_mctbl(thisTable,6);
    end
    cmdTxt = sprintf('sig_mcs.%s = sig_thisTable;',field_names{ii});
    eval(cmdTxt);
end

function wilk_text = build_wilk_text(between,between_factors)
if isempty(between_factors)
    between_term = '1';
    st = 1;
end
if length(between_factors) == 1
    between_term = between_factors{1};
    st = 2;
end
wilk_text = '';
for ii = st:size(between,2)
    wilk_text = [wilk_text between.Properties.VariableNames{ii} ','];
end
wilk_text(end) = '~';
wilk_text = [wilk_text between_term];

function [within,within_model] = build_within_design_and_model(within)
nwf = size(within,2);
within_factors = within.Properties.VariableNames;
if nwf == 3
    combs = nchoosek(1:3,2);
    for ii = 1:size(combs,1)
        f = combs(ii,1); s = combs(ii,2);
        cmdTxt = sprintf('within.%s_%s = within.%s.*within.%s;',within_factors{f},within_factors{s},within_factors{f},within_factors{s});
        eval(cmdTxt);
    end
    cmdTxt = sprintf('within.%s_%s_%s = within.%s.*within.%s.*within.%s;',within_factors{1},within_factors{2},within_factors{3},within_factors{1},within_factors{2},within_factors{3});
    eval(cmdTxt);
    within_factors = within.Properties.VariableNames;
end
if nwf == 2
    cmdTxt = sprintf('within.%s_%s = within.%s.*within.%s;',within_factors{1},within_factors{2},within_factors{1},within_factors{2});
    eval(cmdTxt);
    within_factors = within.Properties.VariableNames;
end
if nwf == 1
    within_model = within_factors{1};
end
if nwf == 2
    within_model = [within_factors{1} '*' within_factors{2}];
end
if nwf == 3
    within_model = [within_factors{1} '*' within_factors{2} '*' within_factors{3}];
end

function [between_factors,nbf] = get_between_factors(between)
b_varNames = between.Properties.VariableNames;
nbf = 0;
between_factors = [];
for ii = 1:length(b_varNames)
    cmdTxt = sprintf('colClass = class(between.%s);',b_varNames{ii});
    eval(cmdTxt);
    if strcmp(colClass,'categorical')
        nbf = nbf + 1;
        between_factors{nbf} = b_varNames{ii};
    end
end

function [EM,GS] = get_EM_GS(rm,within_factors)
all_factors = [rm.BetweenFactorNames rm.WithinFactorNames];
all_factors1 = [rm.BetweenFactorNames within_factors];
for ii = 1:length(all_factors)
    cmdTxt = sprintf('[EM.%s GS.%s] = get_est_margmean_and_group_stats(rm,all_factors(ii));',all_factors{ii},all_factors{ii}); eval(cmdTxt);
end
if length(all_factors) > 2
    f_combs = nchoosek(1:length(all_factors),2);
    for ii = 1:size(f_combs,1)
    %     ii
        fac1 = all_factors{f_combs(ii,1)}; fac2 = all_factors{f_combs(ii,2)};
        try
            cmdTxt = sprintf('[EM.%s_by_%s GS.%s_by_%s] = get_est_margmean_and_group_stats(rm,all_factors(f_combs(ii,:)));',fac1,fac2,fac1,fac2); eval(cmdTxt);
        catch
        end
    end
end

if length(all_factors) > 3
    f_combs = nchoosek(1:length(all_factors),3);
    for ii = 1:size(f_combs,1)
    %     ii
        fac1 = all_factors{f_combs(ii,1)}; fac2 = all_factors{f_combs(ii,2)}; fac3 = all_factors{f_combs(ii,3)};
        try
            cmdTxt = sprintf('[EM.%s_by_%s_by_%s GS.%s_by_%s_by_%s] = get_est_margmean_and_group_stats(rm,all_factors(f_combs(ii,:)));',fac1,fac2,fac3,fac1,fac2,fac3); eval(cmdTxt);
        catch
        end
    end
end

function [est_margmean,grp_stats] = get_est_margmean_and_group_stats(rm,all_factors)
est_margmean = margmean(rm,all_factors);
grp_stats = grpstats(rm,all_factors);
cemm = size(grp_stats,2); grp_stats{:,cemm+1} = grp_stats.std./sqrt(grp_stats.GroupCount);
grp_stats.Properties.VariableNames{cemm+1} = 'StdErr';
cemm = size(est_margmean,2);
est_margmean{:,cemm+1} = grp_stats{:,end};
est_margmean.Properties.VariableNames{cemm+1} = 'Formula_StdErr';

function MC = do_MC(rm,alpha)
MC.bonferroni = do_multiple_comparisons(rm,'bonferroni',alpha);
% MC.lsd = do_multiple_comparisons(rm,'lsd',alpha);
% MC.tukey_kramer = do_multiple_comparisons(rm,'tukey-kramer',alpha);

function mcs = do_multiple_comparisons(rm,comparison_type,alpha)
all_factors = [rm.BetweenFactorNames rm.WithinFactorNames];
for ii = 1:length(all_factors)
    nameOfVariable = sprintf('mcs.%s',all_factors{ii});
    rhs = sprintf('multcompare(rm,all_factors{ii},''ComparisonType'',''%s'',''Alpha'',%d);',comparison_type,alpha);
    cmdTxt = sprintf('%s = %s;',nameOfVariable,rhs); eval(cmdTxt)
end
if length(all_factors) > 1
    combs = flipud(perms(1:length(all_factors)));
%     combs = combs(:,1:2);
    combs = unique(combs(:,[1 2]),'rows');
%     combs = nchoosek(1:length(all_factors),2);
    for ii = 1:size(combs,1)
        ind1 = combs(ii,1); ind2 = combs(ii,2);
        nameOfVariable = sprintf('mcs.%s_by_%s',all_factors{ind1},all_factors{ind2});
        rhs = sprintf('multcompare(rm,all_factors{ind1},''By'',all_factors{ind2},''ComparisonType'',''%s'',''Alpha'',%d);',comparison_type,alpha);
        cmdTxt = sprintf('%s = %s;',nameOfVariable,rhs); 
        eval(cmdTxt);
    end
end


function out = populate_combs_ps(out)
rm = out.rm;
EMs = out.EM;
MC = out.MC;
fields = fieldnames(EMs);
fieldsMC = fieldnames(MC);
for ii = 1:length(fields)
    cmdTxt = sprintf('est_margmean = EMs.%s;',fields{ii}); eval(cmdTxt);
    for jj = 1:length(fieldsMC)
        cmdTxt = sprintf('mcs = MC.%s;',fieldsMC{jj}); eval(cmdTxt);
        cmdTxt = sprintf('[combs{ii,jj},p{ii,jj}] = populate_combs_and_ps(rm,est_margmean,mcs);'); 
        try
            eval(cmdTxt);
        catch
            combs{ii,jj} = NaN;
            p{ii,jj} = NaN;
            disp('Combs ps error');
        end
    end
end
out.combs = combs;
out.ps = p;

function [combs,p] = populate_combs_and_ps(rm,est_margmean,mcs)
combs = nchoosek(1:size(est_margmean,1),2); p = ones(size(combs,1),1);
ind = find(strcmp(est_margmean.Properties.VariableNames,'Mean'));
all_factors = est_margmean.Properties.VariableNames(1:(ind-1));
if isempty(find(strcmp(all_factors,'Group')))
   wf = 1;
else
    wf = 0;
end
if wf == 1
    nbf = 0;
else
    nbf = 1;
end
if length(all_factors) == 1
    factor1 = all_factors{1};
    cmdTxt = sprintf('mc_tbl = mcs.%s;',factor1); eval(cmdTxt);
    for rr = 1:size(combs,1)
        row1 = combs(rr,1); row2 = combs(rr,2);
        with_level_1_1 = est_margmean{row1,1};
        with_level_1_2 = est_margmean{row2,1};
        tmc = mc_tbl;
        value_to_check = with_level_1_1; row_col1 = tmc{:,1}==value_to_check;
        value_to_check = with_level_1_2; row_col2 = tmc{:,2}==value_to_check;
        rowN = find(row_col1 & row_col2);
        p(rr) = tmc{rowN,5};
    end
end

if length(all_factors) == 2
    if nbf == 0
        factor1 = all_factors{1};
        factor2 = all_factors{2};
        cmdTxt = sprintf('mc_tbl = mcs.%s_%s;',factor1,factor2); eval(cmdTxt);
        for rr = 1:size(combs,1)
            row1 = combs(rr,1); row2 = combs(rr,2);
            with_level_1_1 = est_margmean{row1,1};
            with_level_2_1 = est_margmean{row1,2};
            w12_1 = categorical(with_level_1_1).*categorical(with_level_2_1);
            with_level_1_2 = est_margmean{row2,1};
            with_level_2_2 = est_margmean{row2,2};
            w12_2 = categorical(with_level_1_2).*categorical(with_level_2_2);
            tmc = mc_tbl;
            value_to_check = w12_1; row_col1 = tmc{:,1}==value_to_check;
            value_to_check = w12_2; row_col2 = tmc{:,2}==value_to_check;
            rowN = find(row_col1 & row_col2);
            p(rr) = tmc{rowN,5};
        end
    end
    if nbf == 1
        factor1 = all_factors{1};
        factor2 = all_factors{2};
        cmdTxt = sprintf('mc_w_by_b = mcs.%s_by_%s;',factor2,factor1); eval(cmdTxt);
        cmdTxt = sprintf('mc_b_by_w = mcs.%s_by_%s;',factor1,factor2); eval(cmdTxt);
%         processed_rows = [];
        for rr = 1:size(combs,1)
            row1 = combs(rr,1); row2 = combs(rr,2);
            group_val_1 = est_margmean{row1,1};
            with_level_1_1 = est_margmean{row1,2};
            group_val_2 = est_margmean{row2,1};
            with_level_1_2 = est_margmean{row2,2};
            if group_val_1 == group_val_2
                all_g_vals = mc_w_by_b{:,1};
                tmc = mc_w_by_b(all_g_vals == group_val_1,2:end);
                value_to_check = with_level_1_1; row_col1 = tmc{:,1}==value_to_check;
                value_to_check = with_level_1_2; row_col2 = tmc{:,2}==value_to_check;
                rowN = find(row_col1 & row_col2);
                p(rr) = tmc{rowN,5}; 
%                 processed_rows = [processed_rows rr];
                continue;
            end
            if with_level_1_1 == with_level_1_2
                all_g_vals = mc_b_by_w{:,1};
                tmc = mc_b_by_w(all_g_vals == with_level_1_1,2:end);
                value_to_check = group_val_1; row_col1 = tmc{:,1}==value_to_check;
                value_to_check = group_val_2; row_col2 = tmc{:,2}==value_to_check;
                rowN = find(row_col1 & row_col2);
                p(rr) = tmc{rowN,5};
%                 processed_rows = [processed_rows rr];
                continue;
            end
        end
    end
end

if length(all_factors) > 2
    if nbf == 0
        factor1 = all_factors{1};
        factor2 = all_factors{2};
        cmdTxt = sprintf('mc_w_by_b = mcs.%s_by_%s;',factor2,factor1); eval(cmdTxt);
        cmdTxt = sprintf('mc_b_by_w = mcs.%s_by_%s;',factor1,factor2); eval(cmdTxt);
%         processed_rows = [];
        for rr = 1:size(combs,1)
            row1 = combs(rr,1); row2 = combs(rr,2);
            group_val_1 = est_margmean{row1,1};
            with_level_1_1 = est_margmean{row1,2};
            group_val_2 = est_margmean{row2,1};
            with_level_1_2 = est_margmean{row2,2};
            if group_val_1 == group_val_2
                all_g_vals = mc_w_by_b{:,1};
                tmc = mc_w_by_b(all_g_vals == group_val_1,2:end);
                value_to_check = with_level_1_1; row_col1 = tmc{:,1}==value_to_check;
                value_to_check = with_level_1_2; row_col2 = tmc{:,2}==value_to_check;
                rowN = find(row_col1 & row_col2);
                p(rr) = tmc{rowN,5}; 
%                 processed_rows = [processed_rows rr];
                continue;
            end
            if with_level_1_1 == with_level_1_2
                all_g_vals = mc_b_by_w{:,1};
                tmc = mc_b_by_w(all_g_vals == with_level_1_1,2:end);
                value_to_check = group_val_1; row_col1 = tmc{:,1}==value_to_check;
                value_to_check = group_val_2; row_col2 = tmc{:,2}==value_to_check;
                rowN = find(row_col1 & row_col2);
                p(rr) = tmc{rowN,5};
%                 processed_rows = [processed_rows rr];
                continue;
            end
        end
    end
    
    if nbf == 1
        factor1 = all_factors{1};
        factor2 = all_factors{2};
        factor3 = all_factors{3};
        cmdTxt = sprintf('mc_w_by_b = mcs.%s_%s_by_%s;',factor2,factor3,factor1); eval(cmdTxt);
        cmdTxt = sprintf('mc_b_by_w = mcs.%s_by_%s_%s;',factor1,factor2,factor3); eval(cmdTxt);
        for rr = 1:size(combs,1)
            row1 = combs(rr,1); row2 = combs(rr,2);
            group_val_1 = est_margmean{row1,1};
            with_level_1_1 = est_margmean{row1,2};
            with_level_2_1 = est_margmean{row1,3};
            w12_1 = categorical(with_level_1_1).*categorical(with_level_2_1);

            group_val_2 = est_margmean{row2,1};
            with_level_1_2 = est_margmean{row2,2};
            with_level_2_2 = est_margmean{row2,3};
            w12_2 = categorical(with_level_1_2).*categorical(with_level_2_2);

    %             disp([group_val_1 w12_1 group_val_2 w12_2])

            if group_val_1 == group_val_2
                all_g_vals = mc_w_by_b{:,1};
                tmc = mc_w_by_b(all_g_vals == group_val_1,2:end);
                value_to_check = w12_1; row_col1 = tmc{:,1}==value_to_check;
                value_to_check = w12_2; row_col2 = tmc{:,2}==value_to_check;
                rowN = find(row_col1 & row_col2);
                p(rr) = tmc{rowN,5};
            else
                if w12_1 == w12_2
                    all_w12 = mc_b_by_w{:,1};
                    tmc = mc_b_by_w(all_w12 == w12_1,2:end);
                    value_to_check = group_val_1; row_col1 = tmc{:,1}==value_to_check;
                    value_to_check = group_val_2; row_col2 = tmc{:,2}==value_to_check;
                    rowN = find(row_col1 & row_col2);
                    p(rr) = tmc{rowN,5};
                else
                    n = 0;
                end
            end
        end
    end
end
% mcs.combs = combs;
% mcs.p = p;






