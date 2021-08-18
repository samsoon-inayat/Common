function set_colormap(cm)

if ~exist('cm','var')
    cm = colormap(gray);
    cm = flipud(cm(1:size(cm,1),:));
end
colormap(cm);
