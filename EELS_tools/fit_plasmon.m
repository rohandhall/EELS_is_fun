function [ plasmon_fitob_cell, gof_cell ] = fit_plasmon( shifted_SI_cell, plasmon_min_eV, plasmon_max_eV,fit_type, display_axes)
%FIT_PLASMON this will fit the low loss plasmon peak in a SIcell. 
%MAKE SURE ZLP SHIFT HAS BEEN PERFORMED!!
%   It returns an array of fitobjects which have corresponding fitting
%   parameters at each pixel.

[nR, nC] = size(shifted_SI_cell);

%fit_type = 'Lorentz';

plasmon_fitob_cell = cell(nR, nC);
gof_cell = cell(nR, nC);
h = waitbar(0,'Please wait...');

for r=1:nR
    for c=1:nC
        eVpts = shifted_SI_cell{r,c}(:,1);
        intpts = shifted_SI_cell{r,c}(:,2);
        plasmon_eV = [];
        plasmon_int = [];
        for j = 1:length(eVpts)
            if eVpts(j) <= plasmon_max_eV && eVpts(j) >=plasmon_min_eV 
                plasmon_eV = [plasmon_eV ; eVpts(j)];
                plasmon_int =[plasmon_int; intpts(j)];
            end
        end
        waitbar( (nC*(r-1) +c)/(nR*nC) );
        [plasmon_fitob_cell{r,c} , gof_cell{r,c}, errm ] = fit2peak(plasmon_eV, plasmon_int, fit_type); 
        %This stuff is new (7/25)
        axes(display_axes);
        plot(plasmon_fitob_cell{r,c},plasmon_eV, plasmon_int)
        %End of new stuff
        if ~strcmp(errm, 'NULL')
            errordlg('Error in Fit2Peak or fit_plasmon');
        end
    end
end
close(h);
end

