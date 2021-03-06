function [cAP_Data] = csv_apdCalc(filename,Fs,outputName,folder_name,csvRoiTraces)

%original call apdCalc(data,start,endp,Fs,percent,maxAPD,minAPD,motion,coordinate,bg)
% The function [actC] = apdCalc() calculates the mean APD and the standard
%deviation in the area selected.

%INPUTS
%wholeData= intensity values(voltage,etc)
%Time = x axis
%Fs=sampling frequency
%outputName = file name containing data table and calculated values

% OUTPUT
% Statistical analysis of APD50, APD90, upstroke duration (in ms), %dF/F etc. of the
% action potentials included in the trace.

% METHOD
%We use the the maximum derivative of the upstroke as the initial point of
%activation. The time of repolarization is determine by finding the time
%at which the maximum of the signal falls to the desired percentage. APD is
%the difference between the two time points.

% REFERENCES
%None

% ADDITIONAL NOTES
% None

% RELEASE VERSION 1.0.0

% Original AUTHOR: Matt Sulkin (sulkin.matt@gmail.com)from wustl

% Modifications: Steven Boggess (sboggess@berkeley.edu)%
% Julia Lazzari-Dean deserves a lot of credit to get this going, taking
% what was already written by Matt and helping Steven stitch something
% workable together to play with. Thanks Julia!!!

