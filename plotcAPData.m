function [] = plotcAPData()
%Use this to plot previously analyzed and normalized cAP data. Will make a
%set of normalized cAP plots, and also plot APD values against a defined
%dose.

%%%%SEARCH PLOT TO CONTROL PLOT SIZE


%Define variables
allAvg_apd30 = zeros(1);
allAvg_apd50 = zeros(1);
allAvg_apd90 = zeros(1);
allstd_apd30 = zeros(1);
allstd_apd50 = zeros(1);
allstd_apd90 = zeros(1);
allAvg_cAPD30 = zeros(1);
allAvg_cAPD50 = zeros(1);
allAvg_cAPD90 = zeros(1);
allstd_cAPD30 = zeros(1);
allstd_cAPD50 = zeros(1);
allstd_cAPD90 = zeros(1);
Treatment = zeros(1); %create an x value corresponding to the current file

%select .mat files generated from apdCalc analyze
[Filelist,Pathname] = uigetfile('C:\Users\Steven Boggess\Documents\Miller Lab\Data\*.mat','File Selector','MultiSelect','on');
allData  = struct();
numFiles = numel(Filelist);
outputName = input('Please provide a name:  ');
figure('name',outputName,'numbertitle','off');
hold on
for iFile = 1:numFiles              % Loop over found files
    Data = load(fullfile(Pathname, Filelist{1,iFile}));
    currentfilename = fullfile(Filelist{iFile});
    %     Data = rmfield(Data , 'cAP_Data') ; %remove the table from files, avoid error
    Fields = fieldnames(Data);
    for iField = 1:numel(Fields)              % Loop over fields of current file
        aField = Fields{iField};
        switch (aField)
            case 'avg_apd30'
                avg_apd30 = Data.(aField);
            case 'avg_apd50'
                avg_apd50 = Data.(aField);
            case 'avg_apd90'
                avg_apd90 = Data.(aField);
            case 'std_apd30'
                std_apd30 = Data.(aField);
            case 'std_apd50'
                std_apd50 = Data.(aField);
            case 'std_apd90'
                std_apd90 = Data.(aField);
            case 'avg_cAPD30'
                avg_cAPD30 = Data.(aField);
            case 'avg_cAPD50'
                avg_cAPD50 = Data.(aField);
            case 'avg_cAPD90'
                avg_cAPD90 = Data.(aField);
            case 'std_cAPD30'
                std_cAPD30 = Data.(aField);
            case 'std_cAPD50'
                std_cAPD50 = Data.(aField);
            case 'std_cAPD90'
                std_cAPD90 = Data.(aField);
            case 'normcAP'
                normcAP = Data.(aField);
            case 'meancAP'
                meancAP = Data.(aField);
        end
    end
    
    
    %%Read length of meancAP to plot time
    
    disp (currentfilename) %Show the file you are working with
    %     Fs = input('What was the sampling rate?  '); %Ask for the sampling rate to give input for apdCalc (in Hz or fps)
    Fs = 200 ;
    dataTitle = input('What would you like to call this data set?  ');
    numframes = length (meancAP);
    timeElap = numframes*(1/Fs);
    time = zeros (numframes,1); %pre-allocate;
    cnt = 1; %start the count;
    for ii = (1:numframes)
        time(cnt) = (ii/Fs);
        cnt = cnt + 1;
    end
    time = time*1000;
    
    %plot the normal cAPs and the meancAP
%     subplot (1, 1, iFile); %Edit this to adjust the ap plot dimensions
     subplot (1, 1, 1); %Edit this to adjust the ap plot dimensions
    hold on;
    numEvents = length(normcAP);
    for i= 1:numEvents
        numframes2 = length (normcAP{i,1});
        timeElap2 = numframes2*(1/Fs);
        time2 = zeros (numframes2,1); %pre-allocate;
        cnt = 1; %start the count;
        for ii = (1:numframes2)
            time2(cnt) = (ii/Fs);
            cnt = cnt + 1;
        end
        time2 = time2*1000;
        plot (time2, normcAP{i,1});
    end
    plotColor = input ('What color for this plot? Use matlab shortcuts  ');
    plot (time,meancAP,'LineWidth',3,...
        'Color' , plotColor);
    title(dataTitle);
    xlabel('Time(ms)');
    ylabel('Intensity');
    %END OF PLOTTING cAP's FOR CURRENT FILE
    
    %%Store apd and cAPD values to create linear plot of APD vs treatment
    
    
