function [] = APDCorrect()

%Write script to plot APD and find cycle length (CL, 1/BPM). Finds a linear
%best fit to then correct APDs to find APDc values.

%Define variables
allAvg_apd50 = zeros(1);
allAvg_apd90 = zeros(1);
allAvg_apd30 = zeros(1);
allCL = zeros(1);
allstd_apd50 = zeros(1);
allstd_apd90 = zeros(1);
allstd_apd30 = zeros(1);

%Load APD and BPM from traces
%%select .mat files generated from apdCalc analyze
[Filelist,Pathname] = uigetfile('C:\Users\Steven Boggess\Documents\Miller Lab\Data\*.mat','File Selector','MultiSelect','on');
allData  = struct();
numFiles = numel(Filelist);
for iFile = 1:numFiles              % Loop over found files
    Data = load(fullfile(Pathname, Filelist{1,iFile}));
    Data = rmfield(Data , 'cAP_Data') ; %remove the table from files, avoid error
    Fields = fieldnames(Data);
    for iField = 1:numel(Fields)              % Loop over fields of current file
        aField = Fields{iField};
        switch (aField)
            case 'apd30'
                apd30 = Data.(aField);
            case 'apd50'
                apd50 = Data.(aField);
            case 'apd90'
                apd90 = Data.(aField);
            case 'BPM'
                BPM = Data.(aField);
        end
    end
    %Taking values from file in current loop, calculate CL and APD values.
    %plot these values
    %Calculate mean APD
    avg_apd30 = mean(apd30);
    avg_apd50 = mean(apd50);
    avg_apd90 = mean(apd90);
    
    %Calculate standard deviations
    std_apd30 = std(apd30);
    std_apd50 = std(apd50);
    std_apd90 = std(apd90);
    
    %Calculate Cycle Length (CL)
    CL = 60/(BPM);
    
    %Insert and combine values
    if   (allAvg_apd50(1,1) == 0)
        allAvg_apd50 = avg_apd50;
        allAvg_apd90 = avg_apd90;
        allAvg_apd30 = avg_apd30;
        allCL = CL;
        allstd_apd50 = std_apd50;
        allstd_apd90 = std_apd90;
        allstd_apd30 = std_apd30;
    else
        allAvg_apd50(end+1) = avg_apd50;
        allAvg_apd90(end+1) = avg_apd90;
        allAvg_apd30(end+1) = avg_apd30;
        allCL(end+1) = CL;
        allstd_apd50(end+1) = std_apd50;
        allstd_apd90(end+1) = std_apd90;
        allstd_apd30(end+1) = std_apd30;
    end
end

%Find line of best fit to this apd50 data with linear regression
[polyAPD50, Sapd50] = polyfit(allCL,allAvg_apd50,1);
Calc50CL1 = polyval(polyAPD50 , 1); %Value of APD50 at CL of 1

%Now find cAPD50 values
APD50c = zeros(length(allAvg_apd50),1);

for j = 1:length(allAvg_apd50)
    APD50c(j) = (allAvg_apd50(j)*(Calc50CL1/(polyval(polyAPD50,(allCL(j))))));
end


%Find line of best fit to this apd90 data with linear regression
[polyAPD90, Sapd90] = polyfit(allCL,allAvg_apd90,1);
Calc90CL1 = polyval(polyAPD90 , 1);

%Now find cAPD90 values
APD90c = zeros(length(allAvg_apd90),1);

for k = 1:length(allAvg_apd90)
    APD90c(k) = ((allAvg_apd90(k)*(Calc90CL1/(polyval(polyAPD90,(allCL(k)))))));
end

%Find line of best fit to this apd30 data with linear regression
[polyAPD30, Sapd30] = polyfit(allCL,allAvg_apd30,1);
Calc30CL1 = polyval(polyAPD30 , 1);

%Now find cAPD30 values
APD30c = zeros(length(allAvg_apd30),1);

for k = 1:length(allAvg_apd30)
    APD30c(k) = ((allAvg_apd30(k)*(Calc30CL1/(polyval(polyAPD30,(allCL(k)))))));
end

%transpose

allAvg_apd90 = allAvg_apd90.';
allAvg_apd50 = allAvg_apd50.';
allAvg_apd30 = allAvg_apd30.';
allCL = allCL.';

%Save the current data set

correctionFilename = input ('Please provide filename  ');
if isempty(correctionFilename) == 1;
    disp ('Please provide a string');
    filename = input('Please provide filename  ');
