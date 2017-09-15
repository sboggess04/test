function  [depolarTime] = riseTimeCalc (apd_data,max_i,Fs)
%%Fitting depolarization with nth degree polynomial (2nd :
%     %%p(x)=p1x^2+p2X+p)

    depolar = apd_data(((max_i*Fs)-3):((max_i*Fs)+3)); %identifies the depolarization curve, starts from 100 ms before the maxvalue
    depoltime = linspace(((max_i*Fs)-3)),(max_i*Fs)+3,(((max_i*Fs)-3)-((max_i*Fs)+3)+1);
    depoltime = depoltime';
    fit = polyfit(depoltime,depolar,2); %find coeff for fit
    fitdepolar = polyval(fit,depoltime); %fit curve
    
    figure (3); %check the fit
    hold on;
    plot(depoltime,depolar,'o');
    plot(depoltime,fitdepolar,'x');
%     
%     %%Find derivative and max derivative of polynomial fit
    fitdata2 = diff(fitdepolar,1,1);
    [max_fitder max_fiti] = max(fitdata2,[],1); % find location of max derivative
end
    