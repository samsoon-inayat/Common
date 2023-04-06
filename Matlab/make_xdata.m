function xdata = make_xdata(group_sizes,gaps)

xdata = [];
for ii = 1:length(group_sizes)
    if ii == 1
        xdata = 1:gaps(1):group_sizes(ii);
        continue;
    else
        this_set_st = xdata(end) + gaps(2);
        this_set = this_set_st:gaps(1):(this_set_st+100);
        this_set = this_set(1:group_sizes(ii));
        xdata = [xdata this_set];
    end
end

if length(gaps) > 2
    xdata((1+sum(group_sizes)/2):end) = xdata((1+sum(group_sizes)/2):end) + gaps(3);
end

