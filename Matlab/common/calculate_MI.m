function MI = calculate_MI(FR,stimulus,nbinFRSH)

if isempty(stimulus)
    spatial_bin=1:size(FR,2);
    stimulus=repmat(spatial_bin,size(FR,1),1);
end

FRtemp=FR(:); FRtemp=FRtemp(~isnan(FRtemp));
stimulus=stimulus(:); stimulus=stimulus(~isnan(FR(:)));

%if nshuffles~=0, disp('SHANNON''s Mutual Information...'); end
FRbin=NaN(size(FRtemp));
%tempedges = quantile(FRtemp,linspace(0,1,nbinFRSH+1)); tempedges(end)=tempedges(end)+0.01;
tempedges=[min(FRtemp) quantile(FRtemp(FRtemp>min(FRtemp)),linspace(0,1,nbinFRSH))]; 
tempedges(end)=tempedges(end)+0.01;

for b=1:length(tempedges)-1
    FRbin(FRtemp>=tempedges(b) & FRtemp<tempedges(b+1))=b;
end
MI = MutualInformation(stimulus,FRbin);