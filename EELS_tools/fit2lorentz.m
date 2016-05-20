function [ fitobj , gof ] = fit2lorentz( xdata, ydata , npts  )
%FIT2LORENTZ fits (xdata, ydata) to a Lorentzian function
%   Returns the fit object, with parameters:
%   a: peak height
%   gamma: width
%   x0: peak position
%   b: background

xdata = reshape(xdata, [length(xdata), 1]) ;
ydata = reshape(ydata, [length(ydata), 1]) ; %reshape to column matrix

[astart, pkindex] = max(ydata);
x0start = xdata(pkindex);

if pkindex < npts
    npts = pkindex-1;
end

if length(xdata) - pkindex < npts
    npts = length(xdata) - pkindex;
end

foundFWHM = 0;
fwhm_index = 1;
for j = pkindex : pkindex+npts
    if ydata(j) < astart/2 && foundFWHM ==0
        fwhm_index  = j;  % this helps guess FWHM
        foundFWHM = 1;
    end
end

fwhm = abs(xdata(fwhm_index) - xdata(pkindex) )*2;
gammastart = fwhm;
bstart = 0;

startpts = [astart, bstart, gammastart, x0start];


lorentzEqn = 'a*gamma/(2*pi*((x-x0)^2+(gamma/2)^2)) + b';
[fitobj, gof] = fit (xdata(pkindex-npts:pkindex+npts), ydata(pkindex-npts:pkindex+npts), lorentzEqn, 'Start',startpts);

end
