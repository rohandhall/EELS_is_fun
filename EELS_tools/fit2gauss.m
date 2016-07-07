function [ fitobj, gof ] = fit2gauss( xdata, ydata  )
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

[fitobj, gof] = fit (xdata, ydata, gaussEqn,'Start', startpts);


end

