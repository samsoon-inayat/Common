function [xdata,mVar,semVar,combs,p,h,colors,hollowsep] = get_vals_for_bar_graph_RMA(mData,ra,facs,gaps)
hollowsep = [];

facname = facs{1};
ttype = facs{2};

cmdTxt = sprintf('mVar = ra.EM.%s.Mean;',facname); eval(cmdTxt);
cmdTxt = sprintf('semVar = ra.EM.%s.Formula_StdErr;',facname); eval(cmdTxt);

fields = fieldnames(ra.MC);
ttypei = find(strcmp(fields,ttype));

fields = fieldnames(ra.EM);
facnamei = find(strcmp(fields,facname));

combs = ra.combs{facnamei,ttypei};
p = ra.ps{facnamei,ttypei};
h = p < 0.05;

cmdTxt = sprintf('EM = ra.EM.%s;',facname); eval(cmdTxt);
ind = find(strcmp(EM.Properties.VariableNames,'Mean'));
all_factors = EM.Properties.VariableNames(1:(ind-1));

if isempty(find(strcmp(all_factors,'Group')))
    num_groups = 1;
else
    num_groups = (unique(ra.rm.BetweenDesign{:,1}));
end

bfs = ra.rm.BetweenFactorNames;
wfs = ra.rm.WithinFactorNames;

for ii = 1:length(all_factors)
    tfac = all_factors{ii};
    ind = find(strcmp(bfs,tfac));
    if ~isempty(ind)
        uvals{ii} = unique(ra.rm.BetweenDesign{:,ind});
    end
    ind = find(strcmp(wfs,tfac));
    if ~isempty(ind)
        uvals{ii} = unique(ra.rm.WithinDesign{:,ind});
    end
end

if length(all_factors) == 1
    unique_conds1 = uvals{1};
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
if length(all_factors) == 2
    unique_conds1 = uvals{1};
    unique_conds2 = uvals{2};
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
if length(all_factors) == 3
    unique_conds1 = uvals{1};
    unique_conds2 = uvals{2};
    unique_conds3 = uvals{3};
    ind = 1; ind_val = 1;
    for gg = 1:length(num_groups)
        for ii = 1:length(unique_conds1)
            for jj = 1:length(unique_conds2)
                for kk = 1:length(unique_conds3)
                    xdata(ind,1) = ind_val;
                    ind = ind + 1;
                    ind_val = ind_val + gaps(1);
                end
            end
            ind_val = ind_val + gaps(2);
        end
        ind_val = ind_val + gaps(3);
    end
    colors = mData.colors(1:length(unique_conds3));
    colors = repmat(colors,length(num_groups)*length(unique_conds1)*length(unique_conds2),1);
    n = 0;
end
