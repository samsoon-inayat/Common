function [dataTR,withinR] = reduce_within_between(dataT,withini,redFi,redV)

if length(redFi) > 1
    [redF,ib] = sort(redFi);
    redV = redV(ib);
    facnames = withini.Properties.VariableNames;
    within = withini;
    for fi = 1:length(redF)
        tfn = facnames(redF(fi));
        facnamest = within.Properties.VariableNames;
        colNum = find(strcmp(facnamest,tfn));
        [dataT,within] = reduce_within_between(dataT,within,colNum,redV(fi));
    end
    dataTR = dataT; withinR = within;
else
    redF = redFi;
    within = withini;
    withinD = within{:,:};
    rows = zeros(size(withinD,1),1);
    wfe = [];
    for fi = 1:length(redF)
        tV = redV{fi};
        for vi = 1:length(tV)
            rows = rows | withinD(:,redF(fi)) == tV(vi);
        end
        if length(tV) == 1
            wfe = [wfe redF(fi)];
        end
    end

    nbf = size(dataT,2) - size(withinD,1);
    cols = logical([ones(1,nbf) rows']);

    dataTR = dataT(:,cols);
    colsW = setdiff(1:size(within,2),wfe);
    withinR = within(rows,colsW);
end


