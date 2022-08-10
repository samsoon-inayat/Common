function [dataTR,withinR,withinDR] = last_column_collapse_to_max(dataT,within)
withinD = within{:,:};
nbf = size(dataT,2) - size(withinD,1);
colsW = 1:(size(within,2)-1);

uv = unique(withinD(:,end));
repsS = 1:length(uv):size(within,1);
repsE = length(uv):length(uv):size(within,1);

dataTT = dataT{:,(nbf+1):end};
varN = dataT.Properties.VariableNames((nbf+1):end);

dataTTT = [];
withinR = [];
for rr = 1:length(repsS)
    sD = dataTT(:,repsS(rr):repsE(rr));
    dataTTT = [dataTTT max(sD,[],2)];
    tempTxt = varN{repsS(rr)};
    inds = strfind(tempTxt,'_');
    varNames{rr} = tempTxt(1:(inds(end)-1));
    withinR(rr,:) = within{repsS(rr),colsW};
end
dataTR = [dataT(:,1:nbf) array2table(dataTTT)];
dataTR.Properties.VariableNames = [dataT.Properties.VariableNames(1:nbf),varNames];

withinR = array2table(withinR);
withinR.Properties.VariableNames = within.Properties.VariableNames(colsW);



