function [ eVdata_0 ] = shiftZLP( eVdata, intdata, eVmin, eVmax )
%SHIFTZLP shifts the zeroloss peak back to "zero" after curvefitting with
%Gaussian
%   eVdata is array of energy, 
%   eVmin and eVmax specify bounds of energy used to search for ZLP 
%   intdata is intensity data corresponding to eVdata
%   eVdata_0 is the corresponding shifted spectrum axis
%   fitnpts is the number of points used to fit ZLP to peak function. 

%These points are used to generate gaussian fit. 
%
eVpts =[];
ipts = [];
%
%

%FITNPTS = fitnpts;

for j = 1:length(eVdata)
    if (eVdata(j) < eVmax && eVdata(j)>eVmin )
        eVpts = [ eVpts; eVdata(j)];
        ipts = [ ipts; intdata(j)] ;
    end
    
end

zlpfit = fit2gauss(eVpts, ipts, floor((length(eVpts) - 1)/2)); %npts set to use all points.
eVdata_0 = eVdata - zlpfit.b;

end

