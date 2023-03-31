function adata = make_text_file_for_nlme_R(var,filename)

n = 0;

adata = [];
number_of_days = size(var,2)-1;
for rr = 1:size(var,1)
    data = [];
    data(:,1) = rr*ones(number_of_days,1);
    data(:,2) = 0:(number_of_days-1);
    data(:,3) = var(rr,2:end);
    data(:,4) = var(rr,1)*ones(number_of_days,1);
    adata = [adata;data];
end

writematrix(adata,filename);