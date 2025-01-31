function [xdata,mVar,semVar,combs,p,h,nB] = get_vals_RMA(mData,ra,facs,gaps,simple)

if nargin == 4
    simple = 'no';
end

mData.colors = [mData.colors;mData.colors;mData.colors;mData.colors;mData.colors];

factors = facs{1};
posthoc = facs{2};
if length(facs) == 3
    alpha = facs{3};
else
    alpha = ra.alpha;
end



nfac = length(strfind(factors,':'))+1;

poscol = strfind(factors,':');
if isempty(poscol)
    facs = {factors};
else
    facs = [];
    facs{1} = factors(1:(poscol(1)-1));
    for ii = 2:nfac
        if ii == nfac
            facs{ii} = factors((poscol(ii-1)+1):end);
        else
            facs{ii} = factors((poscol(ii-1)+1):(poscol(ii)-1));
        end
    end
end
[EMs,GS] = RMA_get_EM_GS(ra.rm,facs);

mVar = EMs.Mean;
semVar = EMs.Formula_StdErr;
% facs = fliplr(facs);
if nfac == 1
    Lev1 = ra.within.levels(strcmp(ra.within.factors,factors));
    nB = Lev1;
    xdata = make_xdata(nB,gaps); 
    mcs = multcompare(ra.rm,facs,'ComparisonType',posthoc,'Alpha',alpha);
    [combs,p] = RMA_populate_combs_and_ps(ra.rm,EMs,mcs);
    h = p < alpha;
    [combs,p,h] = rearrange_combs(combs,p,h);
end

if nfac == 2
    fac1 = facs{1};
    fac2 = facs{2};
    Lev1 = ra.within.levels(strcmp(ra.within.factors,fac1));
    Lev2 = ra.within.levels(strcmp(ra.within.factors,fac2));
    nB = repmat(Lev2,1,Lev1);
    xdata = make_xdata(nB,gaps);
    
    nameOfVariable = sprintf('mcs.%s_by_%s',fac2,fac1);
    rhs = sprintf('multcompare(ra.rm,fac2,''By'',fac1,''ComparisonType'',''%s'',''Alpha'',%d);',posthoc,alpha);
    cmdTxt = sprintf('%s = %s;',nameOfVariable,rhs); 
    eval(cmdTxt);
    
    nameOfVariable = sprintf('mcs.%s_by_%s',fac1,fac2);
    rhs = sprintf('multcompare(ra.rm,fac1,''By'',fac2,''ComparisonType'',''%s'',''Alpha'',%d);',posthoc,alpha);
    cmdTxt = sprintf('%s = %s;',nameOfVariable,rhs); 
    eval(cmdTxt);
    
%     mcs = multcompare(ra.rm,fac2,'By',fac1,'ComparisonType',posthoc,'Alpha',alpha);
    [combs,p] = RMA_populate_combs_and_ps(ra.rm,EMs,mcs);
    h = p < alpha;
    [h1,ccis] = eliminate_alternate_combs(combs,p,h,nB);
    combs = [combs ccis];
    if strcmp(simple,'yes')
        h = eliminate_alternate_combs(combs,p,h,nB);
    end
    [combs,p,h] = rearrange_combs(combs,p,h);

end

if nfac == 3
    fac1 = facs{1};
    fac2 = facs{2};
    fac3 = facs{3};
    Lev1 = ra.within.levels(strcmp(ra.within.factors,fac1));
    Lev2 = ra.within.levels(strcmp(ra.within.factors,fac2));
    Lev3 = ra.within.levels(strcmp(ra.within.factors,fac3));
    nB = repmat(Lev3,1,Lev2);
    nB = repmat(nB,1,Lev1)
    xdata = make_xdata(nB,gaps);
    combs = [];
    p = [];
    h = [];
end

