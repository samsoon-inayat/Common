function ha1 = duplicate_axes (ha,posS)

pos = get(ha,'position'); pos = pos + posS; ha1 = axes('Position',pos);
axes(ha);
xlims = xlim;
ylims = ylim;
axes(ha1);
xlim(xlims);
ylim(ylims);
