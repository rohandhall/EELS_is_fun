function [ shifted_SI_cell ] = shift_SI_cell( in_SI_cell,zlp_eVmin,zlp_eVmax )
%SI_SHIFTZLP Shifts spectra by zeroing ZLP at each pixel in a spectrum image
%   Steps:
%   1-search for maxima between zlp_eVmin and zlp_eVmax   
%   2- used fitnpts number of points on either side of maxima to fit the
%   zero loss peak

[nR, nC] = size(in_SI_cell) ;

shifted_SI_cell = cell(nR, nC);

for r = 1:nR
    for c=1:nC
        %DO STUFF
        XYvals  = in_SI_cell{r,c};
        eVpts = XYvals(:,1); 
        intpts = XYvals(:,2);
        eVpts_shifted = shiftZLP(eVpts, intpts,zlp_eVmin, zlp_eVmax) ;
        shifted_SI_cell{r,c} = [eVpts_shifted, intpts];
    end
end


end

