function [combs,p] = RMA_populate_combs_and_ps(rm,est_margmean,mcs)
combs = nchoosek(1:size(est_margmean,1),2); p = ones(size(combs,1),1);
ind = find(strcmp(est_margmean.Properties.VariableNames,'Mean'));
all_factors = est_margmean.Properties.VariableNames(1:(ind-1));
if isempty(find(strcmp(all_factors,'Group')))
   wf = 1;
else
    wf = 0;
end
if strcmp(rm.BetweenModel,'1')
    nbf = 0;
else
    nbf = 1;
end
if length(all_factors) == 1
    factor1 = all_factors{1};
    cmdTxt = sprintf('mc_tbl = mcs;'); eval(cmdTxt);
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
        WithinDesgin = rm.WithinDesign;
        factor1 = all_factors{1};
        factor2 = all_factors{2};
        indCol1 = find(strcmp(WithinDesgin.Properties.VariableNames,factor1));
        indCol2 = find(strcmp(WithinDesgin.Properties.VariableNames,factor2));
%         cmdTxt = sprintf('mc_tbl = mcs.%s_%s;',factor1,factor2); eval(cmdTxt);
        cmdTxt = sprintf('mc_tbl1 = mcs;'); eval(cmdTxt);
%         cmdTxt = sprintf('mc_tbl2 = mcs.%s_by_%s;',factor2,factor1); eval(cmdTxt);

        % get the est marg mean rows and first two columns as double type
        % variables instead of categorical
        for ii = 1:size(est_margmean,1)
            tmpstr = string(est_margmean{ii,1:2});
            for sii = 1:length(tmpstr)
               est_marg_rows(ii,sii)  = str2num(tmpstr(sii));
            end
        end
        
        for ii = 1:size(mc_tbl1,1)
            tmpstr = string(mc_tbl1{ii,1:3});
            for sii = 1:length(tmpstr)
               mc_tbl1_rows(ii,sii)  = str2num(tmpstr(sii));
            end
        end
        
        for rr = 1:size(combs,1)
            comp1_ids = est_marg_rows(combs(rr,1),:);
            comp2_ids = est_marg_rows(combs(rr,2),:);
            if comp1_ids == comp2_ids
                continue;
            end
            
            if comp1_ids(1) == comp2_ids(1)
                row_to_find = [comp1_ids comp2_ids(2)];
                if isequal(row_to_find,[1 3 5])
                    n = 0;
                end
                ind = ismember(mc_tbl1_rows,row_to_find,'rows');
                p(rr) = mc_tbl1{ind,6};
            end
%             if comp1_ids(2) == comp2_ids(2)
%                 row_to_find = [comp1_ids(2) comp1_ids(1) comp2_ids(1)];
%                 ind = ismember(mc_tbl1_rows,row_to_find,'rows');
%                 p(rr) = mc_tbl1{ind,6};
%             end
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



