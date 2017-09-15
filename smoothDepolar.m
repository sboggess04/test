function [smoothDepolar] = smoothDepolar(time, depolarCurve)

%Smooth input of depolarization
figure;
hold on;
plot (time, depolarCurve);

smoothDepolar = medfilt1(depolarCurve,5,'truncate');
plot (time, smoothDepolar);

end