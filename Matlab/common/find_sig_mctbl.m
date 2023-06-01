function mt1 = find_sig_mctbl(mt,pvalcol,alpha)
if nargin == 1
    pvalcol = 5;
    alpha = 0.05;
end
if nargin == 2
    alpha = 0.05;
end
mt = mt(mt{:,pvalcol}<alpha,:);
pvals = mt{:,pvalcol};
upvals = unique(pvals);
for ii = 1:length(upvals)
    ind = find(upvals(ii) == pvals);
    mt1(ii,:) = mt(ind(1),:);
end
if ~exist('mt1','var')
    mt1 = mt;
end