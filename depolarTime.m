function [] = depolarTime(time , depolarCurve)

%Smooth input of depolarization
smoothDepolar = medfilt1(depolarCurve,5,'truncate');

%normalize values to 1
[minDepolar max_i] = min(smoothDepolar);
[maxDepolar max_j] = max(smoothDepolar);
diffDepolar = maxDepolar-minDepolar;
normalDepolar = ((smoothDepolar-minDepolar)/diffDepolar);

%Find max derivative of the non-fitted data
dFoverFdt = diff(normalDepolar , 1 , 1); % first derivative
[max_der , max_k] = max(dFoverFdt , [] , 1); % find location of max derivative
time2 = time(2:end,:);
figure;
hold on;
plot (time2 , dFoverFdt); %plot d(df/f)dt

%Fit polynomial to sigmoidal curve.
[pDepolar , S , mu] = polyfit (time , normalDepolar , 3);
figure;
hold on;
plot (time , normalDepolar, 'o');
fitDepolar = polyval (pDepolar , time , [] , mu); %fit depolarlization
plot (time, fitDepolar); %evaluate the fit

end