function out = exec_fun_on_cell_mat(inp,fun)

if ~iscell(fun)
    cmdTxt = sprintf('out = arrayfun(@(x) %s(x{1}),inp);',fun);
    eval(cmdTxt);
else
    for ii = 1:length(fun)
        cmdTxt = sprintf('out.%s = arrayfun(@(x) %s(x{1}),inp);',fun{ii},fun{ii}); eval(cmdTxt);
    end
end
