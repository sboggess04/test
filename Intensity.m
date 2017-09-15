name='Snap image - 1';

fn = sprintf('%s.tiff',name);
a=double(imread(fn));
figure('Name','Choose ROIs then Background')
imagesc(a)
colormap(gray)
axis image
hold on

bkg=GETROI(1);

[Vbkg,area] = ROI4(a,bkg(1,:),bkg(2,:),bkg(3,:),bkg(4,:));

b=a-Vbkg;

mx=(max(max(b)));
thresh = (mx/100)*30;
thresh=round(thresh);

F=b(b>thresh);

avg_F=mean(F);
med_F=median(F);

save snap1



 