%%Define file path and outputname
outputName = strrep(outputName,'.fli.csv','');
outputPath = folder_name;
outputPath = strcat(outputPath,'\');
fullOutputName = [outputPath outputName];

%%Load trace
numTraces = length(csvRoiTraces) ;



for jj = 1:numTraces
    
    currentTrace = csvRoiTraces{jj} ;
    %%Normalize the data to 1;
    normCurrentTrace = csv_normalcAP(currentTrace);
    %%Read size
    numstacks = length (currentTrace);
    timeElap = numstacks*(1/Fs);
    time = zeros (numstacks,1); %pre-allocate;
    cnt = 1; %start the count;
    for ii = (1:numstacks)
        time(cnt) = (ii/Fs);
        cnt = cnt + 1;
    end
    
    %%apdCalc
    
    %Define constants
    requiredVal90 = 0.1;
    requiredVal50 = 0.5;
    requiredVal30 = 0.7;
    
    %%Smooth the data for further analysis
    if Fs <2499
        smoothData = medfilt1(normCurrentTrace,5,'truncate');
    end
    
    if Fs > 2500
        smoothData = medfilt1(normCurrentTrace,10,'truncate');
    end
    %%Call backcor GUI and perform background correction)
    
    % background = backcor(time1,smoothData); %%brings up backcor GUI in seperate window. Choose correction from here.
    background = asymmtLSF(smoothData,100000000, 0.000001);
    corrData = (smoothData - background); %perform background correction based baseline values from previous line
    
    %%plot crude and smoothed plots on one figure, plot corrected trace on a second
    h = figure('name',outputName,'numbertitle','off');
    subplot(2,1,1);
    hold on;
    title('Raw and Smoothed Traces');
    % xlabel('Time(sec)');
    ylabel('Intensity');
    plot(time,currentTrace);
    plot(time,smoothData);
    % legend('Raw Trace','Smoothed Trace');
    set (gca , 'OuterPosition' , [0 , 0.68 , 1 ,0.325]);
    maxTrace = max(smoothData);
    minTrace = min(smoothData);
    ylim([(minTrace-0.05),(maxTrace+0.05)]);
    
    subplot(2,1,2);
    hold on;
    title('Background Corrected Trace');
    xlabel('Time(sec)');
    ylabel('Intensity');
    plot (time,corrData);
    set (gca , 'OuterPosition' , [0 , 0.35 , 1 ,0.325]);
    ylim([-0.5, inf]);
    
    
    %Define threshold on corrected data
    %     threshold = (((max(corrData)- min(corrData))*0.3) + min(corrData)); %initially the threshold is 30% of the max signal of corrected trace
    % threshold = threshold+1 ; %adding the 2 as caution against baseline/no activity. Can change if the noise level of low-signal traces breaks this.
    
    %     %%Call thresholddetection%%
    %     %plot all chopped data in subplot
    %     [chopData , eventStart , eventEnd] = ThresholdDetection(corrData,threshold,Fs);
    %
    %     eventDetector = isempty(chopData);
    
    %     if eventDetector == 0 %case where events were detected
    
    %     numEvents = length(chopData);
    %         subplot(3,2,5);
    %         hold on;
    %         title('AP Events');
    %         xlabel('Time(ms)');
    %         ylabel('Intensity');
    %         for i=1:(length(chopData))
    %             chopsize = size((chopData{i,1}),1);
    %             chopsize1 = chopsize* (1000/Fs);
    %             chopTime = linspace(0,chopsize1,chopsize);
    %             chopTime = chopTime.' ;
    %             plot(chopTime,chopData{i,1}),...
    %                 'DisplayName';sprintf('x-vs-sin(%d*x)',i);
    %
    %         end;
    %         plot(get(gca,'xlim'),[threshold threshold]);
    %         set (gca , 'OuterPosition' , [0 , 0 , 0.525 ,0.375]);
    %         maxAP = max (chopData{i});
    %         ylim([-0.1 , (maxAP+0.1)]);
    
    
    
    
    %set up arrays to save the processed data
    
    apd30 = zeros(numTraces,1);
    apd50 = zeros(numTraces,1);
    apd90 = zeros(numTraces,1);
    % dFoverF = zeros(numEvents,1);
    %     upstrokeDuration = zeros(numEvents,1);
    % %     SNR = zeros(numEvents,1);
    %     actTime = zeros(numEvents,1);
    %     depolarTime = zeros (numEvents,1);
    
    %BeatCalc
    %         [BPM , interEinter] = BeatCalc(numEvents, timeElap, eventStart, eventEnd);
    %Duration calculation
    %         for i = 1:numEvents
    %load the relevant AP
    data = currentTrace;
    
    %normalize the one dimensional input data
    minimum = min(data);
    maximum = max(data);
    difference = maximum-minimum;
    apd_data = (data-minimum)./difference;
    
    %%Determining activation time point and dF/dt max
    % Find First Derivative and time of maximum
    apd_data2 = diff(apd_data,1,1); % first derivative
    [max_der , max_i] = max(apd_data2,[],1); % find location of max derivative
    
    
    % Calculate dF/dt max and activation time
    [dFdt_max , max_i] = max(apd_data2,[],1); % find location of max derivative
    %         actTime(i) = max_i /Fs;
    
    %%Find maximum of the signal
    [maxVal , maxValI] = max(apd_data);
    
    
    %set up a variable for the index90 and index50
    index90 = 0;
    index50 = 0;
    index30 = 0;
    %%convert maxi to time of deoplar
    maxdepolTime = max_i/Fs ;
    %%save the trace for separate plot
    traceCV{jj,1}=corrData ;
    traceCV{jj,2}=time ;
    traceCV{jj,3} = maxdepolTime ;
    %starting from the peak of the signal, loop until we reach value for APD90
    for k = maxValI:size(apd_data)
        if apd_data(k) <= requiredVal90
            index90 = k; %Save the index when the baseline is reached
            %this is the repolarization time point
            break;
        end
    end
    
    %starting from the peak of the signal, loop until we reach value for APD50
    for k = maxValI:size(apd_data)
        if apd_data(k) <= requiredVal50
            index50 = k; %Save the index when the baseline is reached
            %this is the repolarization time point
            break;
        end
    end
    %starting from the peak of the signal, loop until we reach value for APD30
    for k = maxValI:size(apd_data)
        if apd_data(k) <= requiredVal30
            index30 = k; %Save the index when the baseline is reached
            %this is the repolarization time point
            break;
        end
    end
    if (index50 == 0 || index90 == 0 || index30 == 0)
        disp([i ' Did not find correct apd.']);
        
    end
    
    %%calculate APD in frames between max inflection and point where
    %%it dropped
    diffIndex90 = index90 - max_i;
    diffIndex50 = index50 - max_i;
    diffIndex30 = index30 - max_i;
    %%Calculate the APD in ms using indices above
    apd90 = diffIndex90*(1000/Fs);
    apd50 = diffIndex50*(1000/Fs);
    apd30 = diffIndex30*(1000/Fs);
    
    %     %%Calculate rise time of APs
    %     depolar = apd_data((maxValI-(0.1*Fs)):(maxValI+(0.05*Fs))); %identifies the depolarization curve, starts from 100 ms before the maxvalue
    %     upstrokeDuration(i) = (risetime(depolar,Fs) * Fs);
    
    
    %%Calculate dF/F0 for trace
    [dF_F , dF , z , zz] = lambert_dFoverF(smoothData);
