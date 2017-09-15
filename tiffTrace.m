function[meanTrace] = tiffTrace(tiffStackOriginal)

%Create space for incoming mean Intensity values
stacksize = length(tiffStackOriginal);
meanIntensitystack = zeros(stacksize,1);

%Take avg intensity of whole FOV for each individual image
for i = 1:stacksize;
    imageslice = squeeze(tiffStackOriginal(:,:,i));
    averagepixel = mean(mean(imageslice));
    meanIntensitystack(i) = averagepixel;
end

meanTrace = meanIntensitystack;


end
    