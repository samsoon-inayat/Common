function mcs = RMA_do_multiple_comparisons(rm,comparison_type,alpha)
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