%     %Define the treatment value
%     Treatment = input('Input the treatment value (Drug conc., stimulation, etc.): ');
%     
%     %Insert and combine values
%     if   (allAvg_apd50(1,1) == 0)
%         allAvg_apd30 = avg_apd30;
%         allAvg_apd50 = avg_apd50;
%         allAvg_apd90 = avg_apd90;
%         allstd_apd30 = std_apd30;
%         allstd_apd50 = std_apd50;
%         allstd_apd90 = std_apd90;
%         allAvg_cAPD30 = avg_cAPD30;
%         allAvg_cAPD50 = avg_cAPD50;
%         allAvg_cAPD90 = avg_cAPD90;
%         allstd_cAPD30 = std_cAPD30;
%         allstd_cAPD50 = std_cAPD50;
%         allstd_cAPD90 = std_cAPD90;
%         allTreatment = Treatment;
%     else
%         allAvg_apd30(end+1) = avg_apd30;
%         allAvg_apd50(end+1) = avg_apd50;
%         allAvg_apd90(end+1) = avg_apd90;
%         allstd_apd30(end+1) = std_apd30;
%         allstd_apd50(end+1) = std_apd50;
%         allstd_apd90(end+1) = std_apd90;
%         allAvg_cAPD30(end+1) = avg_cAPD30;
%         allAvg_cAPD50(end+1) = avg_cAPD50;
%         allAvg_cAPD90(end+1) = avg_cAPD90;
%         allstd_cAPD30(end+1) = std_cAPD30;
%         allstd_cAPD50(end+1) = std_cAPD50;
%         allstd_cAPD90(end+1) = std_cAPD90;
%         allTreatment(end+1) = Treatment;
%     end
%     
% end
% 
% % % Plot all values
% figure('name',input('Give experiment title:  '),'numbertitle','off');
% 
% subplot(2,1,1);
% hold on;
% title('Uncorrected');
% xlabel(input('Provide x-axis:  '));
% ylabel('Duration (ms)');
% xlim([-1 inf])
% errorbar (allTreatment , allAvg_apd50 , allstd_apd50 , allstd_apd50, 'o', ...
%     'Color', 'b', ...
%     'MarkerFaceColor' , 'b' , ...
%     'MarkerEdgeColor' , 'b'); %plotting details
% % % 'LineWidth' , 2 , ...
% choice = questdlg('Would you like to plot in logx?','XAxis Modification', ...
%     'Yes Please','No Thank You','No Thank You');
% 
% if (strcmp(choice,'Yes Please'))
%     set(gca,'xscale','log');
% end
% 
% errorbar (allTreatment , allAvg_apd90 , allstd_apd90 , allstd_apd90, 'o', ...
%     'Color', 'r', ...
%     'MarkerFaceColor' , 'r' , ...
%     'MarkerEdgeColor' , 'r'); %plotting details
% % % 'LineWidth' , 2 , ...
% errorbar (allTreatment , allAvg_apd30 , allstd_apd30 , allstd_apd30, 'o', ...
%     'Color', 'g', ...
%     'MarkerFaceColor' , 'g' , ...
%     'MarkerEdgeColor' , 'g'); %plotting details
% % % 'LineWidth' , 2 , ...
% legend('APD 50' , 'APD 90' , 'APD 30','Location' , 'best');
% 
% subplot(2,1,2);
% hold on;
% title('Corrected');
% xlabel(input('Provide x-axis:  '));
% ylabel('Duration (ms)');
% xlim([-1 inf])
% errorbar (allTreatment , allAvg_cAPD50 , allstd_cAPD50 , allstd_cAPD50, 'o', ...
%     'Color', 'b', ...
%     'MarkerFaceColor' , 'b' , ...
%     'MarkerEdgeColor' , 'b'); %plotting details
% % % 'LineWidth' , 2 , ...
% choice = questdlg('Would you like to plot in logx?','XAxis Modification', ...
%     'Yes Please','No Thank You','No Thank You');
% 
% if (strcmp(choice,'Yes Please'))
%     set(gca,'xscale','log');
% end
% errorbar (allTreatment , allAvg_cAPD90 , allstd_cAPD90 , allstd_cAPD90, 'o', ...
%     'Color', 'r', ...
%     'MarkerFaceColor' , 'r' , ...
%     'MarkerEdgeColor' , 'r'); %plotting details
% % % 'LineWidth' , 2 , ...
% errorbar (allTreatment , allAvg_cAPD30 , allstd_cAPD30 , allstd_cAPD30, 'o', ...
%     'Color', 'g', ...
%     'MarkerFaceColor' , 'g' , ...
%     'MarkerEdgeColor' , 'g'); %plotting details
% % % 'LineWidth' , 2 , ...
% legend('cAPD 50' , 'cAPD 90' , 'cAPD 30' ,'Location' , 'best');
% 
% 
% % write something here to save everything!


end