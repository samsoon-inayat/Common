function [xdata,mVar,semVar,combs,p,h,colors,xlabels,extras] = get_vals_for_bar_graph_RMA(mData,ra,facs,gaps)
hollowsep = [];

mData.colors = [mData.colors;mData.colors;mData.colors;mData.colors;mData.colors];

facname = facs{1};
ttype = facs{2};

cmdTxt = sprintf('mVar = ra.EM.%s.Mean;',facname); eval(cmdTxt);
cmdTxt = sprintf('semVar = ra.EM.%s.Formula_StdErr;',facname); eval(cmdTxt);

fields = fieldnames(ra.MC);
ttypei = find(strcmp(fields,ttype));

fields = fieldnames(ra.EM);
facnamei = find(strcmp(fields,facname));

combs = ra.combs{facnamei,ttypei};
if isnan(combs)
    p = NaN; h = NaN;
else
    p = ra.ps{facnamei,ttypei};
    h = p < 0.05;
end


cmdTxt = sprintf('EM = ra.EM.%s;',facname); eval(cmdTxt);
ind = find(strcmp(EM.Properties.VariableNames,'Mean'));
all_factors = EM.Properties.VariableNames(1:(ind-1));

for ii = 1:size(EM,1)
    txt = '';
    for jj = 1:length(all_factors)
        txt = [txt ' ' all_factors{jj} '_' char(EM{ii,jj})];
    end
    posu = findstr(txt,'_'); txt(posu) = '-';
    xlabels{ii} = txt;
end

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

if isnan(combs)
    return;
end

pvalsTable = nan(length(mVar),length(mVar));
pvalsTableT = cell(length(mVar),length(mVar));
for ii = 1:size(combs,1)
    pvalsTable(combs(ii,1),combs(ii,2)) = p(ii);
    pvalsTable(combs(ii,2),combs(ii,1)) = p(ii);
end
for rr = 1:size(pvalsTable,1)
    for cc = 1:size(pvalsTable,2)
        if isnan(pvalsTable(rr,cc))
           pvalsTableT{rr,cc} = '';
        else
            ast = getNumberOfAsterisks(pvalsTable(rr,cc));
            if strcmp(ast,'ns')
                pvalsTableT{rr,cc} = '';%sprintf('%.3f',pvalsTable(rr,cc));
            else
                pvalsTableT{rr,cc} = sprintf('%.3f (%s)',pvalsTable(rr,cc),ast);
                pvalsTableT{rr,cc} = sprintf('%.3f',pvalsTable(rr,cc));
            end
        end
    end
end
pvalsTableTxt = table(pvalsTable);
extras.pvalsTable = pvalsTable;
extras.pvalsTableTxt = pvalsTableT;