else
end
if ischar(correctionFilename) == 0;
    disp ('Please provide a character in single quotations');
    correctionFilename = input('Please provide filename  ');
else
end

ThefullOutputName = [Pathname correctionFilename];

save(ThefullOutputName,'allCL');
save(ThefullOutputName,'APD30c','-append');
save(ThefullOutputName,'APD50c','-append');
save(ThefullOutputName,'APD90c','-append');

%Plot and save figures

figure('name','APD50 correction','numbertitle','off');
hold on;
title('APD50');
xlabel('Cycle Length');
ylabel('APD50(ms)');
scatter(allCL , allAvg_apd50 , 'r' , 's' , 'filled');
plot(allCL , polyval(polyAPD50,allCL), '--'); %plot the line of best fit
scatter(allCL , APD50c,'o','o','filled'); %plot corrected values
legend('Data' , 'Linear fit' , 'Corrected Data' ,'Location' , 'best');

figure('name','APD90 correction','numbertitle','off');
hold on;
title('APD90');
xlabel('Cycle Length');
ylabel('APD90(ms)');
scatter(allCL , allAvg_apd90 , 'b' , 's' , 'filled');
plot(allCL , polyval(polyAPD90,allCL), '--');  %plot the line of best fit
scatter(allCL , APD90c,'m','o','filled');
legend('Data','Linear fit' , 'Corrected Data','Location','best');

figure('name','APD30 correction','numbertitle','off');
hold on;
title('APD30');
xlabel('Cycle Length');
ylabel('APD30(ms)');
scatter(allCL , allAvg_apd30 , 'b' , 's' , 'filled');
plot(allCL , polyval(polyAPD30,allCL), '--');  %plot the line of best fit
scatter(allCL , APD30c,'m','o','filled');
legend('Data','Linear fit' , 'Corrected Data','Location','best');

%Start to analyze other data sets
choice = questdlg('Would you like to apply this to other data?','Data selection', ...
    'Yes Please','No Thank You','Yes Please');

