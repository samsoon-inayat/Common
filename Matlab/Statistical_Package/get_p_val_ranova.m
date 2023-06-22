function pval = get_p_val_ranova(ra,fac)


rowNames = ra.ranova.Properties.RowNames;

ind = strcmp(rowNames,sprintf('(Intercept):%s',fac));

pval = ra.ranova{ind,ra.selected_pval_col};