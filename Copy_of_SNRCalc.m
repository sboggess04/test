function [SNR] = lambert_SNRCalc(lastEventStart , meanTrace , dF , Fs)

%%Calculates an approx SNR for the whole input trace based off the dFoverF
%%calcuation and a calculate standard deviation of the noise of the
%%baseline just before the first depolarization/event detected

%inputs

%%find index of largest change and indices of the baseline before the event
%%you want
% z = findchangepts(smoothData) ;
startBase = (150*(Fs/1000)) ; %extends the baseline further up. Can modify!
% endBase = (40*(Fs/1000)) ; %%determines the baseline as 165 to 40 ms before the found depolarization
z = lastEventStart;
iStartBase = z - startBase ;
iEndBase = z ;

%Determine baseline
foundBaseline = (meanTrace(iStartBase:iEndBase)) ;

%now calculate the std of this to find noise of trace
noise = std(foundBaseline) ;

%calcualte SNR
SNR = dF/noise ;

end