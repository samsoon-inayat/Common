function out = descriptiveStatistics (data,varargin)

p = inputParser;
addRequired(p,'data',@isnumeric);
addOptional(p,'dimension',1,@isnumeric);
addOptional(p,'decimal_places',3,@isnumeric);
% addOptional(p,'max',inf,@isnumeric);
% addOptional(p,'colors',default_colors,@iscell);
% addOptional(p,'maxY',100,@isnumeric);
% addOptional(p,'cumPos',0,@isnumeric);
% addOptional(p,'barGraph',{},@iscell);
% addOptional(p,'legend',{},@iscell);
% addOptional(p,'BaseValue',0.2,@isnumeric);
addOptional(p,'do_mean','Yes');
parse(p,data,varargin{:});

dimension = p.Results.dimension;
decimal_places = p.Results.decimal_places;

[avg,se,sd,med] = findMeanAndStandardError(data,dimension);

out.avg = avg;
out.med = med;
out.sem = se;
out.sd = sd;
minD = nanmin(data,[],dimension);
maxD = nanmax(data,[],dimension);
out.min = minD;
out.max = maxD;

if isvector(data)
    txt = sprintf('(average: %%.%df; median: %%.%df; standard error: %%.%df; standard deviation: %%.%df; range: %%.%df,%%.%df)',decimal_places,decimal_places,decimal_places,decimal_places,decimal_places,decimal_places);
    cmdTxt = sprintf('out.txt = sprintf(''%s'',avg,med,se,sd,minD,maxD);',txt);
    eval(cmdTxt);
    txt = sprintf('%%.%df %%c %%.%df (range: %%.%df, %%.%df, median: %%.%df)',decimal_places,decimal_places,decimal_places,decimal_places,decimal_places);
    cmdTxt = sprintf('atxt = sprintf(''mean %%c sem, %s'',pmchar,avg,pmchar,se,minD,maxD,med);',txt);
    pmchar=char(177);
    eval(cmdTxt);
    disp(atxt);
    hf = get_figure(555,[10,10,3,0.15]);
    text(-0.1,0,atxt,'FontSize',6);
    axis off;
    mData = evalin('base','mData');
    save_pdf(hf,mData.pdf_folder,'ds.pdf',600);
    close(hf);
end