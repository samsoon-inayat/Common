function RMA_visualize(ra,facs)%,gaps,tcolors,limsY,mData)

figure(100);clf;plot(0,0);
mData = evalin('base','mData');
gaps = [1 1.75];
[xdata,mVar,semVar,combs,p,h] = get_vals_RMA(mData,ra,facs,gaps,'no');
maxV = max(mVar + semVar);
% minV = min(mVar - semVar);


tcolors = repmat(mData.dcolors(1:10),1,3); MY = 100; ysp = 5; mY = 0; ystf = 5; ysigf = 0.025;titletxt = ''; ylabeltxt = {'Cells (%)'}; % for all cells (vals) MY = 80
[hbs,xdata,mVar,semVar,combs,p,h] = view_results_rmanova([],ra,{facs,'hsd',0.05},[1 1.75],tcolors,[mY MY ysp ystf ysigf],mData);
