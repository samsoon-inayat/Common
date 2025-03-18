function [pooled_data,withinR,withinD] = pool_within_between(ra,fac)

data_matrix = table2array(ra.rm.BetweenDesign);
pooled_data = zeros(5, 12);

all_facs = ra.all_factors;
cmpfacs = ~strcmp(all_facs,fac);
grpfacs = all_facs(cmpfacs);
within = ra.withinD;


% Loop over each animal
for ii = 1:5  
    % Extract data for the i-th animal
    animal_data = data_matrix(ii, :);
    
    % Convert data into a table with corresponding within-subjects conditions
    animal_table = array2table(animal_data(:), 'VariableNames', {'fac'});
    animal_table = [within, animal_table]; % Add within-table factors
    
    % Compute mean pooling over Config_Num
    pooled_animal = varfun(@mean, animal_table, 'GroupingVariables', grpfacs');
    
    % Store in pooled_data (keep only the firing rate means)
    pooled_data(ii, :) = pooled_animal.mean_fac';
end

withinR = pooled_animal(:,1:(length(all_facs)-1));
withinD = table2array(withinR);