while (strcmp(choice,'Yes Please'))
    [Filelist,Pathname] = uigetfile('C:\Users\Steven Boggess\Documents\Miller Lab\Data\*.mat','Select files to correct','MultiSelect','on');
    
    %Define variables
    NallAvg_apd30 = zeros(1);
    NallAvg_apd50 = zeros(1);
    NallAvg_apd90 = zeros(1);
    NallCL = zeros(1);
    Nallstd_apd30 = zeros(1);
    Nallstd_apd50 = zeros(1);
    Nallstd_apd90 = zeros(1);
    
    for q = 1:length(Filelist)
        %do your shenanigans
        Data = load(fullfile(Pathname, Filelist{1,q}));
        Fields = fieldnames(Data);
        
        for iField = 1:numel(Fields)              % Loop over fields of current file
            aField = Fields{iField};
            switch (aField)
                case 'cAP_Data'
                    Data = rmfield(Data , 'cAP_Data') ; %remove the table from files, avoid error. might need to move this around
                case 'apd30'
                    apd30 = Data.(aField);
                case 'apd50'
                    apd50 = Data.(aField);
                case 'apd90'
                    apd90 = Data.(aField);
                case 'BPM'
                    BPM = Data.(aField);
            end
        end
        %Taking values from file in current loop, calculate CL and APD values.
        %plot these values
        %Calculate mean APD
        Navg_apd30 = mean(apd30);
        Navg_apd50 = mean(apd50);
        Navg_apd90 = mean(apd90);
        
        %Calculate standard deviations
        Nstd_apd30 = std(apd30);
        Nstd_apd50 = std(apd50);
        Nstd_apd90 = std(apd90);
        
        %Calculate Cycle Length (CL)
        NCL = 60/(BPM);
        
        %Correct each apd value in the current file
        cAPD50 = zeros(length(apd50),1);
        
        for j = 1:length(apd50)
            cAPD50(j) = ((apd50(j)*(Calc50CL1/(polyval(polyAPD50,(NCL))))));
        end
        %Now find cAPD90 values
        cAPD90 = zeros(length(apd90),1);
        
        for k = 1:length(apd90)
            cAPD90(k) = ((apd90(k)*(Calc90CL1/(polyval(polyAPD90,(NCL))))));
        end
        %Now find cAPD30 values
        cAPD30 = zeros(length(apd30),1);
        
        for k = 1:length(apd30)
            cAPD30(k) = ((apd30(k)*(Calc30CL1/(polyval(polyAPD30,(NCL))))));
        end
        %append the calculated cAPD values to the current file
        currentFileName = [Pathname Filelist{1,q}];
        save(currentFileName,'cAPD30','-append');
        save(currentFileName,'cAPD50','-append');
        save(currentFileName,'cAPD90','-append');
        
        %Insert and combine values
        if   (NallAvg_apd50(1,1) == 0)
            NallAvg_apd30 = Navg_apd30;
            NallAvg_apd50 = Navg_apd50;
            NallAvg_apd90 = Navg_apd90;
            NallCL = NCL;
            Nallstd_apd30 = Nstd_apd30;
            Nallstd_apd50 = Nstd_apd50;
            Nallstd_apd90 = Nstd_apd90;
        else
            NallAvg_apd30(end+1) = Navg_apd30;
            NallAvg_apd50(end+1) = Navg_apd50;
            NallAvg_apd90(end+1) = Navg_apd90;
            NallCL(end+1) = NCL;
            Nallstd_apd30(end+1) = Nstd_apd30;
            Nallstd_apd50(end+1) = Nstd_apd50;
            Nallstd_apd90(end+1) = Nstd_apd90;
        end
    end %end of file loop. From here, everything is one file of mean corrected values
    
    %Now find cAPD30 values
    NAPD30c = zeros(length(NallAvg_apd30),1);
    
    for p = 1:length(NallAvg_apd30)
        NAPD30c(p) = ((NallAvg_apd30(p)*(Calc30CL1/(polyval(polyAPD30,(NallCL(p)))))));
    end
    
    %Now find cAPD50 values
    NAPD50c = zeros(length(NallAvg_apd50),1);
    
    for j = 1:length(NallAvg_apd50)
        NAPD50c(j) = ((NallAvg_apd50(j)*(Calc50CL1/(polyval(polyAPD50,(NallCL(j)))))));
    end
    %Now find cAPD90 values
    NAPD90c = zeros(length(NallAvg_apd90),1);
    
    for k = 1:length(NallAvg_apd90)
        NAPD90c(k) = ((NallAvg_apd90(k)*(Calc90CL1/(polyval(polyAPD90,(NallCL(k)))))));
    end
    %Plot values
    
    NallAvg_apd90 = NallAvg_apd90.';
    NallAvg_apd50 = NallAvg_apd50.';
    NallAvg_apd30 = NallAvg_apd30.';
    NallCL = NallCL.';
    
    figure('name','cAPD data','numbertitle','off');
    subplot(3,1,2);
    hold on;
    title('APD50');
    xlabel('Cycle Length');
    ylabel('APD50(ms)');
    scatter(NallCL , NallAvg_apd50 , 'r' , 's' , 'filled');
    %     plot(NallCL , polyval(polyAPD50,NallCL), '--'); %plot the line of best fit
    scatter(NallCL , NAPD50c,'o','o','filled'); %plot corrected values
    legend('Data' , 'Linear fit' , 'Corrected Data' ,'Location' , 'best');
    
    subplot(3,1,3);
    hold on;
    title('APD90');
    xlabel('Cycle Length');
    ylabel('APD90(ms)');
    scatter(NallCL , NallAvg_apd90 , 'b' , 's' , 'filled');
    %     plot(NallCL , polyval(polyAPD90,NallCL), '--');  %plot the line of best fit
    scatter(NallCL , NAPD90c,'m','o','filled');
    legend('Data','Linear fit' , 'Corrected Data','Location','best');
    
    subplot(3,1,1);
    hold on;
    title('APD30');
    xlabel('Cycle Length');
    ylabel('APD30(ms)');
    scatter(NallCL , NallAvg_apd30 , 'b' , 's' , 'filled');
    %     plot(NallCL , polyval(polyAPD90,NallCL), '--');  %plot the line of best fit
    scatter(NallCL , NAPD30c,'m','o','filled');
    legend('Data','Linear fit' , 'Corrected Data','Location','best');
    
    %Save the corrected data to input file
    outputName = input('provide output name for all corrected values  ');
    fullOutputName = [Pathname outputName];
    
    %Not saving the avg cAPD values for now, may replace depending on how
    %data analysis flow works
    %     save(fullOutputName,'NallCL');
    %     save(fullOutputName,'NAPD50c','-append');
    %     save(fullOutputName,'NAPD90c','-append');
    %
    %Save figure, can come back and check for fit later
    saveas(gcf,fullOutputName,'pdf'); %save as a pdf
    saveas(gcf,fullOutputName); %save as matlab fig
    
    choice = questdlg('Would you like to apply this to other data?','Data selection', ...
        'Yes Please','No Thank You','Yes Please');
end

end

