function out = exec_fun_on_cell_mat(inpi,fun,resp)

if strcmp(fun,'percent')
    out = find_percent(inpi);
    return;
end


if exist('resp','var')
    for rr = 1:size(inpi,1)
        for cc = 1:size(inpi,2)
            thisV = inpi{rr,cc};
            inp{rr,cc} = thisV(resp{rr,cc});
        end
    end
else
    inp = inpi;
end


if ~iscell(fun)
    cmdTxt = sprintf('out = arrayfun(@(x) %s(x{1}),inp,''un'',0);',fun);
    eval(cmdTxt);
    out = cell2mat(out);
else
    for ii = 1:length(fun)
        cmdTxt = sprintf('out.%s = arrayfun(@(x) %s(x{1}),inp);',fun{ii},fun{ii}); eval(cmdTxt);
    end
end
