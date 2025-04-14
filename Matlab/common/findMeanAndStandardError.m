function [md,sem,varargout] = findMeanAndStandardError (data,varargin)

if isvector(data)
    md = nanmean(data);
    sem = nanstd(data)/sqrt(length(data));
    med = nanmedian(data);
    if nargout == 4
        varargout{1} = nanstd(data);
        varargout{2} = med;
    end
    if nargout == 6
        varargout{1} = nanstd(data);
        varargout{2} = med;
        varargout{3} = nanmin(data);
        varargout{4} = nanmax(data);
    end
%     pmchar=char(177); any_text = sprintf('%.2f%c%.2f',md,pmchar,sem); 
%     disp(any_text);
    return;
end


if nargin > 1
    dim = varargin{1};
    if dim>3
        error;
    end
else
    dim = 1;
end

md = nanmean(data,dim);
sem = nanstd(data,0,dim)./sqrt(size(data,dim));
med = nanmedian(data,dim);

if nargout > 2
    varargout{1} = nanstd(data,0,dim)
    varargout{2} = med;
end
% pmchar=char(177); any_text = sprintf('%.2f%c%.2f',md,pmchar,sem); 
% disp(any_text);

