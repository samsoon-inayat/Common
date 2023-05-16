function [f,dfr,dfe,p] = get_p_val_Fstat(model)

nobs = model.NumObservations;
ssr = max(model.SST - model.SSE,0);
dfr = model.NumEstimatedCoefficients - 1;
dfe = nobs - 1 - dfr;
f = (ssr./dfr) / (model.SSE/dfe);
p = fcdf(1./f,dfe,dfr); % upper tail