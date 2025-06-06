function [within,dataT_var_names,xlabels,withinD] = make_within_table(var_names,nwf)
nfac = length(var_names);
wvar = NaN(prod(nwf),nfac);
ind = 1;
for ii = 1:length(var_names)
    FL(ii) = var_names{ii}(1);
end
for ii = 1:nwf(1)
    if nfac == 1
        wvar(ind,:) = ii;
        dataT_var_names{ind} = sprintf('%s%d',FL(1),ii);
        xlabels{ind} = sprintf('%s%d',FL(1),ii);
        ind = ind + 1;
        continue;
    end
    for jj = 1:nwf(2)
        if nfac == 2
            wvar(ind,:) = [ii jj];
            dataT_var_names{ind} = sprintf('%s%d_%s%d',FL(1),ii,FL(2),jj);
            xlabels{ind} = sprintf('%s%d-%s%d',FL(1),ii,FL(2),jj);
            ind = ind + 1;
            continue;
        end
        for kk = 1:nwf(3)
            if nfac == 3
                wvar(ind,:) = [ii jj kk];
                dataT_var_names{ind} = sprintf('%s%d_%s%d_%s%d',FL(1),ii,FL(2),jj,FL(3),kk);
                xlabels{ind} = sprintf('%s%d-%s%d-%s%d',FL(1),ii,FL(2),jj,FL(3),kk);
                ind = ind + 1;
                continue;
            end
            for ll = 1:nwf(4)
                if nfac == 4
                    wvar(ind,:) = [ii jj kk ll];
                    dataT_var_names{ind} = sprintf('%s%d_%s%d_%s%d_%s%d',FL(1),ii,FL(2),jj,FL(3),kk,FL(4),ll);
                    xlabels{ind} = sprintf('%s%d-%s%d-%s%d-%s%d',FL(1),ii,FL(2),jj,FL(3),kk,FL(4),ll);
                    ind = ind + 1;
                    continue;
                end
                for mm = 1:nwf(5)
                    if nfac == 5
                        wvar(ind,:) = [ii jj kk ll mm];
                        dataT_var_names{ind} = sprintf('%s%d_%s%d_%s%d_%s%d_%s%d',FL(1),ii,FL(2),jj,FL(3),kk,FL(4),ll,FL(5),mm);
                        xlabels{ind} = sprintf('%s%d-%s%d-%s%d-%s%d-%s%d',FL(1),ii,FL(2),jj,FL(3),kk,FL(4),ll,FL(5),mm);
                        ind = ind + 1;
                        continue;
                    end
                    for nn = 1:nwf(6)
                        wvar(ind,:) = [ii jj kk ll mm nn];
                        dataT_var_names{ind} = sprintf('%s%d_%s%d_%s%d_%s%d_%s%d_%s%d',FL(1),ii,FL(2),jj,FL(3),kk,FL(4),ll,FL(5),mm,FL(6),nn);
                        xlabels{ind} = sprintf('%s%d-%s%d-%s%d-%s%d-%s%d-%s%d',FL(1),ii,FL(2),jj,FL(3),kk,FL(4),ll,FL(5),mm,FL(6),nn);
                        ind = ind + 1;
                    end
                end
            end
        end
    end
end
withinD = wvar;
within = array2table(wvar);
within.Properties.VariableNames = var_names;
% for ii = 1:length(var_names)
%     cmdTxt = sprintf('within.%s = categorical(within.%s);',var_names{ii},var_names{ii});
%     eval(cmdTxt);
% end







