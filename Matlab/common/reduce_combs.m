function [combs,p,h] = reduce_combs(combs,p,h,lim)

n = 0;
ncombs = [];
for ii = 1:length(lim)
    tlim = lim{ii};
    ncombs = [ncombs;nchoosek(tlim,2)];
end
inds = [];
for ii = 1:size(ncombs,1)
    [Lia, Locb] = ismember(ncombs(ii,:),combs,'rows');
    if ~isempty(Locb)
        inds = [inds;Locb];
    end
end

combs = combs(inds,:);
p = p(inds);
h = h(inds);