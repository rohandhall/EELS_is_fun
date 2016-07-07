function [ fitobj, gof ] = fit2Drude( xdata, ydata )
%FIT2DRUDE Fits the entered data to a Drude model
%   Parameters returned:
% a     : peak height
% gamma : width
% x0    : peak position
% b     : background
xdata = reshape(xdata, [length(xdata), 1]);
ydata = reshape(ydata, [length(ydata), 1]);
%search for reasonable start parameters
[astart , pkindex] = max(ydata);
x0start= xdata(pkindex);

foundFWHM =0; fwhm_index  = pkindex;

for j = pkindex: length(xdata)
    if ydata(j) < astart/2 && foundFWHM ==0
        foundFWHM =1;
        fwhm_index = j;
    end
end
fwhm=abs(xdata(fwhm_index) - xdata(pkindex) )*2;

gammastart =fwhm;
bstart =0;
startpts = [astart   , bstart  , gammastart, x0start];
lower    = [0        , 0    , .01       ,x0start/2 ];
%upper    = [astart*10,astart/4 , fwhm*5    ,x0start*2];

drude = 'a*gamma*(x0^2)/((x*gamma)^2+(x^2 -x0^2)^2) + b';
[fitobj, gof] = fit(xdata, ydata, drude, 'Start', startpts, 'Lower', lower);
end

