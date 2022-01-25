function field_val = get_struct_field(struc,field)

if ~iscell(field)
else
    for ii = 1:length(field)
        this_field = field{ii};
        cmdTxt = sprintf('field_val(ii).%s = struc.%s',this_field);
    end
end
