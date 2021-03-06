function print_for_manuscript(ra)

disp(sprintf('\n'))
nbf = ra.number_of_between_factors;
nwf = ra.number_of_within_factors;

if nbf == 0
    for ii = 1:2:size(ra.ranova,1)
        F = ra.ranova.F(ii);
        DF1 = ra.ranova.DF(ii); DF2 = ra.ranova.DF(ii+1); 
        p = ra.ranova{ii,ra.selected_pval_col};
        eta = ra.ranova.Eta2{ii}; etaG = ra.ranova.Eta2G{ii}; vtxt = ra.ranova.Row{ii};
        disptxt(vtxt,DF1,DF2,F,p,etaG);
    end
end
if nbf == 1
    if nwf == 1
        dfeb = ra.ranova.DF(3); dfew = ra.ranova.DF(6);
        for ii = 1:size(ra.ranova,1)
            F = ra.ranova.F(ii);
            if ismember(ii,[3 6])
                continue;
            end
            DF1 = ra.ranova.DF(ii); p = ra.ranova{ii,ra.selected_pval_col};
            if ii < 4 DF2 = dfeb; else DF2 = dfew; end
            eta = ra.ranova.Eta2{ii}; etaG = ra.ranova.Eta2G{ii}; vtxt = ra.ranova.Row{ii};
            disptxt(vtxt,DF1,DF2,F,p,etaG);
        end
    end
end

function disptxt(vtxt,DF1,DF2,F,p,eta)

if p < 0.001
    txt = sprintf('%s   [F (%d,%d) = %.2f, p < %*.3f, %c2 = %0.2f]',vtxt,DF1,DF2,F,4,0.001,951,eta);
else
    txt = sprintf('%s   [F (%d,%d) = %.2f, p = %*.3f, %c2 = %0.2f]',vtxt,DF1,DF2,F,4,p,951,eta);
end
%             if p < 0.001
%                 txt = sprintf('%s   [F (%d,%d) = %.2f, p < %*.3f, %c2 = %0.2f, %c2G = %0.2f]',vtxt,DF1,DF2,F,4,0.001,951,eta,951,etaG);
%             else
%                 txt = sprintf('%s   [F (%d,%d) = %.2f, p = %*.3f, %c2 = %0.2f, %c2G = %0.2f]',vtxt,DF1,DF2,F,4,p,951,eta,951,etaG);
%             end
ind = strfind(txt,'p = 0');
txt(ind+4) = []; 
ind = strfind(txt,'2 = 0');
txt(ind+4) = []; 
%             ind = strfind(txt,'2G = 0');
%             txt(ind+5) = []; 
disp(txt)
disp(sprintf('\n'))


% 
% if exist('row','var')
%     if isnumeric(row)
%         ind = row;
%     else
%         ind = row_identifier(ra.ranova.Row,row);
%     end
%     DF1 = ra.ranova.DF(ind); DF2 = ra.ranova.DF(ind+1);
%     F = ra.ranova.F(ind); 
%     try
%         p = ra.ranova.pValue_sel(ind); 
%     catch
%         try
%             p = ra.ranova.pValueGG_sel(ind); 
%         catch
%             p = ra.ranova.pValueHF_sel(ind); 
%         end
%     end
%     eta = ra.ranova.Eta2{ind};
%     vartype = ra.ranova.Row{ind};
%     ind = strfind(vartype,':');
%     vtxt = vartype((ind(1)+1):end);
%     inds = strfind(vtxt,'_');
%     vtxt(inds) = '-';
%     if p < 0.001
%         txt = sprintf('%s   [F (%d,%d) = %.2f, p < %*.3f, %c2 = %0.2f]',vtxt,DF1,DF2,F,4,0.001,951,eta);
%     else
%         txt = sprintf('%s   [F (%d,%d) = %.2f, p = %*.3f, %c2 = %0.2f]',vtxt,DF1,DF2,F,4,p,951,eta);
%     end
%     ind = strfind(txt,'p = 0');
%     txt(ind+4) = []; 
%     ind = strfind(txt,'2 = 0');
%     txt(ind+4) = []; 
%     disp(txt)
%     return;
% end
% try
%     inds = find(ra.ranova.pValue_sel < 0.05);
% catch
%     try
%         inds = find(ra.ranova.pValueGG_sel < 0.05);
%     catch
%         inds = find(ra.ranova.pValueHF_sel < 0.05);
%     end
% end
% if length(inds) > 1
%     ht = 0.15*5;
%     hf = get_figure(555,[10,10,3,ht]);
% end
% ys = 0; gap = 0.25;
% for ii = 1:length(inds)
%     if inds(ii) == 1
%         continue;
%     end
%     txt = print_for_manuscript(ra,inds(ii));
%     hdt = text(-0.1,ys,txt,'FontSize',6);
%     te = get(hdt,'Extent');
%     ys = te(2) + te(4) + gap;
% end
% axis off;
% mData = evalin('base','mData');
% try
% save_pdf(hf,mData.pdf_folder,'rmanova.pdf',600);
% catch
% end
% try
% close(hf);
% catch
% end
% txt =[];
% 
% function ind = row_identifier(rows,row)
% 
% for ii = 1:length(rows)
%     thisr = rows{ii};
%     indcol = strfind(rows{ii},':');
%     if isempty(indcol)
%         continue;
%     end
%     thisr = thisr((indcol(1)+1):end);
%     if strcmp(thisr,row)
%         break;
%     end
% end
% ind = ii;
