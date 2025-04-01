function perform_overal_RMA (data,facs)

facs_names = facs{1};
facs_levels = facs{2};

[within,dvn,xlabels,awithinD] = make_within_table(facs_names,facs_levels);
dataT = make_between_table({data},dvn);
ra = RMA(dataT,within,{0.05,{''}});
print_for_manuscript(ra)