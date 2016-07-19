function [ output_args ] = View_SIFits()
%VIEW_SIFITS Summary of this function goes here
%   Detailed explanation goes here

[fname, fdir] = uigetfile();
SI_data = load(strcat(fdir, fname)); 
SI_object = SI_data.si;


[df4_fname, df4_fdir] =uigetfile('*.dm3', 'Assign DF4 Image');
df4 = DM3Import(strcat(df4_fdir, df4_fname));
df4_im = df4.image_data;

%find the properties in object: 
prpts = fieldnames(SI_object);
if isfield(SI_object, 'DrudeFitCell')
    %Plot Drude Fits a , b , gamma , x0
    f1 = figure;
    subplot(1,5, 1);
    imagesc(df4_im);
    colormap gray;
    title('DF4 Image');
    axis image;
    [nR, nC] = size(SI_object.DrudeFitCell);
    PlasmonEnergy = [];
    PlasmonAmp = [];
    PlasmonWidth = [];
    PlasmonBkg =[];
    for r = 1:nR
        for c= 1:nC
            drude = SI_object.DrudeFitCell{r,c};
            PlasmonEnergy(r,c) = drude.x0;
            PlasmonAmp(r,c) = drude.a;
            PlasmonWidth(r,c) = drude.gamma;
            PlasmonBkg(r,c) = drude.b;  
        end
    end
    
    subplot(1,5,2);
    title('Plasmon Energy (eV)');
    imagesc(PlasmonEnergy);
    axis image;
    colorbar;
    
    subplot(1,5,3);
    title('Plasmon Width (eV)');
    imagesc(PlasmonWidth);
    axis image;
    colorbar;
    
    subplot(1,5,4);
    title('Plasmon Amplitude');
    imagesc(PlasmonAmp);
    axis image;
    colorbar;
    
    subplot(1,5,5);
    title('Background');
    imagesc(PlasmonBkg);
    axis image;
    colorbar;
    
   
    
end
if isfield(SI_object, 'LorentzFitCell')
    %plot Lorentz Fits a , b , gamma , x0
    f2 = figure;
    subplot(1,5, 1);
    imagesc(df4_im);
    colormap gray;
    title('DF4 Image');
    
    [nR, nC] = size(SI_object.LorentzFitCell);
    PlasmonEnergy = [];
    PlasmonAmp = [];
    PlasmonWidth = [];
    PlasmonBkg =[];
    for r = 1:nR
        for c= 1:nC
            lorentz = SI_object.LorentzFitCell{r,c};
            PlasmonEnergy(r,c) = lorentz.x0;
            PlasmonAmp(r,c) = lorentz.a;
            PlasmonWidth(r,c) = lorentz.gamma;
            PlasmonBkg(r,c) = lorentz.b;  
        end
    end
    
    subplot(1,5,2);
    title('Plasmon Energy (eV)');
    imagesc(PlasmonEnergy);
    axis image;
    colorbar;
    
    subplot(1,5,3);
    title('Plasmon Width (eV)');
    imagesc(PlasmonWidth);
    axis image;
    colorbar;
    
    subplot(1,5,4);
    title('Plasmon Amplitude');
    imagesc(PlasmonAmp);
    axis image;
    colorbar;
    
    subplot(1,5,5);
    title('Background');
    imagesc(PlasmonBkg);
    axis image;
    colorbar;
    
end


end

