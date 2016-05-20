function [ pkfit, gof, errmsg ] = fit2peak( xdata, ydata,npts, pktype )
%FIT2PEAK fits given xdata, ydata to Gaussian or Lorentzian lineshape 
%   xdata and ydata arrays must be of equal dimensions.
%   Looks for maxima in the given data and uses npts on either side of
%   maxima for fitting
%   pktype can be Gauss or Lorentz
%   pkfit is a structure with properties depending on pktype, including
%   width, height, position of the given peak

errmsg = 'NULL';

if size(xdata) ~= size(ydata)
    errmsg = 'X and Y data have different dimensions';
    pkfit =[];
else
    if (strcmp(pktype,'gauss') || strcmp(pktype,'Gauss') || strcmp(pktype,'GAUSS') ) 
        [pkfit, gof] = fit2gauss(xdata, ydata, npts);
    elseif (strcmp(pktype,'lorentz') || strcmp(pktype,'Lorentz') || strcmp(pktype,'LORENTZ') )
        [pkfit, gof] = fit2lorentz(xdata, ydata, npts);
    else
        errmsg = 'UNKNOWN PEAK TYPE';
        pkfit=[];
end

end

