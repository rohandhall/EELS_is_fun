function [ output_args ] = PlotImageWithRowMean( imdata )
%PLOTIMAGEWITHROWMEAN creates three axes (image, rowsum, columnsum).
%   imdata  = Image matrix (not fit objects)
%   hfig = handle for figure where this should be placed
%   fbox = [xmin ymin xmax ymax]

[nR, nC] = size(imdata);

subplot(1 ,2 ,1);
 
imagesc(imdata); 
colorbar ;
rowmean = [];
subplot(1, 2, 2);
for r = 1:nR
    rowmean(r) = sum(imdata(r, :))/nC;
end
plot(rowmean);
xlabel('Pixel');
ylabel('Image Mean');
ax = gca;
ax.YAxisLocation = 'right';
view([90, 90]);
end

