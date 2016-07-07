function [ fig ] = FitObject_CellViewer( CellArrayofFitObjects,model )
%FITOBJECT_CELLVIEWER Summary of this function goes here
%   Detailed explanation goes here

%model = 'Drude';

%Assuming a drude model - implement other cases too!
if (strcmp(model, 'Drude'))
    [nR, nC] = size(CellArrayofFitObjects);
    amp = zeros(size(CellArrayofFitObjects));
    bkgrnd = zeros(size(CellArrayofFitObjects));
    damp = zeros(size(CellArrayofFitObjects));
    energy = zeros(size(CellArrayofFitObjects));

    for r = 1:nR
        for c= 1:nC
            fitob = CellArrayofFitObjects{r,c};
            amp(r,c) = fitob.a;
            bkgrnd(r,c) = fitob.b;
            damp(r,c) = fitob.gamma;
            energy(r,c) = fitob.x0;
        end
    end
elseif strcmp(model, 'Lorentz')
    [nR, nC] = size(CellArrayofFitObjects);
    amp = zeros(size(CellArrayofFitObjects));
    bkgrnd = zeros(size(CellArrayofFitObjects));
    damp = zeros(size(CellArrayofFitObjects));
    energy = zeros(size(CellArrayofFitObjects));

    for r = 1:nR
        for c= 1:nC
            fitob = CellArrayofFitObjects{r,c};
            amp(r,c) = fitob.a;
            bkgrnd(r,c) = fitob.b;
            damp(r,c) = fitob.gamma;
            energy(r,c) = fitob.x0;
        end
    end
end

fig = figure;
title('Drude Model Fitting Results');
subplot(1,4,1);
imagesc(amp); colorbar; title('Amplitude');
subplot(1,4,2);
imagesc(bkgrnd);colorbar; title('Background');
subplot(1,4,3);
imagesc(damp);colorbar; title('Damping');
subplot(1,4,4);
imagesc(energy);colorbar;
title('Plasmon Energy');



end