end
%%Peak signal to noise ratio (SNR)
%         [SNR] = lambert_SNRCalc(eventStart(end) , currentTrace , dF , Fs);
%
%sanitizing for negative APD
apd90(apd90 < 0) = [];
apd50(apd50 < 0) = [];
apd30(apd30 < 0) = [];

%         %%save variables and traces before exit
%         save(fullOutputName,'apd50');
%         save(fullOutputName,'apd90','-append');
%         save(fullOutputName,'apd30','-append');
%         %     save(fullOutputName,'actTime','-append');
%         save(fullOutputName,'dF_F','-append');
% %         save(fullOutputName,'SNR','-append');
%         %     save(fullOutputName,'upstrokeDuration','-append');
%         save(fullOutputName,'currentTrace','-append');
%         save(fullOutputName,'smoothData','-append');
%         save(fullOutputName,'corrData','-append');
%         save(fullOutputName,'chopData','-append');
%         save(fullOutputName,'time','-append');
%         %     save(fullOutputName,'depolarTime','-append');
%         save(fullOutputName,'BPM','-append');
%         save(fullOutputName,'interEinter','-append');
%
%         %Calculate mean and SD for each parameter
%         avg_apd50 = mean(apd50);
%         avg_apd90 = mean(apd90);
%         avg_apd30 = mean(apd30);
%         %     avg_dFoverF = mean(dFoverF);
%         %     avg_upstrokeDuration = mean(upstrokeDuration);
%         %     avg_depolarTime = mean(depolarTime);
%         avg_interEinter = mean(interEinter);
%
%         %Calculate standard deviations
%         std_apd50 = std(apd50);
%         std_apd90 = std(apd90);
%         std_apd30 = std(apd30);
%         %     std_dFoverF = std(dFoverF);
%         %     std_upstrokeDuration = std(upstrokeDuration);
%         %     std_depolarTime = std(depolarTime);
%         std_interEinter = std(interEinter);

%Add the mean apd and sd values to the current figure%
% %     get (h);
%         set (0 , 'currentfigure' , h);
%         subplot (3,2,6);
%         text (0.05 , 0.75  , ['APD30:  '  num2str(round(avg_apd30 , 1))  '+/-'  num2str(round(std_apd30 , 1))] , 'FontSize' , 12);
%         text (0.05 , 0.5 , ['APD50:  '  num2str(round(avg_apd50 , 1))  '+/-'  num2str(round(std_apd50 , 1))], 'FontSize' , 12);
%         text (0.05 , 0.25 , ['APD90:  '  num2str(round(avg_apd90 , 1))  '+/-'  num2str(round(std_apd90 , 1))], 'FontSize' , 12);
%         text (0.05 , 0.0 , ['dF/F:  '  num2str(round(dF_F , 3)) '  SNR:  ' num2str(round(SNR , 1))], 'FontSize' , 12) ;
%         set (gca , 'Visible', 'off');
%
%         %Create table of values%
%         stat = {'apd30' ; 'apd50' ; 'apd90' ; 'SNR' ; 'BPM' ; 'Interevent Interval'};
%         Mean = {avg_apd30 ; avg_apd50 ; avg_apd90 ; SNR ; BPM ; avg_interEinter};
%         Std = {std_apd30 ; std_apd50 ; std_apd90 ; [] ; [] ; std_interEinter};
%
%         cAP_Data = table (Mean , Std, ...
%             'RowNames', stat);
%
%         %Save table
%         save (fullOutputName,'cAP_Data','-append');
%
%         %Save figure
%         saveas(gcf,fullOutputName,'pdf'); %save as a pdf
%         saveas(gcf,fullOutputName,'png'); %save as a png
%         saveas(gcf,fullOutputName); %save as matlab fig);
%
%         %Plot data from dFoverF
%         figure;
%         hold on;
%         plot(smoothData);
%         plot(z);
%         plot(zz);
%
%     else if eventDetector == 1 %case where no events were detected
%
%             subplot(3,2,5);
%             text (0.05 , 0.5 , 'No events detected' , 'FontSize' , 12) ;
%             set (gca , 'Visible', 'off');
%             give cAP_Data output a string message
%             cAP_Data = 'No Events Dectected, no analysis available' ;
%             save (fullOutputName,'cAP_Data');
%             Save figure
%             saveas(h,fullOutputName,'pdf'); %save as a pdf
%             saveas(h,fullOutputName,'png'); %save as a png
%             saveas(h,fullOutputName); %save as matlab fig);
%
%         end
%
%     end

end