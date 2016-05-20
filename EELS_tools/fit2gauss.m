function [ fitobj, gof ] = fit2gauss( xdata, ydata, npts  )
%FIT2GAUSS provides gaussian fit to given data
%   npts are the number of point on either side of peak max to use for
%   fitting.
%   GOF is the goodness of fit metric

xdata = reshape(xdata, [length(xdata), 1]) ;
ydata = reshape(ydata, [length(ydata), 1]) ; %reshape to column matrix

gaussEqn = 'a*exp(-((x-b)/c)^2)+d';

%guess start points: 
[astart, pkindex] = max(ydata);
bstart = xdata(pkindex);
%guess width
cstart =  1;
%
dstart = 0;
startpts = [astart, bstart, cstart, dstart];

if pkindex < npts
    npts = pkindex-1;
end
if length(xdata) - pkindex < npts
    npts = length(xdata) - pkindex;
end

[fitobj, gof] = fit (xdata(pkindex-npts:pkindex+npts), ydata((pkindex-npts:pkindex+npts)), gaussEqn,'Start', startpts);


end

