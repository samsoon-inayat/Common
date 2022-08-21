function dvn = remove_character(dvn,chr)

if ~istable(dvn)
    for ii = 1:length(dvn)
        tdvn = dvn{ii};
        inds = strfind(tdvn,chr);
        tdvn(inds) = [];
        dvn{ii} = tdvn;
    end
else
    for ii = 1:size(dvn,1)
        tdvn = dvn{ii,1};
        if iscell(tdvn)
            tdvn = tdvn{1,1};
        end
        inds = strfind(tdvn,chr);
        tdvn(inds) = [];
        dvn{ii,2} = tdvn;
    end
end