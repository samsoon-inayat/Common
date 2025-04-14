function shiftTickLabels(ax, shiftX, shiftY)
    % Function to shift X-tick labels on a given axes handle (ax)
    % shiftX: amount to shift labels left or right (positive for right, negative for left)
    % shiftY: amount to shift labels up or down (positive for up, negative for down)
    

    ax.XRuler.TickLabelGapOffset = shiftX; 
    ax.YRuler.TickLabelGapOffset = shiftY; 