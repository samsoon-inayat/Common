function raR = RMA_R(ra,redFi)

n = 0;
nbf = ra.number_of_between_factors;
nwf = ra.number_of_within_factors;


dataT = ra.rm.BetweenDesign;
within = ra.withinD;

if nbf == 0
    wfactors = ra.within.factors;
    for ii = 1:length(redFi)
        redFF{ii} = redFi{ii};
        redF(ii) = find(strcmp(wfactors,redFi{ii}));
        redL(ii) = ra.within.levels(redF(ii));
        redV{ii} = 1:redL(ii);
    end

    total_tests = prod(redL,'all');
    alpha = ra.alpha/total_tests;

    [~,~,~,withinT] = make_within_table(redFF,redL); %these are trials here

    for ii = 1:size(withinT)
        tredV = mat2cell(withinT(ii,:),[1],ones(1,size(withinT,2)));
        [dataTR,withinR] = reduce_within_between(dataT,within,redF,tredV);
        ras{ii} = RMA(dataTR,withinR,{alpha,{''}});
        tempstr = [];
        for jj = 1:length(redFi)
            tempstr = sprintf('%s :: %s - %d',tempstr,redFi{jj},withinT(ii,jj));
        end
        test_fac_vals{ii} = tempstr;
    end
end

raR.total_tests = total_tests;
raR.within_tests = withinT;
raR.test_fac_vals = test_fac_vals;
raR.ras = ras;

